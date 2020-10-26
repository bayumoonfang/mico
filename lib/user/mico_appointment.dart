import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/mico_transaksihistorynew.dart';
import 'package:mico/user/get_appointment.dart';
import 'package:mico/user/mico_detailappointment.dart';
import 'package:mico/user/mico_historytransaksi.dart';
import 'package:mico/user/mico_notfikasi.dart';
import 'package:mico/user/mico_userprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';


class AppointmentList extends StatefulWidget {
  final String getPhone;
  const AppointmentList(this.getPhone);
  @override
  _AppointmentListState createState() => new _AppointmentListState(getPhoneState: this.getPhone);

}


class _AppointmentListState extends State<AppointmentList> with SingleTickerProviderStateMixin {
  TabController controller;
  String getAcc, getPhoneState;
  _AppointmentListState({this.getPhoneState});

List data;


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {

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


  Future<List> getData() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_appointment&id=" +
            widget.getPhone);
    setState((){
      data = json.decode(response.body);
    });
  }


  void _loaddata() async {
    await _getCountMessage();
    await _getCountApp();
  }

  @override
  void initState() {
    super.initState();
    _loaddata();//LENGTH = TOTAL TAB YANG AKAN DIBUAT
  }




  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child:  Scaffold(
          body:
        Container(
          width: double.infinity,
        color: Colors.white,
            child: Column(
              children: [
                  Padding(
                    padding: const EdgeInsets.only(left:20,top: 50),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("My Activity",
                          style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 26,
                            fontWeight: FontWeight.bold
                          )),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left:15,top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  RaisedButton(
                      elevation: 0,
                      color: HexColor("#f7f7f7"),
                      child: Text("Recent",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                            fontWeight: FontWeight.bold,
                            color: HexColor("#00b250")
                          )),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: (){


                      },
                    )
                  ),
                ),

         Expanded(
                    child: new FutureBuilder<List>(
                        future: getData(),
                        builder : (context, snapshot) {
                            return ListView.builder(
                                padding: const EdgeInsets.only(top: 15.0),
                                itemCount: data == null ? 1 : data.isEmpty ? 1 : data.length,
                                itemBuilder: (context, i) {
                                  if (data == null) {
                                    return
                                      Padding(
                                        padding: const EdgeInsets.only(
                                        top: 200),
                                  child:
                                      Center(
                                        child: Image.asset(
                                          "assets/loadingq.gif",
                                          width: 110.0,
                                        )
                                    ));
                                  } else {
                                    return data.isEmpty ?

                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 200),
                                        child:
                                        Center(
                                            child: new Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                new Text(
                                                  "Tidak ada aktifitas",
                                                  style: new TextStyle(
                                                      fontFamily: 'VarelaRound',
                                                      fontSize: 18),
                                                ),
                                              ],
                                            )))
                                        :
                                    InkWell(
                                      child:
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10),
                                          child:
                                          Card(
                                              elevation: 0,
                                              color: HexColor("#f7f7f7"),
                                              child:
                                              Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .only(top: 15,
                                                            left: 13,
                                                            right: 10,
                                                            bottom: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          //mainAxisSize: MainAxisSize.max,
                                                          children: <Widget>[
                                                            Text(
                                                              "Konsultasi " +
                                                                  data[i]["m"] +
                                                                  " dengan",
                                                              textAlign: TextAlign
                                                                  .left,
                                                              style: TextStyle(
                                                                  fontFamily: 'VarelaRound',
                                                                  fontSize: 14),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    5),
                                                                border: Border
                                                                    .all(
                                                                  color:
                                                                  data[i]["c"] ==
                                                                      'DONE'
                                                                      ? HexColor(
                                                                      "#075e55")
                                                                      : Colors
                                                                      .red,
                                                                  //                   <--- border color
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              padding: const EdgeInsets
                                                                  .all(5),
                                                              child: Text(
                                                                  data[i]["c"] ==
                                                                      'PAID'
                                                                      ? "On Going"
                                                                      : data[i]["c"],
                                                                  style: TextStyle(
                                                                      fontFamily: 'VarelaRound',
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color:
                                                                      data[i]["c"] ==
                                                                          'DECLINE'
                                                                          ? Colors
                                                                          .red
                                                                          : Colors
                                                                          .black,
                                                                      fontSize: 12)),
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          top: 10, bottom: 10),
                                                      child: ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundImage: CachedNetworkImageProvider(
                                                              "https://duakata-dev.com/miracle/media/photo/" +
                                                                  data[i]["e"],
                                                            ),
                                                            backgroundColor: Colors
                                                                .white,
                                                            radius: 30,
                                                          ),
                                                          title: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              data[i]["f"],
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily: 'VarelaRound'),
                                                            ),
                                                          ),
                                                          subtitle:
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 2)
                                                                  ,
                                                                  child:
                                                                  Align(
                                                                    alignment: Alignment
                                                                        .centerLeft,
                                                                    child: Text(
                                                                      data[i]["g"],
                                                                      style: TextStyle(
                                                                          fontSize: 13,
                                                                          fontFamily: 'VarelaRound'),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 2),
                                                                  child:
                                                                  Align(
                                                                    alignment: Alignment
                                                                        .centerLeft,
                                                                    child: Text(
                                                                      data[i]["k"] +
                                                                          " - " +
                                                                          new DateFormat
                                                                              .MMM()
                                                                              .format(
                                                                              DateTime
                                                                                  .parse(
                                                                                  data[i]["l"]))
                                                                          +
                                                                          " - " +
                                                                          data[i]["i"] +
                                                                          " (" +
                                                                          data[i]["d"] +
                                                                          ")",
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily: 'VarelaRound'),
                                                                    ),
                                                                  )),
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(bottom: 15),
                                                    )
                                                  ]
                                              )
                                          )),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (
                                                    BuildContext context) =>
                                                    DetailAppointment(
                                                        data[i]["a"]
                                                            .toString())));
                                      },
                                    );
                                  }
                                }
                            );

                        }
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
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                TransaksiHistoryNew(getPhoneState)));
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