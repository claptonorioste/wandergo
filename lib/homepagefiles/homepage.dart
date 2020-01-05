import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:wandergo/homepagefiles/homepageDrawer.dart';


import 'package:wandergo/homepagefiles/tabs/diariestab.dart';
import 'package:wandergo/homepagefiles/tabs/homeTab.dart';
import 'package:wandergo/homepagefiles/tabs/navigation.dart';
import 'package:wandergo/homepagefiles/tabs/plannertab.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Homepage();
  }
}

class _Homepage extends State<Homepage> {
  ProgressDialog pr;

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeTab(),
    Planner(),
    Diaries(),
    Navigation()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
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
      endDrawer: HomePageDrawer(function),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.more_vert, color: Color(0xff086375)),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
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
            icon: Icon(
              FontAwesomeIcons.home,
            ),
            title: Text(
              'Home',
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
                FontAwesomeIcons.solidCommentAlt,
              ),
              title:
                  Text('Diaries', style: TextStyle(color: Color(0xff086375)))),
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
