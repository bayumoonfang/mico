import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mico/mico_detaildokter.dart';
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

class ChatRoomPrepare extends StatefulWidget {
  final String accdokter, namadokter, klinik, MyPhone;
  const ChatRoomPrepare(this.accdokter, this.namadokter, this.klinik, this.MyPhone);
  @override
  _ChatRoomPrepareState createState() =>
      _ChatRoomPrepareState(getAccDokter: this.accdokter, getNamaDokter: this.namadokter, getKlinik: this.klinik, getPhone : this.MyPhone);
//_DokterSearchPageState createState() => _DokterSearchPageState();
}

class _ChatRoomPrepareState extends State<ChatRoomPrepare> {
  String getDokter, getAcc, getPhone;
  String getAccDokter, getNamaDokter, getKlinik;
  String getMessage;
  _ChatRoomPrepareState({this.getAccDokter, this.getNamaDokter, this.getKlinik, this.getPhone});

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
        "https://duakata-dev.com/miracle/api_script.php?do=act_getroomchat",
        body: {"iddokter": getAccDokter, "idcust": getPhone});
    Map data = jsonDecode(response.body);
    setState(() {
      String getMessage = data["message"].toString();
      String getChannel = data["channelq"].toString();

      if (getMessage == '0') {
        showToast("Maaf Room Penuh.. Coba beberapa saat lagi", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.pop(context);
      } else {
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Chatroomhome(getPhone,'1')));
      }
      //_loginStatus = LoginStatus.signIn;
      //savePref(value, getPhone, getEmail);
      //Navigator.of(context)
      //.push(new MaterialPageRoute(builder: (BuildContext context) => Home()));
    });
  }


  @override
  void initState() {
    super.initState();
    _cekroom();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      onJoin();
    });
  }


  Future<void> onJoin() async {
    //await _handleCameraAndMic();
    /*await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chatroomfix(
          channelName: getDokter,
        ),
      ),
    );*/
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 70, height: 70, child: CircularProgressIndicator()),
                  Padding(padding: const EdgeInsets.all(25.0)),
                  Text(
                    "Menyiapkan room untuk chat",
                    style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                  )
                ],
              ),
            )));
  }
}
