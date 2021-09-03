



import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mico/helper/app_helper.dart';
import 'package:mico/services/mico_chatroom.dart';
class CekRoomNew extends StatefulWidget {
  final String idApp;
  final String getPhone;
  const CekRoomNew(this.idApp, this.getPhone);
  @override
  _CekRoomNew createState() => _CekRoomNew();
}


class _CekRoomNew extends State<CekRoomNew> {

  String tahun, bulan, hari, jam, menit, room, typekonsul = "0";
  String fulldate, fulljam, roomstatus, checkroom = "...";
  _getAppDetail() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_appdetail&id="+widget.idApp);
    Map data = jsonDecode(response.body);
    setState(() {
      room = data["f"].toString();
      typekonsul = data["g"].toString();
      roomstatus = data["h"].toString();
    });
  }

  _cekroom() async {
    await _getAppDetail();
  }



  @override
  void initState() {
    super.initState();
    _cekroom();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
        if(roomstatus.toString() == 'OPEN') {
          if(typekonsul == 'CHAT') {
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    Chatroom(widget.idApp, widget.getPhone)));
          } else {

          }
        } else {
          Navigator.pop(context);
        }
    });
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
            child: Scaffold(
              body: Container(
                color: Colors.white,
                height: double.infinity,
                width: double.infinity,
                child:   Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 70, height: 70, child: CircularProgressIndicator()),
                    Padding(padding: const EdgeInsets.all(25.0)),
                    Text(
                      "Memeriksa appointment anda...",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13,color: Colors.black,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:2),
                      child:
                      Text(
                        "Mohon menunggu sebentar",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13,color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            )
      );
  }
}