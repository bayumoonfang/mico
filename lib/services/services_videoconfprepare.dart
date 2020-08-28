import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:mico/page_pembayaran.dart';
import 'package:mico/pagelist_dokter.dart';
import 'package:mico/services/page_chatroomhome.dart';
import 'package:mico/services/services_videoconf.dart';
import 'package:toast/toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mico/services/page_chatroom.dart';

class VideoConfPrepare extends StatefulWidget {
  final String MyPhone;
  const VideoConfPrepare(this.MyPhone);
  @override
  _VideoConfPrepareState createState() =>
      _VideoConfPrepareState(getPhone : this.MyPhone);
//_DokterSearchPageState createState() => _DokterSearchPageState();
}

class _VideoConfPrepareState extends State<VideoConfPrepare> {
  String getPhone, getAcc, getRoomVideo, getNamaDokter = '';

  _VideoConfPrepareState({this.getPhone});
  ClientRole _role = ClientRole.Broadcaster;


  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }



  @override
  void initState() {
    super.initState();
  onJoin();
  }


  _session() async {
    int value = await Session.getValue();
    getAcc = await Session.getPhone();
    if (value != 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }


  void _getVideoDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_videodetail&id="+widget.MyPhone);
    Map data = jsonDecode(response.body);
    setState(() {
      getRoomVideo = data["roomvideo"].toString();
      getNamaDokter = data["namadokter"].toString();
    });
  }




  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  Future<void> onJoin() async {
    await _session();
    await _getVideoDetail();
    await _handleCameraAndMic();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoConf(
          channelName: getRoomVideo,
          role: _role,
          user : widget.MyPhone,
          dokter : getNamaDokter
        ),
      ),
    );
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
                    "Menyiapkan room untuk video konsultasi",
                    style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                  )
                ],
              ),
            )));
  }
}
