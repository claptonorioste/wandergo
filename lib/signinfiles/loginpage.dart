import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wandergo/signinfiles/siginfields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

TextEditingController inputUsername = TextEditingController();
TextEditingController inputPassword = TextEditingController();

TextEditingController regName = TextEditingController();
TextEditingController regUsername = TextEditingController();
TextEditingController regPassword = TextEditingController();
TextEditingController regCpassword = TextEditingController();

GlobalKey<FormState> inputUsernameKey = GlobalKey();
GlobalKey<FormState> inputPasswordKey = GlobalKey();

GlobalKey<FormState> regNameKey = GlobalKey();
GlobalKey<FormState> regUsernameKey = GlobalKey();
GlobalKey<FormState> regPasswordKey = GlobalKey();
GlobalKey<FormState> regCpasswordKey = GlobalKey();

double percentage = 0.0;

final FirebaseAuth _auth = FirebaseAuth.instance;

final GoogleSignIn _googleSignIn = GoogleSignIn();

// final TwitterLogin twitterLogin = new TwitterLogin(
//     consumerKey: "xYGHKl7YKfRVH2m4HLeAatxx0",
//     consumerSecret: "B2YRyDWN88Qk4bVlBtKDZgm7dDi5kQz5ZPxiCeZCbdbPpPoEIw");

FocusNode focusNode = FocusNode();

class SiginInPage extends StatefulWidget {
  @override
  _SiginInPageState createState() => _SiginInPageState();
}

