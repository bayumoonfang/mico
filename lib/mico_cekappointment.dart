import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/page_home.dart';
import 'package:mico/mico_detaildokter.dart';
import 'package:mico/mico_pembayaran2.dart';
import 'package:mico/mico_dokter.dart';
import 'package:mico/services/page_chatroomhome.dart';
import 'package:toast/toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mico/services/page_chatroom.dart';

class CekAppointment extends StatefulWidget {
  final String idJadwal, idUser, idDokter, idNamaDokter, idKlinik;
  const CekAppointment(this.idJadwal, this.idUser, this.idDokter, this.idNamaDokter, this.idKlinik);
  @override
  _CekAppointmentState createState() =>
      _CekAppointmentState(
          getIDJadwal: this.idJadwal,
          getUser: this.idUser,
          getDokter: this.idDokter,
          getNamaDokter: this.idNamaDokter,
          getKlinik: this.idKlinik

      );
//_DokterSearchPageState createState() => _DokterSearchPageState();
}

class _CekAppointmentState extends State<CekAppointment> {
  String
      getIDJadwal,
      getUser,
      getDokter,
      getNamaDokter,
      getKlinik = "";
      String getAcc = "";
      String getMessage = "";
      int setMessage = 0;
  _CekAppointmentState({
    this.getIDJadwal,
    this.getUser,
    this.getDokter,
    this.getNamaDokter,
    this.getKlinik});

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  _session() async {
    int value = await Session.getValue();
    getAcc = await Session.getPhone();
    if (value != 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }



  void _cekroom() async {
    await _session();
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=act_getappointmentavaible",
        body: {"iddokter": getDokter, "idcust": getUser});
    Map data = jsonDecode(response.body);
    setState(() {
      String getMessage = data["message"].toString();
      if (getMessage == '2') {
        setState(() {
            setMessage = 2;
        });
      } else {
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => CekPembayaran(
            getIDJadwal,
            getUser,
            getDokter,
            getNamaDokter,
            getKlinik)));
      }
    });
  }


  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      _cekroom();
    });
  }


  Future<bool> _onWillPop() async {
    //Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child:

              setMessage == 0 ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 50, height: 50, child: CircularProgressIndicator()),
                  Padding(padding: const EdgeInsets.all(25.0)),
                  Text(
                    "Memeriksa appointment anda...",
                    style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:2),
                    child:
                    Text(
                      "Mohon menunggu sebentar",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                    ),
                  )
                ],
              )

                  : setMessage == 2 ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mohon Maaf",
                    style: TextStyle(fontFamily: 'VarelaRound', fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:2),
                    child:
                        Padding (
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
                            child :
                            Text(
                              "Kami menemukan jadwal appointment atas nama anda, mohon menyelesaikan appointment tersebut atau cancel appointment tersebut.",
                              style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16),textAlign: TextAlign.center,
                            )
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                    child:   RaisedButton(
                      color:  Hexcolor("#075e55"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        //side: BorderSide(color: Colors.red, width: 2.0)
                      ),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 14,
                            color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context)
                            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Home()));
                      },
                    ),
                  )
                ],
              )

:
                  Text("")
            )));
  }
}
