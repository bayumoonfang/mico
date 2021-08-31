import 'dart:io';

import 'package:badges/badges.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/mico_home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/page_login.dart';
import 'package:mico/services/mico_detailimagechat.dart';

import 'package:toast/toast.dart';
import 'package:photo_view/photo_view.dart';

/*
class ChathistoryArchived extends StatefulWidget {
  final String MyInvoiced;
  const ChathistoryArchived(this.MyInvoiced);

  @override
  _ChathistoryArchivedState createState() => new _ChathistoryArchivedState(
      getInvoiced: this.MyInvoiced);
}

class _ChathistoryArchivedState extends State<ChathistoryArchived> {
  List data, data2;

  String getInvoiced,getInvNumber;
  String getNamaDokter = '';
  String _isLoading = '0';
  bool _isVisible = false;

  _ChathistoryArchivedState({this.getInvoiced});
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController;
  FocusNode myFocusNode;

  Future<dynamic> _getDetailInvoiced() async {
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_detailchatinvoiced",
        body: {"invoice": widget.MyInvoiced});
    Map data = jsonDecode(response.body);
    setState(() {
       getNamaDokter = data["a"].toString();
       getInvNumber = data["b"].toString();
    });
  }


  Future<List> getDataChat2() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_chathistory&"
            "idclient="+widget.MyInvoiced);
    setState((){
      data = json.decode(response.body);

    });
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

  _session() async {
    int value = await Session.getValue();
    if (value != 1) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _connect();
    _session();
    _getDetailInvoiced();
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        //bottom
        _isVisible = false;
      });
    }
    else if (_scrollController.offset == _scrollController.position.minScrollExtent ) {
      setState(() {
        //top
        _isVisible = false;
      });
    } else {
      _isVisible = true;
    }
  }



  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child :
      Scaffold(
        appBar: new AppBar(
          backgroundColor: Hexcolor("#075e55"),
          title: new Text(getNamaDokter.toString(),
              style: TextStyle(
                  color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16)),
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body:new Container(
          color: Hexcolor("#efe6dd"),
          child: Column(
            children: [

              Padding(
                padding : const EdgeInsets.only(bottom: 5),
                child: Center(
                    child: Container(
                        width: double.infinity,
                        color : Hexcolor("#ffffff"),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10  ,right: 10,top: 15,bottom: 15),
                            child:
                            GestureDetector(
                              child :
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding :  const EdgeInsets.only(left: 5),
                                      child :
                                      Text(getInvNumber.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Hexcolor("#516067"),
                                            fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)),
                                  Padding(
                                      padding :  const EdgeInsets.only(right: 10),
                                      child :
                                      Text("Detail",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Hexcolor("#516067"),
                                            fontFamily: 'VarelaRound',fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),

                                ],
                              ),
                              onTap: (){
                                Navigator.push(context, EnterPage(page: DetailHistoryTransaksi(getInvNumber.toString())));
                              },)
                        )
                    )
                ),
              ),





              Padding(
                padding : const EdgeInsets.only(top:10,bottom: 5),
                child: Center(
                    child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color : Hexcolor("#d4eaf5"),
                          boxShadow: [
                            //BoxShadow(color: Colors.white, spreadRadius: 1),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10  ,right: 10,top: 6,bottom: 6),
                          child: Text(formatDate(
                            // DateTime.now(), [dd, '-', mm, '-', yy, ' ', HH, ':', nn]),
                              DateTime.now(), [dd, ' ', MM, ' ', yyyy]),
                              style: TextStyle(
                                fontSize: 12,
                                color: Hexcolor("#516067"),
                                fontFamily: 'VarelaRound',)),
                        )
                    )
                ),
              ),
              Flexible(
                  child: Container(
                      color: Hexcolor("#efe6dd"),
                      height: double.infinity,
                      margin: const EdgeInsets.only(bottom: 1.0),
                      child: new FutureBuilder(
                          future: getDataChat2(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                padding: new EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 30.0),
                                reverse: false,
                                itemCount:
                                data == null ? 0 : data.length,
                                itemBuilder: (context, i) {
                                  if (data[i]["d"] == '1') {
                                    return Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:5),
                                      ),
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                              alignment: Alignment.bottomLeft,
                                              padding: const EdgeInsets.only(
                                                  top: 0, bottom: 0),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color : Hexcolor("#ffffff"),
                                                        boxShadow: [
                                                          //BoxShadow(color: Colors.white, spreadRadius: 1),
                                                        ],
                                                      ),
                                                      child :

                                                      Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child:
                                                          data[i]["h"] != '' && data[i]["d"] == '1' ?
                                                          GestureDetector(
                                                            child: Hero(
                                                                tag: data[i]["h"],
                                                                child :
                                                                Image(
                                                                  image: NetworkImage("https://duakata-dev.com/miracle/media/imgchat/"+ data[i]["h"]),
                                                                  height: 160,
                                                                  width: 160,
                                                                )),
                                                            onTap: (){
                                                              Navigator.of(context).push(
                                                                  new MaterialPageRoute(
                                                                      builder: (BuildContext context) => DetailScreen(data[i]["h"].toString())));
                                                            },
                                                          )
                                                              :
                                                          Text(data[i]["e"],
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily: 'VarelaRound',
                                                              ))
                                                      )
                                                  ),

                                                ],
                                              )
                                          )
                                      ),
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 3.0, top: 5),
                                            child: Text(
                                                data[i]["g"],
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontFamily: 'VarelaRound',
                                                )),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(bottom: 0.0))
                                    ]);
                                  } else {
                                    return
                                      Padding(
                                          padding: const EdgeInsets.only(top:0),
                                          child :
                                          Column(children: [
                                            Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                    padding: const EdgeInsets.only(
                                                        top: 0, bottom: 0),
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color : Hexcolor("#e2ffc7"),
                                                            boxShadow: [
                                                              // BoxShadow(color: Colors.white, spreadRadius: 1),
                                                            ],
                                                          ),
                                                          child :
                                                          data[i]["e"] != 'Message has been deleted..' ?
                                                          InkWell(
                                                            child :
                                                            Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child:
                                                                data[i]["h"] != '' && data[i]["d"] == '2' ?
                                                                GestureDetector(
                                                                  child: Hero(
                                                                      tag: data[i]["h"],
                                                                      child :
                                                                      Image(
                                                                        image: NetworkImage("https://duakata-dev.com/miracle/media/imgchat/"+ data[i]["h"]),
                                                                        height: 160,
                                                                        width: 160,
                                                                      )),
                                                                  onTap: (){
                                                                    Navigator.of(context).push(
                                                                        new MaterialPageRoute(
                                                                            builder: (BuildContext context) => DetailScreen(data[i]["h"].toString())));
                                                                  },
                                                                )
                                                                    :
                                                                data[i]["e"] == 'Message has been deleted..' ?
                                                                Text(data[i]["e"],
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'VarelaRound',
                                                                        fontStyle: FontStyle.italic
                                                                    ))
                                                                    :
                                                                Text(data[i]["e"],
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: 'VarelaRound',
                                                                    ))
                                                            ),
                                                            onLongPress: () {

                                                            },
                                                          )
                                                              :
                                                          Padding(
                                                              padding: const EdgeInsets.all(10.0),
                                                              child:
                                                              data[i]["h"] != '' && data[i]["d"] == '2' ?
                                                              GestureDetector(
                                                                child: Hero(
                                                                    tag: data[i]["h"],
                                                                    child :
                                                                    Image(
                                                                      image: NetworkImage("https://duakata-dev.com/miracle/media/imgchat/"+ data[i]["h"]),
                                                                      height: 160,
                                                                      width: 160,
                                                                    )),
                                                                onTap: (){
                                                                  Navigator.of(context).push(
                                                                      new MaterialPageRoute(
                                                                          builder: (BuildContext context) => DetailScreen(data[i]["h"].toString())));
                                                                },
                                                              )
                                                                  :
                                                              data[i]["e"] == 'Message has been deleted..' ?
                                                              Text(data[i]["e"],
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: 'VarelaRound',
                                                                      fontStyle: FontStyle.italic
                                                                  ))
                                                                  :
                                                              Text(data[i]["e"],
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontFamily: 'VarelaRound',
                                                                  ))
                                                          ),
                                                        ),
                                                      ],
                                                    ))),
                                            Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 3.0, top: 5),
                                                  child: Text(
                                                      data[i]["g"],
                                                      style: TextStyle(
                                                        fontSize: 8,
                                                        fontFamily: 'VarelaRound',
                                                      )),
                                                )),
                                            Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0))
                                          ]));
                                  }
                                }

                            );
                          }
                      )
                  )
              ),

            ],
          ),
        ),

      ),
    );
  }


}
*/


