import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/mico_home.dart';
import 'package:toast/toast.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;


class PrepareRoom extends StatefulWidget {
  final String idJadwal, idUser, idDokter, idLayanan;
  const PrepareRoom(this.idJadwal, this.idUser, this.idDokter, this.idLayanan);
  @override
  _PrepareRoomState createState() => _PrepareRoomState();
}

class _PrepareRoomState extends State<PrepareRoom> {
  String getAcc = "";
  String getMessage = "";
  int setMessage = 0;

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



  void _prepareroomact() async {
    await _session();
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=prepare_room",
        body: {
          "iddokter": widget.idDokter,
          "idcustomer": widget.idUser,
          "idjadwal" : widget.idJadwal,
          "idlayanan" : widget.idLayanan
        });
    Map data = jsonDecode(response.body);
    setState(() {
      String getMessage = data["message"].toString();
      if (getMessage == '0') {
        setState(() {
           setMessage = 1;
        });
      } else {
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Home()));
      }
    });
  }


  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      _prepareroomact();
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
                      "Memproses appointment anda ...",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:2),
                      child:
                      Text(
                        "Silahkan cek status appointment anda di menu appointment",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:2),
                      child:
                      Text(
                        "Setelah jendela ini tertutup..",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:15),
                      child:
                      Text(
                        "Mohon menunggu sebentar",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.only(top:2),
                      child:
                      Padding (
                          padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
                          child :
                          Text(
                            "Dokter sedang ada konsultasi di jam ini , silahkan memilih hari atau jam lain.",
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
                          "Coba Lagi",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14,
                              color: Colors.white
                          ),
                        ),
                        onPressed: (){
                         _prepareroomact();
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
