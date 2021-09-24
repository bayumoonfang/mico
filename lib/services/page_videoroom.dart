import 'dart:async';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
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


class VideoRoom extends StatefulWidget {
  final String getApp, getPhone, getRole, getRoom;
  final ClientRole role = ClientRole.Broadcaster;
  const VideoRoom(this.getApp, this.getPhone, this.getRole, this.getRoom);

  @override
  _VideoRoom createState() => _VideoRoom();
}

class _VideoRoom extends State<VideoRoom> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  Timer _timer;
  DateTime _currentTime;
  DateTime _afterTime, _timeIntv;
  int _menit;


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


  _doAkhiri() async {
    final response = await http.get(
        AppHelper().applink + "do=act_endvideochat&id="+widget.getApp);
    setState(() {
          _onCallEnd(context);
    });
  }



  int _detik2 = 60;
  int menitq = 5;
  void startTimerDetik() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_detik2 == 0) {
            _detik2 = 60;
            menitq = menitq - 1;
          } else {
            _detik2 = _detik2 - 1;
          }
        },
      ),
    );
  }

  void startTimerMenit() {
    const oneMin = const Duration(minutes: 1);
    _timer = new Timer.periodic(
      oneMin,
          (Timer timer) => setState(
            () {
          menitq = menitq + 1;
          if (_menit == -5) {
            Toast.show("Waktu konsultasi tinggal 5 menit", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          } else if (_menit == -2) {
            Toast.show("Waktu konsultasi tinggal 2 menit", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          } else if (_menit == 0) {
            //_endKonsultasi();
          }
        },
      ),
    );
  }

  Widget _countdown() {
    return Text(menitq.toString() + " : " +_detik2.toString(),
      style: TextStyle(color: Colors.black,fontSize: 27,
        fontFamily: 'VarelaRound',),);
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }



  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    startTimerDetik();

  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await getToken();
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    //configuration.dimensions = VideoDimensions(800, 600);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(token, "miracle", null, uidq);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
        tokenPrivilegeWillExpire: (token) async {
          await getToken();
          await _engine.renewToken(token);
        },
        error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: uid: $uid, $channel, ';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) =>
        list.add(RtcRemoteView.SurfaceView(uid: uid))
    );
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }




  alertKeluar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 210,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Keluar dari konsultasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.signOutAlt,
                      color: HexColor
                        (AppHelper().app_color1),size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Anda masih bisa bergabung kembali, selama dokter belum menyelesaikan konsultasi ini. ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12),textAlign: TextAlign.center,),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: HexColor
                            (AppHelper().app_color1)),
                          onPressed: () {
                            Navigator.pop(context);
                            _engine.leaveChannel();
                            _engine.destroy();
                            Navigator.pop(context);
                          }, child: Text("Iya", style: TextStyle(color : HexColor
                          (AppHelper().app_color1)),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }


  alertAkhiri() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 210,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin ?", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.signOutAlt,
                      color: HexColor
                        (AppHelper().app_color1),size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Mengakhiri konsultasi ini ? ",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12),textAlign: TextAlign.center,),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: HexColor
                            (AppHelper().app_color1)),
                          onPressed: () {
                            Navigator.pop(context);
                            _doAkhiri();
                          }, child: Text("Iya", style: TextStyle(color : HexColor
                          (AppHelper().app_color1)),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }


  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child:
            widget.getRole == "Customer" ?
            Column(
              children: <Widget>[
                _expandedVideoRow([views[1]]),
                _expandedVideoRow([views[0]])
              ])
              :
            Column(
              children: <Widget>[
                _expandedVideoRow([views[1]]),
                _expandedVideoRow([views[0]])
              ]),
            );
    /*  case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));*/
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    final viewnya = _getRenderViews();
    if (viewnya.length == 1) {
      return Container(
        alignment: Alignment.bottomCenter,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 60, height: 60, child: CircularProgressIndicator()),
                Padding(padding: const EdgeInsets.all(25.0)),
                Text(
                  "Mohon Menunggu",
                  style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Padding(padding: const EdgeInsets.only(top: 5),
                child:         Text(
                  "Pasien/Dokter belum bergabung pada konsultasi ini",
                  style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 12,
                      color: Colors.black),
                ),)
              ],
            )
          ],
        ),
      );
    } else {
      if (widget.role == ClientRole.Audience) return Container();
      return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RawMaterialButton(
              onPressed: _onToggleMute,
              child: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: muted ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: muted ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
            widget.getRole == "Doctor" ?
            RawMaterialButton(
              onPressed: () {
                alertAkhiri();
              },
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
            )
            :
            Text(""),
            RawMaterialButton(
              onPressed: _onSwitchCamera,
              child: Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
            )
          ],
        ),
      );
    }
  }

  /// Info panel to show logs
  /*Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }*/

  Widget _panel() {
    return
      Align(
          alignment: Alignment.topRight,
          child :      Padding(
            padding: const EdgeInsets.only(top: 20,right: 20),
            child:  Container(
                padding: const EdgeInsets.only(top: 30,right: 10),
                alignment: Alignment.topRight,
                child:
                Column(
                  children: [
                    _countdown(),
                    Text("Waktu konsultasi tersisa", style: new TextStyle(color: Colors.black,fontSize: 13,
                      fontFamily: 'VarelaRound',),)
                  ],
                )
            ),
          )

      );
  }

  void _onCallEnd(BuildContext context) {
    _engine.destroy();
    _engine.leaveChannel();
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }




  Future<bool> _onWillPop() async {
    //Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    //showAlert();
    alertKeluar();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Stack(
              children: <Widget>[
                /* Container(
                   alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.all(60.0),
                        child: Text("$_start" + " left",
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 23,
                                color: Colors.blueAccent)))),*/
                _viewRows(),
                _panel(),
                _toolbar(),
              ],
            ),
          ),
        ));
  }
}