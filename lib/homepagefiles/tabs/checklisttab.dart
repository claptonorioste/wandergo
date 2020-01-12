import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_listview/grouped_listview.dart';
import 'package:wandergo/datafiles/expensesmodel.dart';
import 'package:wandergo/datafiles/offlinedatabase.dart';
import 'package:wandergo/datafiles/someList.dart';

class Checklist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChecklistState();
  }
}

class ChecklistState extends State<Checklist> {
  List<ExpensesModel> expensesContainer = [];
  var now = new DateTime.now();
  final db = ExpenseDatabase();

  Map<String, bool> checkBoxValue = {};

 @override
  void initState() {

    super.initState();
     setupList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildExpensesList(expensesContainer),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          bottomSheet();
        },
        backgroundColor: Color(0xff086375),
      ),
    );
  }

  Widget _buildExpensesList(List<ExpensesModel> expenseList) {
    return GroupedListView<ExpensesModel, String>(
      collection: expenseList,
      groupBy: (ExpensesModel g) => g.date,
      listBuilder: (BuildContext context, ExpensesModel model) {
        return model.date != ""
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[100]))),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (newValue) {},
                  value: false,
                  title: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15.0),
                            ),
                            Text(
                              model.label,
                              style: TextStyle(color: Color(0xff086375)),
                            ),
                          ],
                        ),
                        (model.label != "Refund")
                            ? (model.label != "Income")
                                ? Text(
                                    "-  ₱" + model.amount.toStringAsFixed(2),
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text("+ ₱" + model.amount.toStringAsFixed(2),
                                    style: TextStyle(color: Colors.green))
                            : Text("+ ₱" + model.amount.toStringAsFixed(2),
                                style: TextStyle(color: Colors.green))
                      ],
                    ),
                  ),
                ),
              )
            : Container();
      },
      groupBuilder: (BuildContext context, String dbDate) {
        String checkDateNow = day[now.weekday - 1] +
            " " +
            month[now.month - 1] +
            " " +
            now.day.toString();
        final x = DateTime(now.year, now.month, now.day - 1, 6, 30);
        String dateYes = (day[x.weekday - 1] +
            " " +
            month[x.month - 1] +
            " " +
            x.day.toString());
        if (dateYes == dbDate) {
          dbDate = "Yesterday";
        }

        if (checkDateNow == dbDate) {
          dbDate = "Today";
        }

        return dbDate != ""
            ? Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      dbDate,
                      style: TextStyle(fontSize: 11, color: Colors.black),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }

  void setupList() async {
    var _allExpense = await db.fetchAll();

    setState(() {
      expensesContainer = _allExpense.reversed.toList();
    });
  }

  bottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalstate) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Color(0xff086375),fontSize: 20),
                            cursorColor: Color(0xff086375),
                  
                            decoration: InputDecoration.collapsed(
                                hintText: 'e.g. Passport',
                                hintStyle: TextStyle(
                                  
                                    color: Colors.grey, fontSize: 20)),
                            autofocus: true,
                          ),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Color(0xff086375),
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          });
        });
  }
}
