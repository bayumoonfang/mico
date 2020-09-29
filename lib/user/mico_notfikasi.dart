import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/mico_detailnotif.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/page_login.dart';
import 'package:mico/user/get_chathistory.dart';
import 'package:mico/user/get_videohistory.dart';
import 'file:///D:/PROJECT%20KANTOR/mico/lib/backup/mico_historytransaksi_BACKUP.dart';
import 'package:http/http.dart' as http;
import 'package:mico/user/mico_appointment.dart';
import 'package:mico/user/mico_historytransaksi.dart';
import 'dart:async';
import 'dart:convert';

import 'package:mico/user/mico_userprofile.dart';




class Notifikasi extends StatefulWidget {
  final String getPhone;
  const Notifikasi(this.getPhone);
  @override
  _NotifikasiState createState() => new _NotifikasiState(getPhoneState: this.getPhone);

}


class _NotifikasiState extends State<Notifikasi> {
  String getAcc, getPhoneState;
  List data;
  _NotifikasiState({this.getPhoneState});


  Future<bool> _onWillPop() async {

  }
  Future<void> _getData() async {
    setState(() {
      getData2();
    });
  }


  @override
  void initState() {
    super.initState();
    _getCountApp();
    _getCountMessage();
  }



  Future<List> getData2() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_promo&id="
            +getPhoneState);
    setState((){
      data = json.decode(response.body);
    });
  }

  String countmessage = '0';
  String countapp = "0";

  _getCountMessage() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countmessage&id="+getPhoneState);
    Map data = jsonDecode(response.body);
    setState(() {
      countmessage = data["a"].toString();
    });
  }

  _getCountApp() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countapp&id="+getPhoneState);
    Map data2 = jsonDecode(response.body);
    setState(() {
      countapp = data2["a"].toString();
    });
  }



      @override
      Widget build(BuildContext context) {
        return new WillPopScope(
            onWillPop: _onWillPop,
            child: new Scaffold(
                backgroundColor: Colors.white,
                appBar: new AppBar(
                  backgroundColor: Hexcolor("#075e55"),
                  leading: Icon(Icons.clear,color: Hexcolor("#075e55"),),
                  title: new Text("Message",style: TextStyle(color : Colors.white,
                      fontFamily: 'VarelaRound',fontSize: 17,
                      fontWeight: FontWeight.bold),),
                  elevation: 0.5,
                  centerTitle: true,
                ),
                body:
                RefreshIndicator(
        onRefresh: _getData ,
        child :
                Container(
                  child: new FutureBuilder<List>(
                    future: getData2(),
                    builder: (context, snapshot) {
                      if (data == null) {
                        return Center(
                            child: Image.asset(
                              "assets/loadingq.gif",
                              width: 150.0,
                            )
                        );
                      } else {
                        return data.isEmpty
                            ? Center(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  "Tidak ada pesan",
                                  style: new TextStyle(
                                      fontFamily: 'VarelaRound', fontSize: 20),
                                ),
                              ],
                            ))
                            : new ListView.builder(
                          padding: const EdgeInsets.only(top: 15.0),
                          itemCount: data == null ? 0 :
                          data.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        EnterPage(page: DetailNotif(data[i]["a"].toString(), getPhoneState)));
                                  },
                                  child: ListTile(
                                      leading:
                                          Padding (
                                            padding : const EdgeInsets.only(left : 10.0),
                                              child :
                                                data[i]["d"] == '1' ?
                                                  GFIconBadge(
                                                      child: CircleAvatar(
                                                      backgroundImage: AssetImage("assets/mira-ico.png"),
                                                      radius: 15,
                                                      backgroundColor: Colors.white,
                                                  ),
                                                 )
                                            :
                                                  GFIconBadge(
                                                      child: CircleAvatar(
                                                        backgroundImage: AssetImage("assets/mira-ico.png"),
                                                        radius: 15,
                                                        backgroundColor: Colors.white,
                                                      ),
                                                      counterChild: GFBadge(
                                                        color:
                                                        Colors.redAccent,
                                                        size: 16,
                                                        shape:
                                                        GFBadgeShape.circle,
                                                      )
                                                  ),
                                          ),
                                      title: Container(
                                        margin: EdgeInsets.only(
                                          left: 6,
                                          top: 0,
                                          right: 0,
                                          bottom: 0,
                                        ),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              data[i]["b"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'VarelaRound',fontSize: 15),
                                            )),
                                      ),
                                      subtitle: Container(
                                          margin: EdgeInsets.only(
                                            left: 6,
                                            top: 0,
                                            right: 0,
                                            bottom: 0,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      2.0)),
                                              Align(
                                                alignment:
                                                Alignment.bottomLeft,
                                                child: Text("Diposting pada :"+
                                                    data[i]["c"],
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'VarelaRound', fontSize: 13)),
                                              ),
                                            ],
                                          ))),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 80, right: 15),
                                    child: Divider(
                                      height: 3.0,
                                    )),

                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                )),
              bottomNavigationBar: _bottomNavigationBar(),

            )
        );

      }



  int _currentTabIndex = 0;
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [

        BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.home,
              size: 22,
            ),
            title: Text("Home",
                style: TextStyle(
                  fontFamily: 'VarelaRound',
                ))),



        BottomNavigationBarItem(
          icon:   countapp == '0' ?
          FaIcon(
            FontAwesomeIcons.calendarCheck,
            size: 22,
          )
              :
          GFIconBadge(
              child:FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 22,
              ),
              counterChild: GFBadge(
                color: Colors.redAccent,
                size: 16,
                shape:
                GFBadgeShape.circle,
              )
          ),
          title: Text("Appointment",
              style: TextStyle(
                fontFamily: 'VarelaRound',
              )),
        ),




        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.fileAlt,
            size: 22,
          ),
          title: Text("History",
              style: TextStyle(
                fontFamily: 'VarelaRound',
              )),
        ),

        BottomNavigationBarItem(
          icon:   countmessage == '0' ?
          FaIcon(
            FontAwesomeIcons.envelopeOpenText,
            size: 22,
          )
              :
          GFIconBadge(
              child:FaIcon(
                FontAwesomeIcons.envelopeOpenText,
                size: 22,
              ),
              counterChild: GFBadge(
                color:
                Colors.redAccent,
                size: 16,
                shape:
                GFBadgeShape.circle,
              )
          ),
          title: Text("Message",
              style: TextStyle(
                fontFamily: 'VarelaRound',
              )),
        ),

        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.userCircle,
            size: 22,
          ),
          title: Text("Account",
              style: TextStyle(
                fontFamily: 'VarelaRound',
              )),
        )

      ],
      onTap: _onTap,
      currentIndex: 3,
      selectedItemColor: Hexcolor("#628b2c"),
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
      // _navigatorKey.currentState.pushReplacementNamed("Home");
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => Home()));
        break;
      case 1:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => AppointmentList(getPhoneState)));
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => HistoryTransaksi(getPhoneState)));
        break;
      case 3:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => Notifikasi(getPhoneState)));
        break;
      case 4:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => UserProfile(getPhoneState)));
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }



  }