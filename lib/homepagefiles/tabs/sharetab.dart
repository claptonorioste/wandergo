import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wandergo/datafiles/onlinedb.dart';
import 'package:wandergo/datafiles/samplemodel.dart';
import 'package:wandergo/datafiles/socialmediamodel.dart';
import 'package:wandergo/homepagefiles/tabs/sample.dart';

class Share extends StatefulWidget {
  @override
  ShareState createState() => ShareState();
}

class ShareState extends State<Share> {
  List<User> sampleUsers = [clapton, naruto, sasuke, minato, saitama, genus];
  List<SocialModel> list = [];
  String thisuserId = "";
  String fullname = "";
  final String hostLink = 'http://dutiful-paragraph.000webhostapp.com/';
  TextEditingController _ctlmessage = TextEditingController();
  Future<File> file;
  String base64Image = '';
  File tmpFile;
  bool isLike = false;
  bool load = false;
  var rng = Random();

  @override
  void initState() {
    super.initState();
    getUserId();
    setupList();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? Container(
            child: ListView.builder(
            itemCount: list.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                    height: 120,
                    child: Card(
                      child: Container(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, i) {
                            return AvatarWidget(
                              user: sampleUsers[i],
                              onTap: () {
                                if (i == 0) {
                                  bottomSheet();
                                } else {
                                  print("Other Users");
                                }
                              },
                              isLarge: true,
                              isShowingUsernameLabel: true,
                              isCurrentUserStory: i == 0,
                            );
                          },
                          itemCount: sampleUsers.length,
                        ),
                      ),
                    ));
              }
              index--;
              print(thisuserId);
              return Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: list[index].fullname ==
                                        "Christian Garcia"
                                    ? AvatarWidget(
                                        user: clapton,
                                        padding: EdgeInsets.all(0),
                                      )
                                    : AvatarWidget(
                                        padding: EdgeInsets.all(0),
                                        user: sampleUsers[
                                            rng.nextInt(sampleUsers.length)],
                                      ),
                              ),
                              Text(
                                list[index].fullname,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff086375)),
                              )
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              list[index].label,
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Image.network(
                          hostLink + list[index].fileName,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                isLike
                                    ? IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.solidHeart,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isLike = !isLike;
                                          });
                                        })
                                    : IconButton(
                                        icon: Icon(FontAwesomeIcons.heart),
                                        onPressed: () {
                                          setState(() {
                                            isLike = !isLike;
                                          });
                                        },
                                      ),
                                IconButton(
                                    icon: Icon(FontAwesomeIcons.comment),
                                    onPressed: () {}),
                                IconButton(
                                    icon: Icon(FontAwesomeIcons.shareAlt),
                                    onPressed: () {})
                              ],
                            ),
                            IconButton(
                                icon: Icon(FontAwesomeIcons.bookmark),
                                onPressed: () {})
                          ],
                        ),
                      )
                      //column end
                    ],
                  ),
                ),
              );
            },
          ))
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitWave(
                color: Color(0xff086375),
                size: 30.0,
              ),
              Text(
                'Data is being loaded!',
                style: TextStyle(color: Color(0xff086375)),
              )
            ],
          ));
  }

  //
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
                                controller: _ctlmessage,
                                cursorColor: Color(0xff086375),
                                cursorWidth: 2,
                                style: TextStyle(color: Color(0xff086375)),
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Share Something!',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 20)),
                                autofocus: true,
                              ),
                            )),
                          ],
                        ),
                        Container(
                          child: showImage(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OutlineButton(
                              onPressed: () {
                                chooseImage(setModalstate);
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 20,
                                    ),
                                    margin: EdgeInsets.only(right: 5),
                                  ),
                                  Text('ADD IMAGE')
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Color(0xff086375),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Toast.show("Uploading. . .", context,
                                    backgroundColor: Color(0xff086375),
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);

                                String fileName = tmpFile.path.split('/').last;

                                uploadToSocial(thisuserId, _ctlmessage.text,
                                    base64Image, fileName, fullname);
                                file = null;
                                _ctlmessage.clear();
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

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            width: 350,
            height: 300,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  chooseImage(StateSetter setModalstate) {
    setModalstate(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    thisuserId = prefs.getString('userID');
    fullname = prefs.getString('fullname');
  }

  Future uploadToSocial(String userId, String label, String image,
      String imageName, String fullName) async {
    final url = 'http://dutiful-paragraph.000webhostapp.com/upload_image.php';
    try {
      await http.post(url, body: {
        "user_id": userId,
        "label": label,
        "image": image,
        "image_name": imageName,
        "user_full_name": fullName
      }).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          Toast.show("Shared!", context,
              backgroundColor: Color(0xff086375),
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM);

          setupList();
        }
      });
    } on http.ClientException catch (e) {
      print(e);
    }
  }

  void setupList() async {
    var _allPlan = await getAllSocial();
    setState(() {
      list = _allPlan.reversed.toList();
      load = true;
    });

    print(list);
  }
}
