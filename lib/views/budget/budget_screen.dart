import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

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
                              child: const Text('Scan text'),
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
      //print(recognizedText.blocks.length);
      // int i = 0;
      // for (var block in recognizedText.blocks) {
      //   //print('block $i');
      //   //print(block.text);
      //   //int j = 0;
      //   // for (var line in block.lines) {
      //   //   print('line $j');
      //   //   // print(line.text);
      //   //   j++;
      //   // }
      //   i++;
      // }

      if (context.mounted) {
        if (recognizedText.text.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Text scanned successfully'),
            ),
          );
        }
      }

      getDataFromScannedText(recognizedText);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred when scanning text'),
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
            print('price');
            print(price);
            continue;
          }
        }
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
        if (line.text
                    .substring(line.text.length - 1, line.text.length) ==
                'E' ||
            line.text
                    .substring(line.text.length - 1, line.text.length) ==
                'F' ||
            line.text.substring(line.text.length - 1, line.text.length) ==
                'f' ||
            line.text.substring(line.text.length - 1, line.text.length) ==
                '£') {
          var itemPriceUnformatted =
              line.text.substring(0, line.text.length - 1);
          final removeWhiteSpace = itemPriceUnformatted.replaceAll(' ', '');
          final removePoints = removeWhiteSpace.replaceAll('.', '').trim();
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
    if (buyDate != null && pricesSum == totalPrice){
      _openExpenseDialog(buyDate,totalPrice,itemNames,itemPrices);    
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to correctly format the bill'),
          ),
        );
    }
      
  }
  void _openExpenseDialog(DateTime buyDate, double totalPrice, List<String> itemNames, List<double> itemPrices){
    
  }
}
