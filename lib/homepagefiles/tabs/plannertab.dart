import 'dart:io';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wandergo/datafiles/offlinedatabase.dart';
import 'package:wandergo/datafiles/onlinedb.dart';
import 'package:wandergo/datafiles/plannermodel.dart';
import 'package:wandergo/datafiles/plannermodelon.dart';
import 'package:wandergo/datafiles/someList.dart';

class Planner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlannerState();
  }
}

class PlannerState extends State<Planner> {
  List<PlannerModel> planContainer = [];
  List<PlannerOnline> onlineplanner = [];
  var now = new DateTime.now();
  final db = ExpenseDatabase();
  String dateSelected;
  var _currentDate = DateTime.now();
  var _markedDateMap;
  int countList = 0;
  String thisuserId = "";
   String selectedDate = "";

  Map<String, bool> checkBoxValue = {};
  TextEditingController _ctlplan = TextEditingController();
  TextEditingController _ctleditplan = TextEditingController();
  bool isMapOn = false;
 String checkDateNow = "";
 
 @override
  void initState() {
    super.initState();
    checkDateNow = day[now.weekday - 1] +
        " " +
        month[now.month - 1] +
        " " +
        now.day.toString();
    setupList();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildExpensesList(planContainer),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          bottomSheet();
        },
        backgroundColor: Color(0xff086375),
      ),
    );
  }

  Widget _buildExpensesList(List<PlannerModel> plan) {
   
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1.5, color: Color(0xff086375)))),
          padding: EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: () async {
                    var res = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    );
                  selectedDate = day[res.weekday - 1] +
                        " " +
                        month[res.month - 1] +
                        " " +
                        res.day.toString();

                        setState(() {
                          checkDateNow = selectedDate;
                          print(checkDateNow);
                        });
                  },
                  child: Text(
                    checkDateNow,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xff086375)),
                  ),
                ),
              )
            ],
          ),
        ),
        countList > 0
            ? Expanded(
                child: ListView.builder(
                  itemCount: plan.length,
                  itemBuilder: (BuildContext context, int index) {
                    return checkDateNow == plan[index].date
                        ? plan[index].isDeleted == 0
                            ? Column(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[100]))),
                                      child: ListTile(
                                        onTap: () {},
                                        title: Container(
                                          padding: EdgeInsets.all(2),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    CircularCheckBox(
                                                        value: plan[index]
                                                                    .isDone ==
                                                                1
                                                            ? true
                                                            : false,
                                                        onChanged: (bool x) {
                                                          if (plan[index]
                                                                  .isDone ==
                                                              1) {
                                                            db.addPlan(PlannerModel(
                                                                id: plan[index]
                                                                    .id,
                                                                listLabel: plan[
                                                                        index]
                                                                    .listLabel,
                                                                date:
                                                                    plan[index]
                                                                        .date,
                                                                isDone: 0,
                                                                isDeleted: 0));
                                                            setupList();
                                                          } else {
                                                            db.addPlan(PlannerModel(
                                                                id: plan[index]
                                                                    .id,
                                                                listLabel: plan[
                                                                        index]
                                                                    .listLabel,
                                                                date:
                                                                    plan[index]
                                                                        .date,
                                                                isDone: 1,
                                                                isDeleted: 0));
                                                            setupList();
                                                          }
                                                        }),
                                                    Text(plan[index].listLabel)
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color:
                                                            Color(0xff086375),
                                                      ),
                                                      onPressed: () {
                                                        edit(
                                                            plan[index]
                                                                .listLabel,
                                                            plan[index].id);
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.redAccent,
                                                      ),
                                                      onPressed: () {
                                                        db.addPlan(PlannerModel(
                                                            id: plan[index].id,
                                                            listLabel:
                                                                plan[index]
                                                                    .listLabel,
                                                            date: plan[index]
                                                                .date,
                                                            isDone: 1,
                                                            isDeleted: 1));
                                                        setupList();
                                                      },
                                                    )
                                                  ],
                                                )
                                              ]),
                                        ),
                                      ))
                                ],
                              )
                            : Container()
                        : Container();
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: Container(
                    child: Text('Empty'),
                  ),
                ),
              )
      ],
    );
  }

  void setupList() async {
    countList = 0;
    var _allPlan = await db.fetchPlan();
    print(_allPlan);

    setState(() {
      planContainer = _allPlan;
      for (int x = 0; x < planContainer.length; x++) {
        if (planContainer[x].isDeleted == 0) {
          countList++;
        }
      }
      checkInternet();
    });
  }

  edit(String label, int id) {
    _ctleditplan.text = label;
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
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
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
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _ctleditplan,
                                cursorColor: Color(0xff086375),
                                cursorWidth: 2,
                                style: TextStyle(color: Color(0xff086375)),
                                decoration: InputDecoration.collapsed(
                                    hintText: 'e.g. Buy plane ticket at 6pm',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 20)),
                                autofocus: true,
                              ),
                            )),
                          ],
                        ),
                        Container(
                          child:
                              isMapOn ? calwidget(setModalstate) : Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Color(0xff086375),
                              ),
                              onPressed: () {
                                setModalstate(() {
                                  isMapOn = !isMapOn;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Color(0xff086375),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();

                                dateSelected = day[_currentDate.weekday - 1] +
                                    " " +
                                    month[_currentDate.month - 1] +
                                    " " +
                                    _currentDate.day.toString();

                                if (_currentDate
                                        .difference(DateTime.now())
                                        .inDays >=
                                    0) {
                                  db.addPlan(PlannerModel(
                                      id: id,
                                      date: dateSelected,
                                      listLabel: _ctleditplan.text,
                                      isDone: 0,
                                      isDeleted: 0));
                                  print(dateSelected);
                                } else {
                                  Toast.show("Invalid Date", context,
                                      backgroundColor: Color(0xff086375),
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.CENTER);
                                }

                                setState(() {
                                  _ctlplan.clear();
                                });

                                setupList();
                              },
                            )
                          ],
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
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
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
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _ctlplan,
                                cursorColor: Color(0xff086375),
                                cursorWidth: 2,
                                style: TextStyle(color: Color(0xff086375)),
                                decoration: InputDecoration.collapsed(
                                    hintText: 'e.g. Buy plane ticket at 6pm',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 20)),
                                autofocus: true,
                              ),
                            )),
                          ],
                        ),
                        Container(
                          child:
                              isMapOn ? calwidget(setModalstate) : Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Color(0xff086375),
                              ),
                              onPressed: () {
                                setModalstate(() {
                                  isMapOn = !isMapOn;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Color(0xff086375),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();

                                dateSelected = day[_currentDate.weekday - 1] +
                                    " " +
                                    month[_currentDate.month - 1] +
                                    " " +
                                    _currentDate.day.toString();

                                if (_currentDate
                                        .difference(DateTime.now())
                                        .inDays >=
                                    0) {
                                  db.addPlan(
                                    PlannerModel(
                                        id: planContainer.length + 1,
                                        date: dateSelected,
                                        listLabel: _ctlplan.text,
                                        isDone: 0,
                                        isDeleted: 0),
                                  );
                                  print(dateSelected);
                                } else {
                                  Toast.show("Invalid Date", context,
                                      backgroundColor: Color(0xff086375),
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.CENTER);
                                }

                                setState(() {
                                  _ctlplan.clear();
                                });

                                setupList();
                              },
                            )
                          ],
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

  Widget calwidget(StateSetter setModalstate) {
    return Container(
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          setModalstate(() => _currentDate = date);
        },
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
        customDayBuilder: (
          /// you can provide your own build function to make custom day containers
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          return null;
        },
        weekFormat: false,
        markedDatesMap: _markedDateMap,
        height: 360.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: null,

        /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }

  void checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var fetch = await getOnlineplaner(thisuserId);

      onlineplanner = fetch;

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        for (int x = 0; x < planContainer.length; x++) {
          if (checkExist(planContainer[x].id)) {
            syncUpdatePlan(
                planContainer[x].id.toString(),
                thisuserId.toString(),
                planContainer[x].listLabel,
                planContainer[x].isDone.toString(),
                planContainer[x].date,
                planContainer[x].isDeleted.toString());
          } else {
            syncPlanner(
                planContainer[x].id.toString(),
                thisuserId,
                planContainer[x].listLabel,
                planContainer[x].isDone.toString(),
                planContainer[x].date,
                planContainer[x].isDeleted.toString());
          }
        }
      }
    } on SocketException catch (_) {}
  }

  void getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    thisuserId = prefs.getString('userID');
  }

  bool checkExist(int plannerid) {
    for (int x = 0; x < onlineplanner.length; x++) {
      if (plannerid == onlineplanner[x].userplannerid) {
        return true;
      }
    }
    return false;
  }

}
