import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wandergo/datafiles/offlinedatabase.dart';

class HomePageDrawer extends StatelessWidget {
  final Function fn;
  HomePageDrawer(this.fn);

  final db = ExpenseDatabase();
  final TextEditingController setAmount = TextEditingController();


  @override
  Widget build(context) {
    

    return Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 1.6,
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.3,
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Export to CSV'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Container(color: Colors.black12, height: 1),
              ListTile(
                title: Text(
                  'Log out',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.of(context).pop();
                  _showDialog(context);
                },
              ),
            ],
          ),
        ));
  }

  void _showDialog(BuildContext context) {
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
                      "Log out of Wandergo?",
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
                             fn();
                              db.removeAllAmount();
                              db.removeAll();
                              logout();
                              Future.delayed(Duration(seconds: 3))
                                  .then((value) {
                                Navigator.of(context).pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
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

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', null);
    prefs.setString('start', null);
  }
}
