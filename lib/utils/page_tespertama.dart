import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_home.dart';
import 'package:mico/page_login.dart';
import 'package:mico/utils/setting.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';
import 'package:time/time.dart';


class VideoRoom2 extends StatefulWidget {
  final String getApp, getPhone, getRole, getRoom;
  const VideoRoom2(this.getApp, this.getPhone, this.getRole, this.getRoom);

  @override
  _VideoRoom2 createState() => _VideoRoom2();
}

class _VideoRoom2 extends State<VideoRoom2> {
  int _remoteUid;
  RtcEngine _engine;



  int uidq = 0;
  String token;
  String getUID;
  Future<void> getToken() async {
    final response = await http.get(
        AppHelper().applink + "do=get_agoratoken");
    Map data = jsonDecode(response.body);
    setState(() {
      token = data["a"].toString();
      uidq = data["b"];
    });
  }


  @override
  void initState() {
    super.initState();
    initAgora();
  }


  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }


  Future<void> initAgora() async {
    // retrieve permissions
    await _handleCameraAndMic;
    await getToken();

    //create the engine
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(token, "miracle", null, uidq);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: _renderLocalPreview(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _renderLocalPreview() {
    return Transform.rotate(
        angle : 90 * pi / 180,
        child :RtcLocalView.SurfaceView(

        )
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid);
    } else {
      return Text(
        "sss",
        textAlign: TextAlign.center,
      );
    }
  }
}