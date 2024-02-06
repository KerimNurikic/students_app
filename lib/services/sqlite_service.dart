//import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    //WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        // await database.execute(
        //   'CREATE TABLE events(date TEXT, title TEXT, description TEXT, isToDo INTEGER, isDone INTEGER)'
        // );
        // await database.execute(
        //   'CREATE TABLE expenses(itemsBought TEXT, totalExpense REAL, date TEXT, isBuy INTEGER, description TEXT)'
        // );
        await database.execute(
            'CREATE TABLE quotes(id INTEGER PRIMARY KEY, quoteText TEXT, quoteAuthor TEXT, quoteCategory TEXT)');
      },
      version: 1,
    );
  }

  Future<void> addFavoriteQuote(Quote quote) async {
    final Database db = await initializeDB();
    await db.insert('quotes', quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Quote>> getFavoriteQuotes() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> favoriteQuoteMaps =
        await db.query('quotes');
    return favoriteQuoteMaps.map((quote) => Quote.fromMap(quote)).toList();
  }

  Future<void> deleteFavoriteQuote(Quote quote) async {
    final db = await initializeDB();
    int id = quote.id ?? -1;
    if (id != -1) {
      await db.delete(
        'quotes',
        where: 'id=?',
        whereArgs: [quote.id],
      );
    }
  }
}
