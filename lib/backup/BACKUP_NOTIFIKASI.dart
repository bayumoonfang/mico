
/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/mico_detailnotif.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/mico_transaksihistorynew.dart';
import 'package:mico/user/mico_appointment.dart';
import 'dart:async';
import 'dart:convert';

import 'package:mico/user/mico_userprofile.dart';


class NotifNew extends StatefulWidget {
  final String getPhone;
  const NotifNew(this.getPhone);
  @override
  _NotifNewState createState() => new _NotifNewState(getPhoneState: this.getPhone);
}


class _NotifNewState extends State<NotifNew> {
  String getAcc, getPhoneState;
  List data;
  _NotifNewState({this.getPhoneState});


  Future<bool> _onWillPop() async {

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
            backgroundColor: Colors.white,
            leading: Icon(Icons.clear,color: Colors.white),
            title: new Text("Messages",style: TextStyle(color : Colors.black,
                fontFamily: 'VarelaRound',fontSize: 17,
                fontWeight: FontWeight.bold),),
            elevation: 0.5,
            centerTitle: true,
          ),
          body:
          Expanded(
            child: new FutureBuilder<List>(
              future: getData2(),
              builder: (context, snapshot) {
                if (data == null) {
                  return Center(
                      child: Image.asset(
                        "assets/loadingq.gif",
                        width: 110.0,
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
                      return InkWell(
                          onTap: (){
                            Navigator.push(context,
                                ExitPage(page: DetailNotif(data[i]["a"].toString(), getPhoneState)));
                          },
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child:  Card(
                                  margin: const EdgeInsets.only(left: 8,right: 8,bottom: 5),
                                  color: HexColor("#f7f7f7"),
                                  elevation: 0,
                                  child: ListTile(
                                      leading:
                                      Padding (
                                        padding : const EdgeInsets.only(left : 2.0),
                                        child :
                                        data[i]["d"] == '1' ?
                                        CircleAvatar(
                                          backgroundImage: AssetImage("assets/mira-ico.png"),
                                          radius: 20,
                                          backgroundColor: Colors.white,

                                        )
                                            :
                                        GFIconBadge(
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage("assets/mira-ico.png"),
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                            ),
                                            counterChild: GFBadge(
                                              color:
                                              Colors.redAccent,
                                              size: 18,
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
                                          ))
                                  )

                              )
                          )
                      );
                    },
                  );
                }
              },
            ),
          ),
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
          title: Text("Activity",
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
                builder: (BuildContext context) => AppointmentList(widget.getPhone)));
        break;
      case 2:
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                TransaksiHistoryNew(widget.getPhone)));
        break;
      case 3:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => NotifNew(widget.getPhone)));
        break;
      case 4:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => UserProfile(widget.getPhone)));
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }



}
*/