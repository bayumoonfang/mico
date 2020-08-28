import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mico/doctor/pagedoctor_verifikasilogin.dart';
import 'package:toast/toast.dart';

class LoginDoctor extends StatefulWidget {
  @override
  _LoginDoctorState createState() => new _LoginDoctorState();

}


class _LoginDoctorState extends State<LoginDoctor> {
  String email, phone;
  final _formKey = GlobalKey<FormState>();
  final _phonecontrol = TextEditingController();
  final _emailcontroller = TextEditingController();
  String getMessage, getTextToast;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  void verifikasi() async {
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=act_gettokendoktor",
        body: {"phone": _phonecontrol.text.toString(), "email": _emailcontroller.text.toString()});
    Map showdata = jsonDecode(response.body);
    setState(() {
      getMessage = showdata["message"].toString();
      if (getMessage == '1') {
        showToast("Data anda tidak ditemukan", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else{
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => VerifikasiLoginDoctor(_phonecontrol.text.toString(), _emailcontroller.text.toString())));
        return;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Form(
        key: _formKey,
        child :
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
                    Text("Halo Dokter .. Masukkan nomor telpon dan email untuk login",textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',fontSize: 14))),

                Padding(
                    padding: const EdgeInsets.only(top: 10.0)),


                TextFormField(
                  style: TextStyle(
                      fontFamily: 'VarelaRound', fontSize: 18),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Telpon masih kosong";
                    } else if (text.length <= 10) {
                      return "Nomor telpon salah";
                    }
                    return null;
                  },
                  controller: _phonecontrol,
                  maxLength: 15,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                  ),

                ),
                TextFormField(
                  style: TextStyle(
                      fontFamily: 'VarelaRound', fontSize: 18),
                  //validator: _validateEmail,
                  controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email masih kosong';
                    }
                    return null;
                  },
                )

                ,
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                        title: Text("Dengan masuk ke aplikasi, saya akan menerima Syarat dan Ketentuan Pengguna yang berlaku di aplikasi Mico ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'VarelaRound', fontSize: 12)),
                        subtitle:
                        Padding (
                            padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
                            child :
                            RaisedButton(
                                color: Hexcolor("#8cc63e"),
                                child: Text(
                                  "Selanjutnya",
                                  style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14,
                                      color: Colors.white
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    verifikasi();
                                }

                                }
                            )
                        ),
                      )
                  ),
                )

              ],
            ),
          ),

        )

        ));

  }

}