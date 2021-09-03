import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/based_color.dart';
import 'package:mico/page_verifikasilogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();

}


class _LoginState extends State<Login> {
  //LoginStatus _loginStatus = LoginStatus.notSignIn;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, phone;
  bool _isvisible = false;
  final _phonecontrol = TextEditingController();
  final _emailcontroller = TextEditingController();
  String getMessage, getTextToast;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

   showFlushBar(BuildContext context, String stringme) => Flushbar(
   // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 3),
     flushbarPosition: FlushbarPosition.TOP ,
     )..show(context);


  void verifikasi() async {
    if (_phonecontrol.text.isEmpty && _emailcontroller.text.isEmpty) {
      showFlushBar(context, "Form Tidak Boleh Kosong");
      return;
    }

    if (_emailcontroller.text.isEmpty) {
      showFlushBar(context, "Email Tidak Boleh Kosong");
      return;
    }

    if (_phonecontrol.text.isEmpty) {
      showFlushBar(context, "Nomor Handphone Tidak Boleh Kosong");
      return;
    }

    setState(() {
      _isvisible = true;
    });
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=act_gettoken",
        body: {"phone": _phonecontrol.text.toString(), "email": _emailcontroller.text.toString()});
        Map showdata = jsonDecode(response.body);
        setState(() {
          getMessage = showdata["message"].toString();
          if (getMessage == '1') {
            showToast("Data anda tidak ditemukan", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            _isvisible  = false;
            return;
          } else{
            Navigator.push(context, ExitPage(page: VerifikasiLogin(_phonecontrol.text.toString(), _emailcontroller.text.toString())));
            _isvisible  = false;
            return;
          }
    });
    //myFocusNode.requestFocus()}
  }


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _scaffoldKey,
          body:
          new Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 70.0),
            child :
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 30.0),
              child :
              Column(
                children: <Widget> [

                  Align(
                      alignment: Alignment.centerLeft,
                      child :
                      Text("Masukkan nomor telpon dan email untuk memulai",textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 14))),

                  Padding(
                      padding: const EdgeInsets.only(top: 10.0)),

                  Align(alignment: Alignment.centerLeft,child: Padding(
                    padding: const EdgeInsets.only(left: 0,top: 25),
                    child: Text("Nomor Handphone",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                        fontSize: 12,color: HexColor("#0074D9")),),
                  ),),
                  Align(alignment: Alignment.centerLeft,child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Please insert phone number";
                        }
                      },
                      controller: _phonecontrol,
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top:2),
                        hintText: 'Nomor Handphone...',
                        labelText: '',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD")),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8c8989")),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD")),
                        ),
                      ),
                    ),
                  ),),


                  Align(alignment: Alignment.centerLeft,child: Padding(
                    padding: const EdgeInsets.only(left: 0,top: 25),
                    child: Text("Alamat Email",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                        fontSize: 12,color: HexColor("#0074D9")),),
                  ),),
                  Align(alignment: Alignment.centerLeft,child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Please insert email";
                        }
                      },
                      //validator: _validateEmail,
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top:2),
                        hintText: 'Alamat Email...',
                        labelText: '',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD")),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8c8989")),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD")),
                        ),
                      ),
                    ),
                  ),),
                  Visibility(
                    visible: _isvisible,
                      child: Center(
                    child: Padding(padding: const EdgeInsets.only(top: 100),child:
                    CircularProgressIndicator()),
                  )),

                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          title: Text("Dengan mendaftar, saya akan menerima Syarat dan Ketentuan Pengguna yang berlaku di aplikasi mico ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'VarelaRound', fontSize: 12)),
                          subtitle:
                          Padding (
                              padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
                              child :
                           Builder(
                             builder: (context) => RaisedButton(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(5.0),
                                 ),
                                 color: HexColor(second_color),
                                 child: Text(
                                   "Selanjutnya",
                                   style: TextStyle(
                                       fontFamily: 'VarelaRound',
                                       fontSize: 14.5,
                                       color: Colors.white
                                   ),
                                 ),
                                 onPressed: () {
                                   verifikasi();
                                 }
                             ),
                           )
                          ),
                        )
                    ),
                  )

                ],
              ),
            ),
          )
      ),
    );

  }

}