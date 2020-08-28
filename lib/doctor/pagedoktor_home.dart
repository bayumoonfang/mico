



import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/doctor/pagedoctor_login.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/helper/session_dokter.dart';
import 'package:mico/page_loginstart.dart';
import 'package:mico/services/page_chatroomdoctor.dart';
import 'package:mico/services/page_videoroomdokter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../main.dart';


class HomeDoktor extends StatefulWidget {
  @override
  _HomeDoktorState createState() => new _HomeDoktorState();
}

class _HomeDoktorState extends State<HomeDoktor> {
  String getEmail,
  getPhone = '';

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }



  _session() async {
    int value = await Session_dokter.getValue();
    getEmail = await Session_dokter.getEmail();
    getPhone = await Session_dokter.getPhone();
    if (value != 1) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => LoginStart()));
    }
  }

  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {
        // Internet Present Case
      } else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }

  String getNama, getDrNumber, getCountMessage, getCountVideo = '';


  _detaildoktor() async {
    await _session();
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_detaildokter",
        body: {"id": getPhone});
    Map data = jsonDecode(response.body);
    setState(() {
      getNama = data["a"].toString();
      getDrNumber = data["b"].toString();
    });

  }


  _countmessage() async {
    await _session();
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_statuschatdoctor&iddoctor="+getPhone);
    Map data2 = jsonDecode(response.body);
    setState(() {
      getCountMessage = data2["a"].toString();
    });
  }



  _countvideo() async {
    await _session();
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_statusvideodoctor&iddoctor="+getPhone);
    Map data3 = jsonDecode(response.body);
    setState(() {
      getCountVideo = data3["a"].toString();
    });
  }




  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("phone", null);
      preferences.setString("email", null);
      preferences.setInt("iduser", null);
      preferences.setInt("accnumber", null);
      preferences.commit();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => LoginStart()));
    });
  }



  @override
  void initState() {
    super.initState();
    _connect();
    _detaildoktor();
    _countmessage();
    _countvideo();
  }


  Future<void> _getData() async {
    _countmessage();
    _countvideo();
  }


  Future<bool> _onWillPop() async {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child : Scaffold(
          backgroundColor: Colors.white,
             appBar: new AppBar(
               backgroundColor: Hexcolor("#075e55"),
               leading: Builder(
                 builder: (context) => IconButton(
                   icon: new Icon(Icons.menu),
                   color: Colors.white,
                   onPressed: () => Scaffold.of(context).openDrawer(),
                 ),
               ),
               title:
               Text(
                 "Miracle Aesthetic Clinic",
                 style: new TextStyle(
                     fontFamily: 'VarelaRound', fontSize: 16, color: Colors.white),
               ),
             ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Hexcolor("#628b2c"),
                  ),
                  accountName: new Text(getNama.toString(),
                      style: TextStyle(fontSize: 18)),
                  accountEmail: new Text(getEmail.toString()),
                  currentAccountPicture: new CircleAvatar(
                    radius: 150,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/mira-ico.png"),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                  ),
                  title:
                  Text('Logout', style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18)),
                  onTap: () {
                    signOut();
                  },
                )
              ],
            ),
          ),
          body: new
    RefreshIndicator(
    onRefresh: _getData ,
    child :
          Container(
            height: double.infinity,
            child :
                Column(
                  children: <Widget>[
                    Padding (
                    padding: const EdgeInsets.only(top:20.0,left: 20),
                    child :
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                        Text("Selamat Datang ..",
                        style: new TextStyle(
                        fontFamily: 'VarelaRound', fontSize: 15),
                        textAlign: TextAlign.left,)
                      )
                    ),
                    Padding (
                        padding: const EdgeInsets.only(top:5.0,left: 20),
                        child :
                        Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(getNama.toString(),
                              style: new TextStyle(
                                  fontFamily: 'VarelaRound', fontSize: 18,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,)
                        )),
                    Padding (
                      padding: const EdgeInsets.only(top: 15.0,left: 20.0,right: 20.0),
                      child :
                        Divider(height: 5)),
                    Padding (
                        padding: const EdgeInsets.only(top:20.0,left: 20),
                        child :
                        Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Text("Layanan Saya",
                              style: new TextStyle(
                                  fontFamily: 'VarelaRound', fontSize: 15,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,)
                        )
                    ),
                    Padding (
                      padding: const EdgeInsets.only(top:10.0,left: 10),
                      child :
                      Align(
                          alignment: Alignment.centerLeft,
                          child :
                       Wrap(
                         children: <Widget>[
                           Padding(
                               padding : const EdgeInsets.only(top:0, right: 10),
                               child :
                               Column(
                                 children: <Widget>[
                                   getCountMessage != '0' ?
                                   GestureDetector(
                                     onTap: () {
                                       Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                           builder: (BuildContext context) =>
                                               ChatroomDoctor(getDrNumber.toString())));
                                     },
                                     child :
                                     Badge(
                                       toAnimate: false,
                                       position: BadgePosition.topRight(top: 5, right: 6),
                                       padding: const EdgeInsets.all(6),
                                       badgeContent: Text(
                                         "1",
                                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,
                                             fontFamily: 'VarelaRound'),
                                       ),
                                       child :
                                     Container(
                                       margin: EdgeInsets.all(10),
                                       padding: EdgeInsets.all(14),
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(100),
                                           color: Hexcolor("#ccefdb"),
                                           border: Border.all(width: 1, color: Hexcolor("#DDDDDD"))),
                                       child:
                                       FaIcon(
                                         FontAwesomeIcons.comments,
                                         color: Hexcolor("#628b2c"),
                                         size: 20,
                                       ),
                                      )
                                     ),
                                   )
                                   :
                                   Container(
                                     margin: EdgeInsets.all(10),
                                     padding: EdgeInsets.all(14),
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(100),
                                         color: Hexcolor("#ccefdb"),
                                         border: Border.all(width: 1, color: Hexcolor("#DDDDDD"))),
                                     child:
                                     FaIcon(
                                       FontAwesomeIcons.comments,
                                       color: Hexcolor("#628b2c"),
                                       size: 20,
                                     ),
                                   ),

                                   Text("MiChat",
                                     style: new TextStyle(
                                         fontFamily: 'VarelaRound', fontSize: 12))
                                 ],
                               )
                           ),

                        Padding(
                            padding : const EdgeInsets.only(top:0),
                            child :
                            Column(
                              children: <Widget>[
                                getCountVideo != '0' ?
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VideoRoomDokterHome(getDrNumber.toString())));
                                  },

                                  child :
                                  Badge(
                                    toAnimate: false,
                                    position: BadgePosition.topRight(top: 5, right: 6),
                                    padding: const EdgeInsets.all(6),
                                    badgeContent: Text(
                                      "1",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,
                                          fontFamily: 'VarelaRound'),
                                    ),
                                    child :
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Hexcolor("#ccefdb"),
                                        border: Border.all(width: 1, color: Hexcolor("#DDDDDD"))),
                                    child: FaIcon(
                                      FontAwesomeIcons.video,
                                      color: Hexcolor("#628b2c"),
                                      size: 20,
                                    ),
                                  )),
                                )
                                :

                                Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Hexcolor("#ccefdb"),
                                      border: Border.all(width: 1, color: Hexcolor("#DDDDDD"))),
                                  child: FaIcon(
                                    FontAwesomeIcons.video,
                                    color: Hexcolor("#628b2c"),
                                    size: 20,
                                  ),
                                ),


                                Text("MiVideo",
                                    style: new TextStyle(
                                        fontFamily: 'VarelaRound', fontSize: 12))
                              ],
                            )
                        ),


                           Padding (
                               padding: const EdgeInsets.only(top:30.0,left: 10),
                               child :
                               Align(
                                   alignment: Alignment.centerLeft,
                                   child:
                                   Text("Menu Saya",
                                     style: new TextStyle(
                                         fontFamily: 'VarelaRound', fontSize: 15,fontWeight: FontWeight.bold),
                                     textAlign: TextAlign.left,)
                               )
                           ),


                         ],
                       )
                      )
                    ),



                    Padding (
                        padding: const EdgeInsets.only(top:10.0,left: 10),
                        child :
                        Align(
                            alignment: Alignment.centerLeft,
                            child :
                            Wrap(
                              children: <Widget>[
                                Padding(
                                    padding : const EdgeInsets.only(top:0, right: 10),
                                    child :
                                    Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            signOut();
                                          },
                                          child :
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                padding: EdgeInsets.only(left: 17.5,right: 17.5,top: 13.3,bottom: 13.3),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Hexcolor("#ccefdb"),
                                                    border: Border.all(width: 1, color: Hexcolor("#DDDDDD"))),
                                                child:
                                                FaIcon(
                                                  FontAwesomeIcons.clipboard,
                                                  color: Hexcolor("#628b2c"),
                                                  size: 20,
                                                ),
                                          ),
                                        ),
                                        Text("History",
                                            style: new TextStyle(
                                                fontFamily: 'VarelaRound', fontSize: 12))
                                      ],
                                    )
                                ),

                                Padding(
                                    padding : const EdgeInsets.only(top:0, right: 10),
                                    child :
                                    Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            signOut();
                                          },
                                          child : Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.only(left: 15,right: 15,top: 14,bottom: 14),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Hexcolor("#ccefdb"),
                                                border: Border.all(width: 1, color: Hexcolor("#DDDDDD"))),
                                            child: FaIcon(
                                              FontAwesomeIcons.chartArea,
                                              color: Hexcolor("#628b2c"),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Text("Statistik",
                                            style: new TextStyle(
                                                fontFamily: 'VarelaRound', fontSize: 12))
                                      ],
                                    )
                                ),

                                Padding(
                                    padding : const EdgeInsets.only(top:0),
                                    child :
                                    Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            signOut();
                                          },
                                          child : Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.only(left: 15.5,right: 15.5,top: 14,bottom: 14),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Hexcolor("#ccefdb"),
                                                border: Border.all(width: 1, color: Hexcolor("#DDDDDD"))),
                                            child: FaIcon(
                                              FontAwesomeIcons.user,
                                              color: Hexcolor("#628b2c"),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Text("Profile",
                                            style: new TextStyle(
                                                fontFamily: 'VarelaRound', fontSize: 12))
                                      ],
                                    )
                                ),



                              ],
                            )
                        )
                    )



                    ],
                )
        )),
        ));

  }



}