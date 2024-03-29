import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:mico/services/page_chatroom.dart';
import 'package:mico/services/page_videoroom.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class CekRoomKonsultasi extends StatefulWidget {
  final String appKode, appID;
  const CekRoomKonsultasi(this.appKode, this.appID);
  @override
  _CekRoomKonsultasiState createState() =>
      _CekRoomKonsultasiState();
//_DokterSearchPageState createState() => _DokterSearchPageState();
}

class _CekRoomKonsultasiState extends State<CekRoomKonsultasi> {

  String getAcc = "";
  String getMessage = "";
  int setMessage = 0;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm').format(DateTime.now());
  String formattedJam = DateFormat('kk').format(DateTime.now());
  String formattedMenit = DateFormat('mm').format(DateTime.now());
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

  String tahun, bulan, hari, jam, menit, room, typekonsul = "0";
  String fulldate, fulljam, roomstatus, checkroom = "...";
  _getVideoDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_appdetail&id="+widget.appKode);
    Map data = jsonDecode(response.body);
    setState(() {
      tahun = data["a"].toString();
      bulan = data["b"].toString();
      hari = data["c"].toString();
      jam = data["d"].toString();
      menit = data["e"].toString();
      room = data["f"].toString();
      typekonsul = data["g"].toString();
      roomstatus = data["h"].toString();
      checkroom = data["i"].toString();
      fulldate = tahun+"-"+bulan+"-"+hari;
      fulljam = jam+":"+menit;
    });
  }

  /*message information
    0 = Loading Awal
    1 = Status Room CLosed
    2 = Room belum jatuh tanggal dan jam
    3 = Lulus sensor
   */
  _cekroom_ready() async {
      if (roomstatus == 'CLOSED') {
        setState(() {
          setMessage = 1;
        });
      }
  }

  _cekroom_tanggal() async {
    if (formattedDate != fulldate) {
      setState(() {
        setMessage = 2;
      });
    }
  }

  _cekroom_jam() async {
    if (int.parse(formattedJam) < int.parse(jam) ) {
      setState(() {
        setMessage = 2;
      });
    }
  }

  _cekroom_menit() async {
    if (int.parse(formattedMenit) < int.parse(formattedMenit) ) {
      setState(() {
        setMessage = 2;
      });
    }
  }

  _cekroom_checkin() async {
        //if(checkroom == '0') {
             // await _cekroom_tanggal();
              //await _cekroom_jam();
              //await _cekroom_menit();
        //} else {
          setState(() {
             if(typekonsul == 'CHAT') {

             } else {

             }
          });
       // }
  }



  _cekroom() async {
     await _cekroom_ready();
     await _cekroom_checkin();
  }


  @override
  void initState() {
    super.initState();
    _session();
    _getVideoDetail();
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

                    : setMessage == 1 ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Mohon Maaf",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:20),
                      child:
                      Padding (
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
                          child :
                          Text(
                            "Appointment anda sudah selesai.",
                            style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16),textAlign: TextAlign.center,
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child:   RaisedButton(
                        color:  HexColor("#075e55"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          //side: BorderSide(color: Colors.red, width: 2.0)
                        ),
                        child: Text(
                          "Kembali",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14,
                              color: Colors.white
                          ),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                )


                    : setMessage == 2 ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding (
                        padding: const EdgeInsets.only(left: 25,right: 25),
                        child :
                        Text(
                          "Appointment anda dimulai pada : ",
                          style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16),textAlign: TextAlign.center,
                        )
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:2),
                      child:
                      Padding (
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
                          child :
                          Text(
                            'Tanggal : '+fulldate,
                            style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:2),
                      child:
                      Padding (
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
                          child :
                          Text(
                            'Jam : '+fulljam,
                            style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child:   RaisedButton(
                        color:  HexColor("#075e55"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          //side: BorderSide(color: Colors.red, width: 2.0)
                        ),
                        child: Text(
                          "Kembali",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14,
                              color: Colors.white
                          ),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
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
