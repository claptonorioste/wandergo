import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_listview/grouped_listview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wandergo/datafiles/amountModel.dart';
import 'package:wandergo/datafiles/amountmodelonline.dart';
import 'package:wandergo/datafiles/expensemodelonline.dart';
import 'package:wandergo/datafiles/expensesmodel.dart';
import 'package:wandergo/datafiles/offlinedatabase.dart';
import 'package:wandergo/datafiles/onlinedb.dart';
import 'package:wandergo/datafiles/someList.dart';
import 'package:toast/toast.dart';
import 'package:wandergo/homepagefiles/tabs/statistcstab.dart';

var now = new DateTime.now();

class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeTabState();
  }
}

class HomeTabState extends State<HomeTab>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final db = ExpenseDatabase();
  String thisuserId = "";
  int totalAmount = 0;
  int total = 0;
  int tap = 0;
  int lastId = 0;
  bool emptyList = false;
  

  Map onlineDB = {};

  List<ExpensesModel> expensesContainer = [];
  List<AmountModel> amountContainer = [];

  List<ExpensesModelOn> expenseonlinedbcontainer = [];
  List<AmountModelOn> amountonlinedbcontainer = [];

  TextEditingController amountController = TextEditingController();
  TextEditingController setAmount = TextEditingController();
  TextEditingController setDays = TextEditingController();

  String selectedExpense = "Food";
  String date;
  double amount = 0;
  int iconIndex = 0;

  bool isFoodseleted = true;
  bool isTransportationseletced = false;
  bool isGroceriesselected = false;
  bool isAccomodationselected = false;
  bool isDrinksselected = false;
  bool isLaundrySelected = false;
  bool isEntertainmentSelected = false;
  bool isFeesSelected = false;
  bool isActivitySelected = false;
  bool isOthersSelected = false;
  bool isIncomeSelected = false;
  bool isRefundSelected = false;

  String budget = "0.00";
  String averageExpense = "0.00";
  String totalExpenses = "0.00";

  void initState() {
    super.initState();
    
    getUserId();
    onStartup();

  }

  bool checkContainer(){
    for(int x = 0 ; x<expensesContainer.length; x++){
      if(expensesContainer[x].date == ""){
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Container(
              height: 100,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            "Daily Average Expenses",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff086375),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            "₱" + averageExpense,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff086375),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            "Total Expenses",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff086375), fontSize: 10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            "Allowance Left",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff086375), fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            "₱" + totalExpenses,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff086375), fontSize: 10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "₱" + double.parse(budget).toStringAsFixed(2),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff086375), fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Container(
            color: Colors.white,
            child: TabBar(
              indicatorColor: Color(0xff086375),
              labelColor: Color(0xff086375),
              tabs: [
                Tab(
                  text: "EXPENSES",
                ),
                Tab(
                  text: "STATISTICS",
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TabBarView(
                children: [expenses(context), Statistics()],
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget expenses(context) {
    return Scaffold(
      body: (averageExpense != "0.00")
          ? _buildExpensesList(expensesContainer)
          : Center(
              child: Container(
                child: Text("Empty"),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          bottomSheet();
        },
        backgroundColor: Color(0xff086375),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: FlatButton(
                      child: Text(
                        "Set Budget",
                        style: TextStyle(color: Color(0xff086375)),
                      ),
                      onPressed: () {
                        _setBudget(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: FlatButton(
                    child: Text(
                      "Set Budget",
                      style: TextStyle(color: Color(0xff086375)),
                    ),
                    onPressed: () {
                       _setBudget(context);
                    },
                  ),
                ))
              ],
            ),
          ),
          color: Colors.white,
          shape: CircularNotchedRectangle()),
    );
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
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "PHP ",
                              style: TextStyle(
                                  color: Color(0xff086375), fontSize: 20),
                            ),
                            Container(
                              width: 40,
                              child: TextFormField(
                                controller: amountController,
                                cursorColor: Color(0xff086375),
                                cursorWidth: 2,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Color(0xff086375)),
                                decoration: InputDecoration.collapsed(
                                    hintText: '0.00',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 20)),
                                autofocus: true,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Text(
                            selectedExpense,
                            style: TextStyle(color: Color(0xff086375)),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              expensesTypeContainer(
                                  setModalstate,
                                  "Food",
                                  isFoodseleted,
                                  Icon(
                                    Icons.local_dining,
                                    size: 30,
                                    color: Colors.orange,
                                  ),
                                  Colors.orange),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Transportation",
                                  isTransportationseletced,
                                  Icon(
                                    Icons.local_taxi,
                                    size: 30,
                                    color: Colors.blueAccent[200],
                                  ),
                                  Colors.blueAccent[200]),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Groceries",
                                  isGroceriesselected,
                                  Icon(
                                    Icons.shopping_cart,
                                    size: 30,
                                    color: Colors.lightBlue,
                                  ),
                                  Colors.lightBlue),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Accomodation",
                                  isAccomodationselected,
                                  Icon(
                                    Icons.local_hotel,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                  Colors.green),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Drinks",
                                  isDrinksselected,
                                  Icon(Icons.local_bar,
                                      size: 30, color: Colors.red),
                                  Colors.red),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Laundry",
                                  isLaundrySelected,
                                  Icon(
                                    Icons.local_laundry_service,
                                    size: 30,
                                    color: Colors.amber,
                                  ),
                                  Colors.amber),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              expensesTypeContainer(
                                  setModalstate,
                                  "Entertainment",
                                  isEntertainmentSelected,
                                  Icon(Icons.local_movies,
                                      size: 30, color: Colors.deepOrangeAccent),
                                  Colors.deepOrangeAccent),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Fees",
                                  isFeesSelected,
                                  Icon(Icons.monetization_on,
                                      size: 30, color: Colors.lightGreen),
                                  Colors.lightGreen),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Activity",
                                  isActivitySelected,
                                  Icon(
                                    Icons.rowing,
                                    size: 30,
                                    color: Colors.purple[200],
                                  ),
                                  Colors.purple[200]),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Others",
                                  isOthersSelected,
                                  Icon(
                                    Icons.help,
                                    size: 30,
                                    color: Colors.pink[200],
                                  ),
                                  Colors.pink[200]),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Income",
                                  isIncomeSelected,
                                  Icon(
                                    Icons.local_atm,
                                    size: 30,
                                    color: Colors.cyan[200],
                                  ),
                                  Colors.cyan[200]),
                              expensesTypeContainer(
                                  setModalstate,
                                  "Refund",
                                  isRefundSelected,
                                  Icon(
                                    Icons.repeat,
                                    size: 30,
                                    color: Colors.indigo[200],
                                  ),
                                  Colors.indigo[200]),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 250,
                          height: 30,
                          child: FlatButton(
                              //button
                              onPressed: () {
                                Navigator.of(context).pop();

                                try {
                                  if (amountContainer[0].amount == 0.0) {
                                    //print("Please set amount");
                                    setFailed();
                                  } else {
                                    try {
                                      amount =
                                          double.parse(amountController.text);
                                      date = day[now.weekday - 1] +
                                          " " +
                                          month[now.month - 1] +
                                          " " +
                                          now.day.toString();

                                      db.addExpense(ExpensesModel(
                                          id: expensesContainer.length + 1,
                                          label: selectedExpense,
                                          amount: amount,
                                          icon: iconIndex,
                                          date: date,
                                          isDeleted: 0));
                                    } catch (e) {
                                      Toast.show("Please enter amount", context,
                                          backgroundColor: Color(0xff086375),
                                          duration: Toast.LENGTH_SHORT,
                                          gravity: Toast.CENTER);
                                    }

                                    if (selectedExpense == "Income") {
                                      double thisamount =
                                          amountContainer[0].amount + amount;
                                      db.setAmount(AmountModel(
                                          id: 1, amount: thisamount));
                                    } else if (selectedExpense == "Refund") {
                                      double thisamount =
                                          amountContainer[0].amount + amount;
                                      db.setAmount(AmountModel(
                                          id: 1, amount: thisamount));
                                    } else {
                                      double thisamount =
                                          amountContainer[0].amount - amount;
                                      db.setAmount(AmountModel(
                                          id: 1, amount: thisamount));
                                    }
                                  }
                                } catch (e) {
                                  //print("Please set amount");
                                  setFailed();
                                }
                                setupList();
                                setState(() {
                                  amountController.clear();
                                });
                              },
                              child: Text("SUBMIT",
                                  style: TextStyle(color: Colors.white)),
                              color: Color(0xff086375),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
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

  Widget expensesTypeContainer(
    StateSetter setModalstate,
    String expensesLabel,
    bool type,
    Icon iconType,
    Color colorBtn,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: IconButton(
        icon: iconType,
        color: colorBtn,
        onPressed: () {
          setModalstate(() {
            selectedExpense = expensesLabel;
            if (expensesLabel == "Food") {
              iconIndex = 0;
              isFoodseleted = true;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Transportation") {
              iconIndex = 1;
              isFoodseleted = false;
              isTransportationseletced = true;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Groceries") {
              iconIndex = 2;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = true;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Accomodation") {
              iconIndex = 3;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = true;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Drinks") {
              isFoodseleted = false;
              iconIndex = 4;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = true;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Laundry") {
              iconIndex = 5;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = true;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Entertainment") {
              iconIndex = 6;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = true;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Fees") {
              iconIndex = 7;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = true;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Activity") {
              iconIndex = 8;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = true;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Others") {
              iconIndex = 9;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = true;
              isIncomeSelected = false;
              isRefundSelected = false;
            } else if (expensesLabel == "Income") {
              iconIndex = 10;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = true;
              isRefundSelected = false;
            } else if (expensesLabel == "Refund") {
              iconIndex = 11;
              isFoodseleted = false;
              isTransportationseletced = false;
              isGroceriesselected = false;
              isAccomodationselected = false;
              isDrinksselected = false;
              isLaundrySelected = false;
              isEntertainmentSelected = false;
              isFeesSelected = false;
              isActivitySelected = false;
              isOthersSelected = false;
              isIncomeSelected = false;
              isRefundSelected = true;
            }
          });
        },
      ),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: type ? Color(0xff086375) : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(60)),
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
                child: ListTile(
                  onTap: () {
                  
                    if (lastId == model.id) {
                      lastId = 0;
                      tap = 2;
                    } else {
                      lastId = model.id;
                      tap = 0;
                    }

                    if (tap == 2) {
                      double addThis = 0;
                      double minThis = 0;

                      addThis = amountContainer[0].amount + model.amount;
                      minThis = amountContainer[0].amount - model.amount;

                      if (model.label != "Income" && model.label != "Refund") {
                        db.setAmount(AmountModel(id: 1, amount: addThis));
                      } else {
                        db.setAmount(AmountModel(id: 1, amount: minThis));
                      }

                      onDelete(model.id, "", 0, 0, "");
                      checkInternet();
                      tap = 0;
                    }
                  },
                  title: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            expenseIcon[model.icon],
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
                    calculateExpesnses(dbDate)
                  ],
                ),
              )
            : Container();
      },
    );
  }

  onDelete(
      int id, String label, double amount, int iconIndex, String date) async {
    await db.addExpense(ExpensesModel(
        id: id,
        label: label,
        amount: amount,
        icon: iconIndex,
        date: date,
        isDeleted: 1));
    setupList();
  }

