import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wandergo/datafiles/offlinedatabase.dart';
import 'package:wandergo/homepagefiles/tabs/homeTab.dart';
import 'package:wandergo/homepagefiles/tabs/navigation.dart';
import 'package:wandergo/homepagefiles/tabs/plannertab.dart';
import 'package:wandergo/homepagefiles/tabs/sharetab.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Homepage();
  }
}

class _Homepage extends State<Homepage> {
  final db = ExpenseDatabase();
  ProgressDialog pr;
  static const String setting = 'Settings';
  static const String export = 'Export to CSV';
  static const String logoutS = 'Sign out';

  List<String> options = [setting, export, logoutS];

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeTab(),
    Planner(),
    Share(),
    Navigation(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: "Logging out . . .",
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: SpinKitWave(
        color: Color(0xff086375),
        size: 30.0,
      ),
      elevation: 5.0,
      insetAnimCurve: Curves.bounceIn,
      progressTextStyle: TextStyle(
          color: Color(0xff086375),
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Color(0xff086375),
          fontSize: 19.0,
          fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
            child: PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Color(0xff086375),
            ),
            onSelected: checkAction,
            itemBuilder: (BuildContext context) {
              return options.map((String options) {
                return PopupMenuItem<String>(
                  value: options,
                  child: Text(
                    options,
                    style: TextStyle(color: Color(0xff086375)),
                  ),
                );
              }).toList();
            },
          ),),
        ],
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/Untitled-2.png',
          height: MediaQuery.of(context).size.width * 0.30,
          width: MediaQuery.of(context).size.width * 0.30,
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff086375),
        onTap: onTabTapped, // new
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped

        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.rubleSign),
            title: Text(
              'Budget',
              style: TextStyle(color: Color(0xff086375)),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.tasks,
              ),
              title: Text('Plan', style: TextStyle(color: Color(0xff086375)))),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.hiking,
              ),
              title: Text('Share', style: TextStyle(color: Color(0xff086375)))),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.locationArrow),
              title: Text('Navigation',
                  style: TextStyle(color: Color(0xff086375)))),
        ],
      ),
    );
  }

  void function() {
    pr.show();
  }

  void function1() {
    pr.hide();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 100,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Sign out of Wandernote?",
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
                              "Logout",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              function();
                              db.removeAllAmount();
                              db.removeAll();
                              db.removePlan();
                              logout();
                              Future.delayed(Duration(seconds: 3))
                                  .then((value) {
                                function1();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/signin', (Route<dynamic> route) => false);
                              });
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

  checkAction(String choice) {
    if(choice == options[2]){
      _showDialog();
    }
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', null);
    prefs.setString('start', null);
    prefs.setString('fullname', null);
  }
}
