import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;
import 'package:mico/services/page_chatroomhome.dart';
import 'package:mico/services/page_historychat.dart';
import 'package:mico/user/mico_detailappointment.dart';
import 'package:mico/user/page_detailhistorytransaksi.dart';
import 'dart:async';
import 'dart:convert';

import 'file:///D:/PROJECT%20KANTOR/mico/lib/backup/mico_historytransaksi_BACKUP.dart';


class GetTransaksi extends StatefulWidget {
  final String getPhone;
  const GetTransaksi(this.getPhone);
  @override
  _GetTransaksiState createState() => new _GetTransaksiState(getPhoneState: this.getPhone);
}


class _GetTransaksiState extends State<GetTransaksi> {
  List data;
  String getAcc, getPhoneState;
  _GetTransaksiState({this.getPhoneState});


  @override
  void initState() {
    getData();
    super.initState();
  }


  Future<List> getData() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_appointment3&id=" +
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
              color: Hexcolor("#f5f5f5"),
              margin: EdgeInsets.all(10.0),
              child: new FutureBuilder<List>(
                  future: getData(),
                  builder : (context, snapshot) {
                    if (data == null) {
                      return Center(
                          child: Image.asset(
                            "assets/loadingq.gif",
                            width: 110.0,
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
                                "Tidak ada Transaksi",
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
                                child :
                                Padding (
                                    padding: const EdgeInsets.only(bottom: 10),
                                child : Card(
                                    child :
                                    Column(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                      Expanded(
                                                        child :
                                                        Container (
                                                          color : data[i]["c"] == 'DECLINE' ? Hexcolor("#fdebeb") : Hexcolor("#f2fef2"),
                                                        child :
                                                        Center(
                                                          child : Padding(
                                                            padding : const EdgeInsets.all(10),
                                                            child : Text(data[i]["c"],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color : Hexcolor("#756b6a"),
                                                                  fontFamily: 'VarelaRound'),)
                                                          )
                                                        )
                                                      ))

                                                ],
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10,bottom: 10),
                                          ),

                                        ]
                                    )
                                )),
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => DetailAppointment(data[i]["a"].toString())));

                                },
                              );
                          }
                      );
                    }
                  }
              )
          ));
  }

}