//fetch the data in the sql database
  void setupList() async {
    var _allExpense = await db.fetchAll();
    var _allAmount = await db.fetchAllamount();

    setState(() {
      expensesContainer = _allExpense.reversed.toList();
      amountContainer = _allAmount;

      

      try {
        budget = amountContainer[0].amount.toString();
      } catch (e) {
        budget = "0.0";
      }
    });
    calcE();
    checkInternet();
  }

//this function calculate the loss and gain of the expenses
  void calcE() {
    double totalLoss = 0;
    int losslenght = 0;
    for (int x = 0; x < expensesContainer.length; x++) {
      if ((expensesContainer[x].label != "Income") &&
          (expensesContainer[x].label != "Refund") &&
          (expensesContainer[x].label != "")) {
        losslenght++;
        totalLoss = totalLoss + expensesContainer[x].amount;
      }
    }
    int countDaysInt = 0;

    var countDays = Map.fromIterable(expensesContainer,
        key: (e) => e.date, value: (e) => e.label);
    var list = countDays.keys.toList();
    for (int x = 0; x < list.length; x++) {
      if (list[x] != "") {
        countDaysInt++;
      }
    }

    setState(() {
      totalExpenses = totalLoss.toStringAsFixed(2);
      averageExpense =
          ((totalLoss / losslenght) / countDaysInt).toStringAsFixed(2);
      countDaysInt = 0;

      if (averageExpense == "NaN") {
        averageExpense = "0.00";
      }
    });
  }

  Widget calculateExpesnses(String date) {
    double totalGain = 0;
    double totalLoss = 0;
    final x = DateTime(now.year, now.month, now.day - 1, 6, 30);
    String checkDateNow = day[now.weekday - 1] +
        " " +
        month[now.month - 1] +
        " " +
        now.day.toString();
    String dateYes = (day[x.weekday - 1] +
        " " +
        month[x.month - 1] +
        " " +
        x.day.toString());
    if (date == "Today") {
      date = checkDateNow;
    } else if (date == "Yesterday") {
      date = dateYes;
    }
    for (int x = 0; x < expensesContainer.length; x++) {
      if (expensesContainer[x].date == date) {
        if (expensesContainer[x].label == "Income") {
          totalGain = totalGain + expensesContainer[x].amount;
        } else if (expensesContainer[x].label == "Refund") {
          totalGain = totalGain + expensesContainer[x].amount;
        } else {
          totalLoss = totalLoss + expensesContainer[x].amount;
        }
      }
    }
    return Row(
      children: <Widget>[
        Icon(
          Icons.arrow_drop_up,
          color: Colors.green,
        ),
        Text(
          "Gain ₱" + totalGain.toStringAsFixed(2),
          style: TextStyle(fontSize: 11, color: Colors.black),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Colors.red,
        ),
        Text(
          "Loss ₱" + totalLoss.toStringAsFixed(2),
          style: TextStyle(fontSize: 11, color: Colors.black),
        )
      ],
    );
  }

  void setFailed() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 160,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "OPPS! ALLOWANCE IS NOT SET",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff086375)),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                    width: 200,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Please! Set your travel allowance.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 138,
                          child: RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text(
                              "Set Later",
                              style: TextStyle(
                                  color: Color(0xff086375),
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 1,
                          height: 35,
                          color: Colors.black26,
                        ),
                        Container(
                          width: 138,
                          child: RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text(
                              "Set Now",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _setBudget(context);
                            },
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _setBudget(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 170,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "SET TRAVEL ALLOWANCE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff086375)),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff086375)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9.0))),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: ' Amount',
                            ),
                            controller: setAmount,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                ),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 138,
                          child: RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.all(0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Color(0xff086375),
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 1,
                          height: 40,
                          color: Colors.black26,
                        ),
                        Container(
                          width: 138,
                          child: RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              db.setAmount(AmountModel(
                                  id: 1, amount: double.parse(setAmount.text)));
                              setupList();
                              setAmount.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    thisuserId = prefs.getString('userID');
  }

  void onStartupSync() async {
    var _fetchonlinedb = await getOnlineExpenseDb(thisuserId);
    var _fetchonlineamountdb = await getOnlineAmountDb(thisuserId);
      
    for (int x = 0; x < _fetchonlineamountdb.length; x++) {
     db.setAmount(AmountModel(id: 1, amount: (_fetchonlineamountdb[x].amount).toDouble()));
    }
    for (int x = 0; x < _fetchonlinedb.length; x++) {
      db.addExpense(ExpensesModel(
          id: _fetchonlinedb[x].userExpenseId,
          label: _fetchonlinedb[x].label,
          amount: _fetchonlinedb[x].amount,
          icon: _fetchonlinedb[x].icon,
          date: _fetchonlinedb[x].date,
          isDeleted: _fetchonlinedb[x].isDeleted));
          setupList();
    }
  }

  void checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        

        var _fetchonlinedb = await getOnlineExpenseDb(thisuserId);
        var _fetchonlineamount = await getOnlineAmountDb(thisuserId);

        amountonlinedbcontainer = _fetchonlineamount;
        expenseonlinedbcontainer = _fetchonlinedb;

        //IM HERE
        for(int x = 0; x < amountContainer.length; x++){
          if(checkAmountExist()){
            syncAmount(thisuserId,amountContainer[0].amount.toString());
            
          }else{
            syncUpdateAmount(thisuserId,amountContainer[0].amount.toString());
           
          }
        }
        
        for (int x = 0; x < expensesContainer.length; x++) {
          if (checkExist(expensesContainer[x].id)) {
            if (expensesContainer[x].isDeleted == 1) {
              syncUpdateExpense(thisuserId, expensesContainer[x].id.toString(),
                  expensesContainer[x].isDeleted.toString());
            }
          } else {
            syncExpense(
                thisuserId,
                expensesContainer[x].id.toString(),
                expensesContainer[x].label.toString(),
                expensesContainer[x].amount.toString(),
                expensesContainer[x].icon.toString(),
                expensesContainer[x].date.toString(),
                expensesContainer[x].isDeleted.toString());
          }
       
        }
     
      }
    } on SocketException catch (_) {
     
    }
    
  }

  bool checkExist(int expenseId) {
    for (int x = 0; x < expenseonlinedbcontainer.length; x++) {
      if (expenseId == expenseonlinedbcontainer[x].userExpenseId) {
        return true;
      }
    }
    return false;
  }

  bool checkAmountExist() {
     
      if (amountonlinedbcontainer.length == 1) {
        
        return false;
      }
    
    return true;
  }

   void onStartup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String start = prefs.getString('start');
    if (start != null) {
      setupList();
    }else{
        onStartupSync();
        prefs.setString('start',"done");
    }
  }

  @override
  bool get wantKeepAlive => true;
}
