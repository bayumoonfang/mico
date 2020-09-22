import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;
import 'package:mico/services/page_chatroomhome.dart';
import 'package:mico/services/page_historychat.dart';
import 'package:mico/user/page_detailhistorytransaksi.dart';
import 'dart:async';
import 'dart:convert';

import 'package:mico/user/page_historytransaksi.dart';


class GetAppointment extends StatefulWidget {
  final String getPhone;
  const GetAppointment(this.getPhone);
  @override
  _GetAppointmentState createState() => new _GetAppointmentState(getPhoneState: this.getPhone);
}


class _GetAppointmentState extends State<GetAppointment> {
  List data;
  String getAcc, getPhoneState;
  _GetAppointmentState({this.getPhoneState});


  @override
  void initState() {
    getData();
    super.initState();
  }


  Future<List> getData() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_appointment&id=" +
            getPhoneState);
    setState((){
      data = json.decode(response.body);
    });
  }

  Future<void> _getData() async {
    setState(() {
      getData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return
      RefreshIndicator(
          onRefresh: _getData,
          child :
          Container(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              child: new FutureBuilder<List>(
                  future: getData(),
                  builder : (context, snapshot) {
                    if (data == null) {
                      return Center(
                          child: Image.asset(
                            "assets/loadingq.gif",
                            width: 150.0,
                          )
                      );
                    } else {
                      return data.isEmpty
                          ?
                      Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                "Tidak ada appointment",
                                style: new TextStyle(
                                    fontFamily: 'VarelaRound', fontSize: 18),
                              ),
                            ],
                          ))
                          :
                      new ListView.builder(
                          padding: const EdgeInsets.only(top: 5.0),
                          itemCount: data == null ? 0 : data.length,
                          itemBuilder: (context, i) {
                            return
                                InkWell(
                                  child : Card(
                                      child :
                                          Column(
                                          children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 15,left: 13,right: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        //mainAxisSize: MainAxisSize.max,
                                                        children: <Widget>[
                                                          Text(
                                                            "Konsultasi dengan",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                                fontFamily: 'VarelaRound',
                                                                fontSize: 14),
                                                          ),
                                                         Container(
                                                           color: Hexcolor("#DDDDDD"),
                                                           padding: const EdgeInsets.all(2),
                                                           child:  Text(data[i]["c"],
                                                               style: TextStyle(
                                                                   fontFamily: 'VarelaRound',
                                                                   fontWeight: FontWeight.bold,
                                                                   fontSize: 13)),
                                                         )
                                                        ],
                                                      )
                                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 5,left: 13),
                                        child : Align(
                                            alignment: Alignment.centerLeft,
                                            child :
                                            Opacity(
                                              opacity: 0.7
                                              ,
                                              child :
                                            Text(data[i]["d"],
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'VarelaRound')))
                                        )
                                    ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 0),
                                              child: ListTile(
                                                leading:         CircleAvatar(
                                                  backgroundImage: CachedNetworkImageProvider("https://duakata-dev.com/miracle/media/photo/" +
                                                      data[i]["e"],
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  radius: 20,
                                                ),
                                                title:  Align(
                                                  alignment: Alignment.centerLeft,
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
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        data[i]["g"],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily: 'VarelaRound'),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        data[i]["g"],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily: 'VarelaRound'),
                                                      ),
                                                    ),
                                                  ],
                                                )


                                              ),
                                            )

                                              ]
                                          )
                                    )
                                );
                          }
                      );
                    }
                  }
              )
          ));
  }

}

