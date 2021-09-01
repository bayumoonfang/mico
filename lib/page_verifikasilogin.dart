import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class VerifikasiLogin extends StatefulWidget{
      final String phone, email;
  const VerifikasiLogin(this.phone, this.email);

  _VerifikasiLoginState createState() => new _VerifikasiLoginState(
      getPhone : this.phone,
      getEmail : this.email
  );
}

enum LoginStatus { notSignIn, signIn }

class _VerifikasiLoginState extends State<VerifikasiLogin> {
  String getPhone, getEmail;
  int getVal;
  final _tokenVal = TextEditingController();
  bool _isvisible = false;
  _VerifikasiLoginState({this.getPhone, this.getEmail});
  //LoginStatus _loginStatus = LoginStatus.notSignIn;

  showFlushBar(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP ,
  )..show(context);


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  login() async {
    if (_tokenVal.text.length < 6) {
      showFlushBar(context, "Token harus 6 angka");
      return;
    }
    setState(() {
      _isvisible = true;
    });


    final response = await http.post("https://duakata-dev.com/miracle/api_script.php?do=act_ceklogin",
        body: {"phone": getPhone, "email": getEmail, "token": _tokenVal.text});
      Map data = jsonDecode(response.body);
      setState(() {
      int getValue = data["value"];
      String getIDcust = data["idcust"].toString();
      String getAccnumber = getPhone;
      if (getValue == 1) {
        savePref(getValue, getPhone, getEmail, getIDcust, getAccnumber);
        Navigator.pushReplacement(context, ExitPage(page: Home()));
        _isvisible = false;
        return;
      } else {
        showFlushBar(context, "Token anda tidak sesuai");
        _isvisible = false;
        return;
      }
    });
  }

  savePref(int value, String phone, String email, String idcustomer, String getAccnumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("phone", getPhone);
      preferences.setString("email", getEmail);
      preferences.setString("idcustomer", idcustomer);
      preferences.setString("accnumber", getAccnumber);
      preferences.setString("basedlogin", "user");
      preferences.commit();
    });
  }


  @override
  Widget build(BuildContext context) {
      return new  WillPopScope(
        onWillPop: _onWillPop,
          child: new
            Scaffold(
          body :(
          Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 70.0),
          child :
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                      child :
                      Column(
                        children: <Widget> [
                          ListTile(
                            leading: CircleAvatar(
                                  radius : 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage("assets/mira-ico.png"),
                                ),
                            title: Text("Masukkan 6 angka kode yang telah dikirimkan ke "
                                "email", style: TextStyle(
                                fontFamily: 'VarelaRound',fontSize: 15)),
                            subtitle: Text(getEmail, style: TextStyle(
                                fontFamily: 'VarelaRound',fontSize: 14)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:50.0),
                            child :
                                Container(
                                  width: 170.0,
                                child :
                                TextFormField(
                                  maxLength: 6,
                                  style: TextStyle(fontSize: 38,letterSpacing: 5.0),
                                  textAlign: TextAlign.center,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      counterText: ''
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _tokenVal,
                                ))
                          ),
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
                                  title:
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget> [
                                          Text("Salah nomor telpon ?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'VarelaRound', fontSize: 14)),

                                          FlatButton(
                                            child: Text("ganti nomor telpon",
                                            style: TextStyle(
                                                fontFamily: 'VarelaRound',color: Colors.red, fontSize: 14)
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).push(
                                                    new MaterialPageRoute(
                                                        builder: (BuildContext context) => Login())),
                                          )

                                      ]),

                                  subtitle:
                                  Padding (
                                      padding: const EdgeInsets.only(bottom: 15.0),
                                      child :
                                      RaisedButton(
                                        color: HexColor("#8cc63e"),
                                        child: Text(
                                          "Verifikasi",
                                          style: TextStyle(

                                            fontFamily: 'VarelaRound',
                                            fontSize: 14,
                                            color: Colors.white
                                          ),
                                        ),
                                        onPressed: () {
                                          login();
                                        }

                                      )
                                  ),
                                )
                            ),
                          )


                        ],
                      ),

                  )
              )
            )
          )

      );
  }

}