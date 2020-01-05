import 'package:http/http.dart' as http;
import 'package:wandergo/datafiles/amountmodelonline.dart';
import 'dart:convert';

import 'package:wandergo/datafiles/expensemodelonline.dart';

var expense = List<ExpensesModelOn>();
var amount = List<AmountModelOn>();

Future<List<ExpensesModelOn>> getOnlineExpenseDb(String userId) async {
  final String url =
      'http://dutiful-paragraph.000webhostapp.com/get_sync_expense.php';
  try {
    http.Response response = await http.post(url, body: {"user_id": userId});
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        expense = list.map((model) => ExpensesModelOn.fromDb(model)).toList();
        return expense;
      } catch (e) {
        print("Empty database");
      }
    }
  } catch (e) {}
  return [];
}

Future<List<AmountModelOn>> getOnlineAmountDb(String userId) async {
  final String url =
      'http://dutiful-paragraph.000webhostapp.com/get_sync_amount.php';
  try {
    http.Response response = await http.post(url, body: {"user_id": userId});
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        Iterable list = json.decode(response.body);
        amount = list.map((model) => AmountModelOn.fromDb(model)).toList();
        return amount;
      } catch (e) {
        print("Empty database");
      }
    }
  } catch (e) {}
  return [];
}

Future syncExpense(String userId, String expenseId, String label, String amount,
    String icon, String date, String isDeleted) async {
  final String url =
      'http://dutiful-paragraph.000webhostapp.com/sync_expense.php';
  try {
    await http.post(url, body: {
      "user_id": userId,
      "user_expense_id": expenseId,
      "label": label,
      "amount": amount,
      "icon": icon,
      "date": date,
      "delete": isDeleted
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {}
    });
  } catch (e) {
    print(e);
  }
}

Future syncUpdateExpense(
    String userId, String expenseId, String isDeleted) async {
  final String url =
      'http://dutiful-paragraph.000webhostapp.com/sync_expense_edit.php';
  try {
    await http.post(url, body: {
      "user_id": userId,
      "user_expense_id": expenseId,
      "delete": isDeleted
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {}
    });
  } catch (e) {
    print(e);
  }
}

Future syncAmount(String userId, String amount) async {
  final String url =
      'http://dutiful-paragraph.000webhostapp.com/sync_user_amount.php';
  try {
    await http.post(url, body: {
      "user_id": userId,
      "amount": amount,
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {}
    });
  } catch (e) {
    print(e);
  }
}

Future syncUpdateAmount(String userId, String amount) async {
  final String url =
      'http://dutiful-paragraph.000webhostapp.com/sync_user_amount_edit.php';
  try {
    await http.post(url, body: {
      "user_id": userId,
      "amount": amount,
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {}
    });
  } catch (e) {
    print(e);
  }
}