class _SiginInPageState extends State<SiginInPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  bool _keyboardOn = false; // set if keyboard is on of off
  bool disableLoginButton = true; // disable button if no input
  bool disableRegButton = true; // same as previous
  ProgressDialog pr; // loading animation
  String logMsg = "Please wait . . .";

  @override
  void initState() {
    super.initState();

    //listening to type inputs
    _controller = TabController(length: 2, vsync: this);
    inputUsername.addListener(() {
      logIsEmpty(inputUsername, inputPassword);
    });
    inputPassword.addListener(() {
      logIsEmpty(inputUsername, inputPassword);
    });
    regUsername.addListener(() {
      regIsEmpty(regName, regUsername, regPassword, regCpassword);
    });
    regName.addListener(() {
      regIsEmpty(regName, regUsername, regPassword, regCpassword);
    });
    regPassword.addListener(() {
      regIsEmpty(regName, regUsername, regPassword, regCpassword);
    });
    regCpassword.addListener(() {
      regIsEmpty(regName, regUsername, regPassword, regCpassword);
    });
    KeyboardVisibilityNotification().addNewListener(onChange: (bool visible) {
      print(visible);
      // view if keyboard is on
      setState(() {
        _keyboardOn = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: logMsg,
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

    return Scaffold( body: signfields());
  }

  Widget signfields() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/6.jpg"), fit: BoxFit.cover)),
      child:ListView(children: <Widget>[Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
          ),
          _keyboardOn
              ? Container(
                  height: 70,
                  child: Center(
                    child: Image.asset(
                      'assets/Untitled-1.png',
                      height: MediaQuery.of(context).size.height * 0.50,
                      width: MediaQuery.of(context).size.width * 0.30,
                    ),
                  ),
                )
              : Container(
                  child: Center(
                    child: Image.asset(
                      'assets/Untitled-1.png',
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.60,
                    ),
                  ),
                ),
          Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 0.65,
            decoration: BoxDecoration(
                color: Color(0xff075868),
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: TabBar(
              labelColor: Color(0xff086375),
              unselectedLabelColor: Colors.white,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              controller: _controller,
              tabs: [
                Tab(
                  text: 'Sign In',
                ),
                Tab(
                  text: 'Register',
                ),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 0.90,
            height:400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                            ),
                            PasswordInputField(
                                Icon(Icons.email, color: Color(0xff086375)),
                                'Email',
                                false,
                                inputUsername,
                                "input_user",
                                inputUsernameKey),
                            PasswordInputField(
                                Icon(Icons.lock, color: Color(0xff086375)),
                                'Password',
                                true,
                                inputPassword,
                                "input_pass",
                                inputPasswordKey),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                disabledColor:
                                    Color(0xff086375).withOpacity(0.5),
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: disableLoginButton
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        inputUsernameKey.currentState
                                            .validate();
                                        if (EmailValidator.validate(
                                            inputUsername.text)) {
                                          pr.show();
                                          getData(inputUsername.text,
                                              inputPassword.text);
                                          inputUsername.clear();
                                          inputPassword.clear();
                                        }
                                      },
                                color: Color(0xff086375),
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Color(0xff086375),
                                    decoration: TextDecoration.underline),
                              ),
                              onPressed: () {},
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.10,
                                  child: Divider(),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    "  Or  ",
                                    style: TextStyle(color: Color(0xff086375)),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.10,
                                  child: Divider(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: FlatButton(
                                      child: Icon(
                                        FontAwesomeIcons.facebookF,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        pr.show();
                                        initiateFacebookLogin();
                                      },
                                      color: Color(0xff086375),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      )),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 15, right: 15)),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: FlatButton(
                                      child: Icon(
                                        FontAwesomeIcons.google,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        pr.show();
                                        _testSignInWithGoogle();
                                      },
                                      color: Color(0xff086375),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                      ),
                      PasswordInputField(
                          Icon(FontAwesomeIcons.userAlt,
                              color: Color(0xff086375)),
                          'Name',
                          false,
                          regName,
                          "regName",
                          regNameKey),
                      PasswordInputField(
                          Icon(FontAwesomeIcons.userAlt,
                              color: Color(0xff086375)),
                          'Surname',
                          false,
                          regCpassword,
                          "reg_cpass",
                          regCpasswordKey),
                      PasswordInputField(
                          Icon(
                            FontAwesomeIcons.solidEnvelope,
                            color: Color(0xff086375),
                          ),
                          'Email',
                          false,
                          regUsername,
                          "reg_email",
                          regUsernameKey),
                      PasswordInputField(
                          Icon(Icons.lock, color: Color(0xff086375)),
                          'Password',
                          true,
                          regPassword,
                          "reg_pass",
                          regPasswordKey),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          disabledColor: Color(0xff086375).withOpacity(0.5),
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: disableRegButton
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  regUsernameKey.currentState.validate();
                                  if (EmailValidator.validate(
                                      regUsername.text)) {
                                    pr.show();
                                    validateUsername(
                                        regUsername.text,
                                        regPassword.text,
                                        regName.text,
                                        regCpassword.text);
                                  }
                                },
                          color: Color(0xff086375),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Term and Privacy Policy",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          )
        ],
      ),
    )],));
  }

  Future insertData(
    String user,
    String pass,
    String name,
    String last,
  ) async {
    var url = "https://dutiful-paragraph.000webhostapp.com/user_insert.php";
    try {
      await http.post(url, body: {
        "title": user,
        "name": pass,
        "lastname": name,
        "last": last
      }).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          Future.delayed(Duration(seconds: 3)).then((value) {
            pr.hide().whenComplete(() {
              print(pr.isShowing());
              succesfullyRegistered();
            });
          });
        }
      });
    } catch (e) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
          errDialog();
        });
      });
    }
  }

  Future getData(String user, String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url =
        'https://dutiful-paragraph.000webhostapp.com/get_account.php';
    try {
      await http.post(url, body: {
        "user": user,
        "pass": pass,
      }).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          pr.hide();
          try {
            List data = json.decode(response.body);
            prefs.setString('userID', data[0]["id"]);
            prefs.setString(
                'fullname', data[0]["name"] + " " + data[0]["lastname"]);

            Navigator.pushReplacementNamed(context, "/home");
            print(data);
          } catch (e) {
            Future.delayed(Duration(seconds: 3)).then((value) {
              pr.hide().whenComplete(() {
                print(e);
                loginFail();
              });
            });
          }
        }
      });
    } catch (e) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          print(e);
          errDialog();
        });
      });
    }
  }

  Future validateUsername(
    String user,
    String pass,
    String name,
    String last,
  ) async {
    var url = "https://dutiful-paragraph.000webhostapp.com/get_validate.php";
    try {
      await http.post(url, body: {"user": user}).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          if (json.decode(response.body) >= 1) {
            Future.delayed(Duration(seconds: 3)).then((value) {
              pr.hide().whenComplete(() {
                print(pr.isShowing());
              });
            });
          } else {
            insertData(user, pass, name, last);
            regName.clear();
            regPassword.clear();
            regUsername.clear();
            regCpassword.clear();
          }
        }
      });
    } catch (e) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
          errDialog();
        });
      });
    }
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();

    var facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        Future.delayed(Duration(seconds: 3)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
            errDialog();
          });
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        pr.hide();
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');
        var profile = json.decode(graphResponse.body);
        soValidate(
            profile["email"].toString(), "", profile["first_name"].toString(), profile["last_name"].toString());
        print(profile);
        break;
    }
  }

  Future soValidate(
    String user,
    String pass,
    String name,
    String last,
  ) async {
    var url = "https://dutiful-paragraph.000webhostapp.com/get_validate.php";
    try {
      await http.post(url, body: {"user": user}).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          if (json.decode(response.body) >= 1) {
            soGetData(user);
          } else {
            soInsertData(user, pass, name, last);
          }
        }
      });
    } catch (e) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
          errDialog();
        });
      });
    }
  }

  Future soInsertData(
    String user,
    String pass,
    String name,
    String last,
  ) async {
    var url = "https://dutiful-paragraph.000webhostapp.com/user_insert.php";
    try {
      await http.post(url, body: {
        "title": user,
        "name": pass,
        "lastname": name,
        "last": last
      }).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          soGetData(user);
        }
      });
    } catch (e) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
          errDialog();
        });
      });
    }
  }

  Future soGetData(String user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url =
        'https://dutiful-paragraph.000webhostapp.com/get_account_so.php';
    try {
      await http.post(url, body: {
        "user": user,
      }).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          pr.hide();
          try {
            List data = json.decode(response.body);
            prefs.setString('userID', data[0]["id"]);
            prefs.setString(
                'fullname', data[0]["name"] + " " + data[0]["lastname"]);
            Navigator.pushReplacementNamed(context, "/home");
            print(data);
          } catch (e) {
            Future.delayed(Duration(seconds: 3)).then((value) {
              pr.hide().whenComplete(() {
                print(e);
                errDialog();
              });
            });
          }
        }
      });
    } catch (e) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
          errDialog();
        });
      });
    }
  }

  Future _testSignInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      if (user.email != null) {
        print("Success");
        soValidate(user.email, "", user.displayName, "");
      }
    } catch (e) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
          errDialog();
        });
      });
    }
  }

  logIsEmpty(
      TextEditingController controller1, TextEditingController controller2) {
    if (controller1.text.isEmpty || controller2.text.isEmpty) {
      setState(() {
        disableLoginButton = true;
      });
    } else {
      if (controller2.text.length > 4) {
        setState(() {
          disableLoginButton = false;
        });
      } else {
        setState(() {
          disableLoginButton = true;
        });
      }
    }
  }

  regIsEmpty(
      TextEditingController controller1,
      TextEditingController controller2,
      TextEditingController controller3,
      TextEditingController controller4) {
    if (controller1.text.isEmpty ||
        controller2.text.isEmpty ||
        controller3.text.isEmpty ||
        controller4.text.isEmpty) {
      setState(() {
        disableRegButton = true;
      });
    } else {
      print(controller3.text.length);
      if (controller3.text.length > 4) {
        setState(() {
          disableRegButton = false;
        });
      } else {
        setState(() {
          disableRegButton = true;
        });
      }
    }
  }

  void errDialog() {
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
                      "Error",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff086375),
                          fontWeight: FontWeight.bold),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                    width: 200,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "An unknown network error has occured",
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
                              "Dismiss",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
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

  void loginFail() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 200,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Trouble Logging In?",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff086375),
                          fontWeight: FontWeight.bold),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                    width: 200,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "If you've forgotten your username or password, we can help you get back into yout account",
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
                              "Forgot Password",
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
                              "Try Again",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
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

  void succesfullyRegistered() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          child: Container(
            height: 165,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Thank You!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff086375),
                          fontWeight: FontWeight.bold),
                    )),
                Divider(
                  color: Colors.black26,
                ),
                Container(
                    width: 200,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Yaay! You have been successfully registered.",
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
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              _controller
                                  .animateTo((_controller.index + 1) % 2);
                              Navigator.of(context).pop();
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
}
