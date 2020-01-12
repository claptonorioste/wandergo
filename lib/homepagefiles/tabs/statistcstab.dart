import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:wandergo/datafiles/expensesmodel.dart';
import 'package:wandergo/datafiles/offlinedatabase.dart';
import 'package:wandergo/datafiles/someList.dart';


class Statistics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatisticsState();
  }
}

class StatisticsState extends State<Statistics> {
  final db = ExpenseDatabase();
  bool doneSetup = false;
  List<ExpensesModel> expensesContainer = [];
  List dataList = [];
  
  Map<String, double> dataMap = Map();

  @override
  void initState() {
    super.initState();
    setupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: doneSetup
            ? listBuilder()
            : Center(
                child: Container(
                  child: Text("Empty"),
                ),
              ));
  }

  Widget listBuilder() {
    return Container(
        child: Container(
      child: ListView.builder(
        itemCount: dataMap.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
                color: Colors.grey[100],
                child: Column(
                  children: <Widget>[
                    Card(
                        child: Container(
                          padding: EdgeInsets.all(15),
                      child: doneSetup
                          ? PieChart(
                            
                            
                            
                              dataMap: dataMap,
                              legendStyle: defaultLegendStyle.copyWith(
                                color: Color(0xff086375),
                              ),
                              showChartValuesInPercentage: true,
                              showLegends: true,
                              legendPosition: LegendPosition.right,
                              chartType: ChartType.ring,
                              chartValueStyle: defaultChartValueStyle.copyWith(
                                color: Color(0xff086375),
                              ),
                              
                            )
                          : Container(),
                    )),
                    Container(
                      height: 3,
                      color: Colors.grey[100],
                    )
                  ],
                ));
          } else {
            index -= 1;
            dataList = dataMap.keys.toList();
            print(dataList[0]);
            return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[100]))),
                child: ListTile(
                    title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        dataList[index] == "Food"
                            ? expenseIcon[0]
                            : dataList[index] == "Transportation"
                                ? expenseIcon[1]
                                : dataList[index] == "Groceries"
                                    ? expenseIcon[2]
                                    : dataList[index] == "Accomodation"
                                        ? expenseIcon[3]
                                        : dataList[index] == "Drinks"
                                            ? expenseIcon[4]
                                            : dataList[index] == "Laundry"
                                                ? expenseIcon[5]
                                                : dataList[index] ==
                                                        "Entertainment"
                                                    ? expenseIcon[6]
                                                    : dataList[index] == "Fees"
                                                        ? expenseIcon[7]
                                                        : dataList[index] ==
                                                                "Activity"
                                                            ? expenseIcon[8]
                                                            : dataList[index] ==
                                                                    "Others"
                                                                ? expenseIcon[9]
                                                                : Container(),
                        Text(" " + dataList[index].toString(),
                            style: TextStyle(color: Color(0xff086375)))
                      ],
                    ),
                    Text(
                      "₱" + dataMap[dataList[index]].toStringAsFixed(2),
                      style: TextStyle(color: Color(0xff086375)),
                    ),
                  ],
                )));
          }
        },
      ),
    ));
  }

  //fetch the data in the sql database
  void setupList() async {
    double foodAmount = 0;
    double transAmount = 0;
    double grAmount = 0;
    double accAmount = 0;
    double drAmount = 0;
    double laAmount = 0;
    double enAmount = 0;
    double feAmount = 0;
    double acAmount = 0;
    double otAmount = 0;

    var _allExpense = await db.fetchAll();

    setState(() {
      expensesContainer = _allExpense.reversed.toList();
    });

    expensesContainer.forEach((x) {
      if (x.label == "Food") {
        foodAmount = foodAmount + x.amount;
        dataMap[x.label] = foodAmount;
      } else if (x.label == "Transportation") {
        transAmount = transAmount + x.amount;
        dataMap[x.label] = transAmount;
      } else if (x.label == "Groceries") {
        grAmount = grAmount + x.amount;
        dataMap[x.label] = grAmount;
      } else if (x.label == "Accomodation") {
        accAmount = accAmount + x.amount;
        dataMap[x.label] = accAmount;
      } else if (x.label == "Drinks") {
        drAmount = drAmount + x.amount;
        dataMap[x.label] = drAmount;
      } else if (x.label == "Laundry") {
        laAmount = laAmount + x.amount;
        dataMap[x.label] = laAmount;
      } else if (x.label == "Entertainment") {
        enAmount = enAmount + x.amount;
        dataMap[x.label] = enAmount;
      } else if (x.label == "Fees") {
        feAmount = feAmount + x.amount;
        dataMap[x.label] = feAmount;
      } else if (x.label == "Activity") {
        acAmount = acAmount + x.amount;
        dataMap[x.label] = acAmount;
      } else if (x.label == "Others") {
        otAmount = otAmount + x.amount;
        dataMap[x.label] = otAmount;
      }
    });
    setState(() {
      if (dataMap.length != 0) {
        doneSetup = true;
      }
    });
  }
}
