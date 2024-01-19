import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/services/expenses_service.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class BudgetScreen extends StatefulWidget {
  final Function() changePage;
  const BudgetScreen({super.key, required this.changePage});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;

  CameraController? _cameraController;

  var textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            // Show the camera feed behind everything
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _scanImage,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                minimumSize: const Size(120, 48),
                              ),
                              child: const Text('Scan',
                              style: TextStyle(fontSize: 18),),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          'Camera permission denied',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    //final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      if (context.mounted) {
        if (recognizedText.text.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bill scanned successfully'),
            ),
          );
        }
      }

      getDataFromScannedText(recognizedText);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred when scanning the bill'),
          ),
        );
      }
    }
  }

  getDataFromScannedText(RecognizedText recognizedText) {
    List<double> prices = [];
    DateTime? buyDate;
    List<double> itemPrices = [];
    List<String> itemNames = [];
    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        if ('.'.allMatches(line.text).length == 3 &&
            ':'.allMatches(line.text).length == 1) {
          var date = line.text.substring(0, 11);
          var dateSplit = date.split('.');
          var year = int.tryParse(dateSplit[2]);
          var month = int.tryParse(dateSplit[1]);
          var day = int.tryParse(dateSplit[0]);

          if (year != null && month != null && day != null) {
            buyDate = DateTime(year, month, day);
            continue;
          }
        }
        if (line.text.contains("FISKALNI") ||
            line.text.contains("RACUN") ||
            line.text.contains("BF:") ||
            line.text.contains(":") ||
            line.text.substring(line.text.length - 1, line.text.length) ==
                'x' ||
            line.text.substring(line.text.length - 1, line.text.length) ==
                'X') {
          continue;
        }
        final removePoints = line.text.replaceAll('.', '').trim();
        final replaceCommasWithPoints = removePoints.replaceAll(',', '.');
        if (replaceCommasWithPoints.isNotEmpty) {
          var price = double.tryParse(replaceCommasWithPoints);
          if (price != null) {
            prices.add(price);
            continue;
          }
        }

        if (line.text
                    .substring(line.text.length - 1, line.text.length) ==
                'E' ||
            line.text
                    .substring(line.text.length - 1, line.text.length) ==
                'F' ||
            line.text
                    .substring(line.text.length - 1, line.text.length) ==
                'f' ||
            line.text.substring(line.text.length - 1, line.text.length) ==
                '£' ||
            line.text.substring(line.text.length - 1, line.text.length) ==
                'A') {
          var itemPriceUnformatted =
              line.text.substring(0, line.text.length - 1);
          final removeWhiteSpace = itemPriceUnformatted.replaceAll(' ', '');
          String removePoints;
          if (removeWhiteSpace.length >= 4 &&
              (removeWhiteSpace.lastIndexOf(',') ==
                      removeWhiteSpace.length - 3 ||
                  removeWhiteSpace.lastIndexOf('.') ==
                      removeWhiteSpace.length - 3)) {
            removePoints = removeWhiteSpace.substring(
                    0, removeWhiteSpace.length - 4) +
                removeWhiteSpace.substring(
                    removeWhiteSpace.length - 2, removeWhiteSpace.length - 1);
          } else {
            continue;
          }
          removePoints = removeWhiteSpace.replaceAll('.', '').trim();
          final replaceCommasWithPoints = removePoints.replaceAll(',', '.');
          if (replaceCommasWithPoints.isNotEmpty) {
            var itemPrice = double.tryParse(replaceCommasWithPoints);
            if (itemPrice != null) {
              itemPrices.add(itemPrice);
              continue;
            }
          }
        }
        itemNames.add(line.text);
      }
    }
    double totalPrice = prices.elementAt(prices.length - 2);

    double pricesSum = 0;
    for (var price in itemPrices) {
      pricesSum = pricesSum + price;
    }

    if (buyDate != null &&
        pricesSum == totalPrice &&
        itemNames.length >= itemPrices.length) {
      _openExpenseDialog(buyDate, totalPrice, itemNames, itemPrices);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to correctly format the text from the bill'),
        ),
      );
    }
  }

  void _openExpenseDialog(DateTime buyDate, double totalPrice,
      List<String> itemNames, List<double> itemPrices) {
    Map<String, double> itemsBought = {};
    for (int i = 0; i < itemPrices.length; i++) {
      itemsBought[itemNames[i]] = itemPrices[i];
    }
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Scan again',
                    style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _addDescription(Expense(
                      date: buyDate,
                      totalExpense: totalPrice,
                      itemsBought: itemsBought,
                      description: "",
                      isBuy: true));
                },
                child: const Text('Confirm'),
              )
            ],
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            title: const Text(
              'Is the bill scanned correctly?',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
            ),
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                tag: buyDate.toString(),
                child: Column(
                  children: [
                    Column(children: [
                      Column(
                          children: itemsBought.entries
                              .map(
                                (e) => Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${e.key}: ${e.value.toStringAsFixed(2)} KM',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList()),
                      const SizedBox(
                        height: 10.0,
                      )
                    ]),
                    Text(
                      'Total expense: ${totalPrice.toStringAsFixed(2)} KM',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      buyDate.toString().substring(0, 10),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  void _addDescription(Expense expense) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final descriptionController = TextEditingController();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('Close', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    _addExpense(Expense(
                        date: expense.date,
                        description: descriptionController.text,
                        isBuy: true,
                        totalExpense: expense.totalExpense,
                        itemsBought: expense.itemsBought));
                  },
                  child: const Text('Confirm'),
                )
              ],
              contentPadding: EdgeInsets.zero,
              scrollable: true,
              title: const Text(
                'Add description',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
              ),
              content: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Description',
                      ),
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _addExpense(Expense expense) {
    if (expense.description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must provide a description'),
        ),
      );
    } else {
      ExpensesService().addExpense(expense);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully added the expense!'),
        ),
      );
      Navigator.of(context).pop();
      widget.changePage();
    }
  }
}
