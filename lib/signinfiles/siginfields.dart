import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';

class PasswordInputField extends StatefulWidget {
  Icon fieldicon;
  String hinttext;
  bool isHidden;
  String txtfieldName;
  TextEditingController myController;
  GlobalKey<FormState> _formKey;

  PasswordInputField(this.fieldicon, this.hinttext, this.isHidden,
      this.myController, this.txtfieldName, this._formKey);
  @override
  State<StatefulWidget> createState() {
    return _PasswordInputField();
  }
}

class _PasswordInputField extends State<PasswordInputField> {
  bool showTooltip = false;
  String errMsg = "Please input valid email address";

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 0.754,
        height: MediaQuery.of(context).size.height * 0.06,
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                border: showTooltip
                    ? Border.all(color: Colors.red)
                    : Border.all(color: Color(0xff086375)),
                borderRadius: BorderRadius.all(Radius.circular(9.0))),
            child: Row(
              children: <Widget>[
                 Container(
                   padding: EdgeInsets.only(left: 13),
                  color: Colors.white,
                  child: showTooltip
                      ? Icon(Icons.email, color: Colors.red)
                      : widget.fieldicon,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Form(
                      key: widget._formKey,
                      child: TextFormField(
                          onChanged: (value) {
                            if (widget.txtfieldName == "invalid_email" ||
                                widget.txtfieldName == "reg_email") {
                              setState(() {
                                showTooltip = false;
                                errMsg = "Please used valid email address";
                              });
                            } else if (widget.txtfieldName == "input_user") {
                              setState(() {
                                showTooltip = false;
                                errMsg = "Please used valid email address";
                              });
                            }
                          },
                          validator: (value) {
                            if (widget.txtfieldName == "reg_email") {
                              if (EmailValidator.validate(value)) {
                                validataUserName(widget.myController.text);
                              } else {
                                setState(() {
                                  showTooltip = true;
                                });
                              }
                            } else if (widget.txtfieldName == "input_user") {
                              if (!EmailValidator.validate(value)) {
                                setState(() {
                                  showTooltip = true;
                                });
                              }
                            }
                          },
                          controller: widget.myController,
                          obscureText: widget.isHidden,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.hinttext,
                            hintStyle: TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          style: TextStyle(
                            color: Color(0xff086375),
                          ),
                        ),),
                     
                    ],
                  ),
                ),
                 Container(
                   padding: EdgeInsets.all(10),
                    child: widget.txtfieldName == "input_pass" ||
                            widget.txtfieldName == "reg_pass"
                        ? GestureDetector(
                            child: widget.isHidden
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onTap: () {
                              setState(() {
                                widget.isHidden = !widget.isHidden;
                              });
                            },
                          )
                        : widget.txtfieldName == "reg_pass"
                            ? Icon(Icons.visibility)
                            : widget.txtfieldName == "reg_email"
                                ? showTooltip
                                    ? Icon(
                                        FontAwesomeIcons.exclamationCircle,
                                        color: Colors.red.withOpacity(0.7),
                                      )
                                    : Container()
                                : widget.txtfieldName == "input_user"
                                    ? showTooltip
                                        ? Icon(
                                            FontAwesomeIcons.exclamationCircle,
                                            color: Colors.red.withOpacity(0.7),
                                          )
                                        : Container()
                                    : Container(),
                  ),
                
              ],
            ),
          ),
        ),
      ),
      showTooltip
          ? Container(
              child: Text(
                errMsg,
                style: TextStyle(color: Colors.red),
              ),
              padding: EdgeInsets.all(0),
            )
          : Container(
              child: Text(""),
              padding: EdgeInsets.all(0),
            )
    ]);
  }

  Future validataUserName(
    String user,
  ) async {
    var url = "https://dutiful-paragraph.000webhostapp.com/get_validate.php";
    try {
      await http.post(url, body: {"user": user}).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode == 200) {
          if (json.decode(response.body) >= 1) {
            setState(() {
              showTooltip = true;
              errMsg = "Email address already used!";
            });
          }
        }
      });
    } catch (e) {}
  }
}
