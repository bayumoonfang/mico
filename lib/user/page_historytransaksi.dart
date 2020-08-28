import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_home.dart';
import 'package:mico/page_login.dart';
import 'package:mico/user/get_chathistory.dart';
import 'package:mico/user/get_videohistory.dart';
import 'package:mico/user/page_notfikasi.dart';
import 'package:mico/user/page_userprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';


class HistoryTransaksi extends StatefulWidget {
  final String getPhone;
  const HistoryTransaksi(this.getPhone);
  @override
  _HistoryTransaksiState createState() => new _HistoryTransaksiState(getPhoneState: this.getPhone);

}


class _HistoryTransaksiState extends State<HistoryTransaksi> with SingleTickerProviderStateMixin {
  TabController controller;
  String getAcc, getPhoneState;
  _HistoryTransaksiState({this.getPhoneState});


  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    _getCountMessage();//LENGTH = TOTAL TAB YANG AKAN DIBUAT
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {

  }
  String countmessage = '0';
  void _getCountMessage() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countmessage&id="+getPhoneState);
    Map data = jsonDecode(response.body);
    setState(() {
      countmessage = data["a"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child:  Scaffold(
          backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Hexcolor("#075e55"),
                leading: Icon(Icons.clear,color: Hexcolor("#075e55"),),
                title: new Text("History Transaksi",style: TextStyle(color : Colors.white,fontFamily: 'VarelaRound',fontSize: 18),),
                elevation: 0.0,
                centerTitle: true,
                bottom: TabBar(
                  controller: controller,
                unselectedLabelColor: Hexcolor("#c0c0c0"),
                labelColor: Colors.white,
                indicatorWeight: 2,
                indicatorColor: Colors.white,
                  tabs: <Tab>[
                        Tab(text: "Chat"),
                        Tab(text: "Video",)                     
                  ],
                ),
              ),
          body:
          TabBarView(
            controller: controller,
            children: <Widget>[
              ChatHistory(getPhoneState),
              VideoHistory(getPhoneState)
            ],
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
          icon: countmessage == '0' ?
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
      currentIndex: 1,
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
                builder: (BuildContext context) => HistoryTransaksi(getPhoneState)));
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => Notifikasi(getPhoneState)));
        break;
      case 3:
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