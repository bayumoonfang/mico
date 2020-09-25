


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/mico_home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:mico/user/page_notfikasi.dart';


class DetailNotif extends StatefulWidget {
  final String IDmessage, getPhone;
  const DetailNotif(this.IDmessage, this.getPhone);
  _DetailNotifState createState() =>
      new _DetailNotifState(getIDMessage: this.IDmessage, getPhoneState: this.getPhone);
}


class _DetailNotifState extends State<DetailNotif> {
  String getIDMessage, getPhoneState;
  List data;
  _DetailNotifState({this.getIDMessage, this.getPhoneState});

  void _doDelete(String getID) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_deletemessage";
    http.post(url,
        body: {
          "id": getID,
        });
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => Notifikasi(getPhoneState)));
  }


  void _doRead() {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_changestatmessage";
    http.post(url,
        body: {
          "id": getIDMessage,
        });

  }




  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://duakata-dev.com/miracle/api_script.php?do=getdata_detailmessage&id=" +
                getIDMessage),
        headers: {"Accept": "application/json"}
    );
    setState(() {
      data = json.decode(response.body);
      _doRead();
    });
  }




  void _deleteMessage(String valme) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Text(
                "Apakah anda yakin untuk menghapus pesan ini  ?",
                style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18)),
            actions: [
              new FlatButton(
                  onPressed: () {
                   _doDelete(valme);
                  },
                  child:
                  Text("Iya", style: TextStyle(fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18)))
            ],
          );
        });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child:
        Scaffold(
            appBar: new AppBar(
              backgroundColor: Hexcolor("#075e55"),
              title: Text(
                "Detail Message",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VarelaRound',
                    fontSize: 16),
              ),
              leading: Builder(
                builder: (context) =>
                    IconButton(
                        icon: new Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          _onWillPop();
                        }
                    ),
              ),
              actions: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child:
                    Builder(
                      builder: (context) =>
                          IconButton(
                              icon: new FaIcon(
                                FontAwesomeIcons.trashAlt, size: 18,),
                              color: Colors.white,
                              onPressed: () {
                                _deleteMessage(getIDMessage.toString());
                              }
                          ),
                    )),
              ],
            ),
            body: new Container(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                child:
                _datafield()
            )
        )
    );
  }


            Widget _datafield() {
              return FutureBuilder<List>(
                  future: getData(),
                builder: (context, snapshot) {
                    if (data == null) {
                      return Center(
                          child: Image.asset(
                            "assets/loadingq.gif",
                            width: 180.0,
                          )
                      );
                    } else {
                         return ListView.builder(
                                        itemCount: data== null ? 0 : data.length,
                                          itemBuilder: (context, i) {
                                            return SingleChildScrollView(
                                              child : Column(
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets.only(left: 25,top:35,right: 20),
                                                      child:
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child:
                                                        Text(data[i]["a"], style: TextStyle(
                                                            fontFamily: 'VarelaRound',fontSize: 22, fontWeight: FontWeight.bold)),
                                                      )
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.only(left: 25,top: 5.0),
                                                      child:
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child:
                                                        Opacity(
                                                            opacity: 0.8,
                                                            child :
                                                            Text(data[i]["b"], style: TextStyle(
                                                                fontFamily: 'VarelaRound',fontSize: 12))),
                                                      )
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.only(left: 25,top: 10.0,right: 35),
                                                      child:
                                                      Divider(
                                                        height: 3,
                                                      )
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.only(left: 25,top: 30.0,right: 25),
                                                      child:
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child:
                                                        Text(utf8.decode(base64.decode(data[i]['c'])), style: TextStyle(
                                                            fontSize: 15,
                                                            height: 1.7)),
                                                      )
                                                  )
                                                ],
                                              )
                                            );
                                          }
                                      );
                    }
                },
              );
            }


}