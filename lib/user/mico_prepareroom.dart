import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/services/mico_chatroom.dart';
import 'package:toast/toast.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;


class PrepareRoomCreate extends StatefulWidget {
  final String idAppointment;
  const PrepareRoomCreate(this.idAppointment);
  @override
  _PrepareRoomCreateState createState() => _PrepareRoomCreateState();
}

class _PrepareRoomCreateState extends State<PrepareRoomCreate> {
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
        "https://duakata-dev.com/miracle/api_script.php?do=prepare_roomcreate",
        body: {
          "id": widget.idAppointment,
        });
    Map data = jsonDecode(response.body);
    setState(() {
      String getMessage = data["message"].toString();
      if (getMessage == '1') {
        setState(() {
          setMessage = 1;
        });
      } else {
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Chatroom(widget.idAppointment,'1')));
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
                      "Mempersiapkan room konsultasi anda ...",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:5),
                      child:
                      Text(
                        "Mohon menunggu sebentar",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
                        :
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
                                "Saat ini room konsultasi penuh , silahkan coba beberapa saat lagi.",
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
                              setState(() {
                                  setMessage = 0;
                                  _prepareroomact();
                              });
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:2),
                          child:
                          Padding (
                              padding: const EdgeInsets.only(left: 25,right: 25,top: 5),
                              child :
                              OutlineButton(
                                child: Text("Tutup"),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                      builder: (BuildContext context) => Home()));

                                },
                              )
                          ),
                        ),


                      ],
                    )

            )));
  }
}
