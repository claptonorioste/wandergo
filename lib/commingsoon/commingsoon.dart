import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Soon extends StatefulWidget{
  final String title;
  Soon(this.title);
  

  @override
  State<StatefulWidget> createState() {
    return SoonState();
  }

}

class SoonState extends State<Soon> { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(50),
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            "Oops, the "+widget.title+" tab is under construction!",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Image.asset(
                      'assets/images/building.gif',
                      height: MediaQuery.of(context).size.width * 0.60,
                      scale: 0.4,
                    ),
                  ],
                ),);
  }
}
