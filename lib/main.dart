import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wandergo/homepagefiles/homepage.dart';
import 'package:wandergo/signinfiles/loginpage.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MainApp());
  });
}

class MainApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MainApp> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xff086375)),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? Homepage()  : SiginInPage(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => Homepage(),
        '/signin': (context) => SiginInPage(),
      },
    );
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userID');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }
}

//W
