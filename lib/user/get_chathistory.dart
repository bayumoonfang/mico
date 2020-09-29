import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;
import 'package:mico/services/page_chatroomhome.dart';
import 'package:mico/services/page_historychat.dart';
import 'package:mico/user/page_detailhistorytransaksi.dart';
import 'dart:async';
import 'dart:convert';

import 'file:///D:/PROJECT%20KANTOR/mico/lib/backup/mico_historytransaksi_BACKUP.dart';


class ChatHistory extends StatefulWidget {
  final String getPhone;
  const ChatHistory(this.getPhone);
  @override
  _ChatHistoryState createState() => new _ChatHistoryState(getPhoneState: this.getPhone);
}


  class _ChatHistoryState extends State<ChatHistory> {
  List data;
  String getAcc, getPhoneState;
  _ChatHistoryState({this.getPhoneState});


  @override
  void initState() {
    getData();
    super.initState();
  }


  Future<List> getData() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_transaksichat&id=" +
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
                        width: 100.0,
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
                            "Tidak ada transaksi",
                            style: new TextStyle(
                                fontFamily: 'VarelaRound', fontSize: 18),
                          ),
                        ],
                      ))
                      :
                  new ListView.builder(
                      padding: const EdgeInsets.only(top: 15.0),
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (context, i) {
                        return Column (
                          children: <Widget>[

                            InkWell(
                              child : Card(
                                  child : ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage("assets/mira-ico.png"),
                                        backgroundColor: Colors.white,
                                        radius: 20,
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
                                                child: Text("Konsultasi pada : "+
                                                    data[i]["c"],
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'VarelaRound',fontSize: 13)),
                                              ),
                                            ],
                                          )),
                                    trailing:
                        data[i]["d"] == 'CLOSE' ?
                                    Text(data[i]["d"],style: TextStyle(
                                        fontFamily:
                                        'VarelaRound',fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red))
                                    :
                        Text(data[i]["d"],style: TextStyle(
                            fontFamily:
                            'VarelaRound',fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green))


                                  )
                              ),
                              onTap: (){
                                data[i]["d"] == 'CLOSE' ?
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) => ChathistoryArchived(data[i]["e"])))
                                    :
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) => Chatroomhome(widget.getPhone,'2')));
                                //Navigator.push(context, EnterPage(page:DetailHistoryTransaksi(snapshot.data[i]["e"])));
                              },
                            )
                          ],
                        );
                      }
                  );
                }
              }
          )
      ));
    }

  }

