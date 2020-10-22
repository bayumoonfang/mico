import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:mico/helper/session_user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mico/mico_home.dart';
import 'package:mico/page_login.dart';
import 'package:mico/user/mico_appointment.dart';
import 'package:mico/user/mico_historytransaksi.dart';
import 'package:mico/user/mico_notfikasi.dart';


class UserProfile extends StatefulWidget {
  final String getPhone;
  const UserProfile(this.getPhone);
  @override
  _UserProfileState createState() => new _UserProfileState(getPhoneState: this.getPhone);

}


class _UserProfileState extends State<UserProfile> {
  String getAcc, getPhoneState;
  _UserProfileState({this.getPhoneState});
  String getName = '';
  String getPhone = '';

  Future<bool> _onWillPop() async {

  }


  _session() async {
    int value = await Session.getValue();
    getAcc = await Session.getAccnumber();
    if (value != 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }



  void _getAccountDetail() async {
    await _session();
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_detailuser&id="+getPhoneState);
    Map data = jsonDecode(response.body);
    setState(() {
       getName = data["nama"].toString();
       getPhone = data["phone"].toString();
    });
  }


  @override
  void initState() {
    super.initState();
    _getAccountDetail();
    _getCountApp();
    _getCountMessage();
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
              child:  new Scaffold(
                      body:
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 50.0),
                        // color: Hexcolor("#f5f5f5"),
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 10.0),
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            backgroundImage:
                                            AssetImage("assets/mira-ico.png")),
                                        title: Text(getName,
                                            style: TextStyle(
                                              fontFamily: 'VarelaRound',
                                            )),
                                        subtitle: Text(getPhone,
                                            style: TextStyle(
                                              fontFamily: 'VarelaRound',
                                            )),
                                      )),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 5.0),
                                child:
                                Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Lainnya",
                                              style: TextStyle(
                                                fontFamily: 'VarelaRound',
                                                fontSize: 20,
                                              )),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: ListTile(
                                        leading: Icon(Icons.info),
                                        title: Text("Bantuan"),
                                        trailing: Icon(Icons.keyboard_arrow_right),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Divider(
                                          height: 1.0,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: ListTile(
                                        leading: Icon(Icons.settings),
                                        title: Text("Pengaturan Aplikasi"),
                                        trailing: Icon(Icons.keyboard_arrow_right),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Divider(
                                          height: 1.0,
                                        )),
                                  ],
                                )

                            )
                          ],
                        ),
                      ),
                      bottomNavigationBar: _bottomNavigationBar(),

                    ));


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
          icon: FaIcon(
            FontAwesomeIcons.envelopeOpenText,
            size: 22,
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
      currentIndex: 4,
      selectedItemColor: HexColor("#628b2c"),
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