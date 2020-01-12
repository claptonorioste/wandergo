import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:wandergo/datafiles/expensesmodel.dart';
import 'package:wandergo/datafiles/plannermodel.dart';

import 'amountModel.dart';

class ExpenseDatabase {
  static final ExpenseDatabase _instance = ExpenseDatabase._();
  static Database _database;

  ExpenseDatabase._();

  factory ExpenseDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'expense.db');
    var database = openDatabase(dbPath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE tblexpense(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT,
        amount REAL,
        icon INTEGER,
        date TEXT,
        isDeleted INTEGER
        )
    ''');

    

    db.execute('''
      CREATE TABLE tblamount(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mainid INTEGER,
        amount REAL
        )
    ''');

      db.execute('''
      CREATE TABLE tblplanner(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listLabel TEXT,
        date TEXT,
        isDone INTEGER,
        isDeleted INTEGER
        )
    ''');

  
    print("Database was created!");
  }



  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> addExpense(ExpensesModel expense) async {

    var client = await db;
    return client.insert('tblexpense', expense.toMapForDb(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

   Future<int> addPlan(PlannerModel plan) async {

    var client = await db;
    return client.insert('tblplanner', plan.toMapForDb(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  
  

  

  Future<int> setAmount(AmountModel amount) async {
    var client = await db;
    return client.insert('tblamount', amount.toMapForDb(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<AmountModel> fetchAmount(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query('tblamount', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;

    if (maps.length != 0) {
      return AmountModel.fromDb(maps.first);
    }

    return null;
  }


  Future<ExpensesModel> fetchExpense(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query('tblexpense', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;

    if (maps.length != 0) {
      return ExpensesModel.fromDb(maps.first);
    }

    return null;
  }

  Future<List<ExpensesModel>> fetchAll() async {
    var client = await db;
    var res = await client.query('tblexpense');
    

    if (res.isNotEmpty) {
      var thisexpense = res.map((expenseMap) => ExpensesModel.fromDb(expenseMap)).toList();
      return thisexpense;
    }
    return [];
  }
Future<List<PlannerModel>> fetchPlan() async {
    var client = await db;
    var res = await client.query('tblplanner');
    if (res.isNotEmpty) {
      var thisexpense = res.map((expenseMap) => PlannerModel.fromDb(expenseMap)).toList();
      return thisexpense;
    }
    return [];
  }


   
    


  Future<List<AmountModel>> fetchAllamount() async {
    var client = await db;
    var res = await client.query('tblamount');


    if (res.isNotEmpty) {
      var thisamount = res.map((amountMap) => AmountModel.fromDb(amountMap)).toList();
      return thisamount;
    }
    return [];
  }

  Future<int> updateExpense(ExpensesModel thisexpense) async {
    var client = await db;
    return client.update('tblexpense', thisexpense.toMapForDb(),
        where: 'id = ?', whereArgs: [thisexpense.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

   Future<int> updateAmount(AmountModel thisamount) async {
    var client = await db;
    return client.update('tblamount', thisamount.toMapForDb(),
        where: 'id = ?', whereArgs: [thisamount.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeExpense(int id) async {
    var client = await db;
    return client.delete('tblexpense', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeAmount(int id) async {
    var client = await db;
    return client.delete('tblamount', where: 'id = ?', whereArgs: [id]);
  }
  




  Future<void> removeAll() async {
    var client = await db;
    return client.delete('tblexpense');
  }

  Future<void> removeAllAmount() async {
    var client = await db;
    return client.delete('tblamount');
  }

  Future<void> removePlan() async {
    var client = await db;
    return client.delete('tblplanner');
  }

 

  Future closeDb() async {
    var client = await db;
    client.close();
  }
}


