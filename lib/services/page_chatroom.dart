import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/page_login.dart';


class Chatroomfix extends StatefulWidget {
  final String MyIDDokter, MyNamaDokter;
  const Chatroomfix(this.MyIDDokter, this.MyNamaDokter);
  @override
  _ChatroomfixState createState() => new _ChatroomfixState(
      getAccDokter: this.MyIDDokter, getNamaDokter: this.MyNamaDokter);
}

class _ChatroomfixState extends State<Chatroomfix> {
  List data;
  String getAccDokter, getNamaDokter, getEmail, getPhone;

  _ChatroomfixState({this.getAccDokter, this.getNamaDokter});

  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  FocusNode myFocusNode;
  Future<List> getDataChat() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_chat&id=" +
            getAccDokter);
    setState((){
      data = json.decode(response.body);
    });
  }

  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getPhone = await Session.getPhone();
    if (value != 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }

  @override
  void initState() {
    super.initState();
    _session();
    //startSplashScreen();
    //_addchat();
   // _buatlist();
  }


  void _getCustomer() async {
    
  }


  void _addchat() {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=addata_chat";
    http.post(url,
        body: {"messagetext": _textController.text, "iddokter": getAccDokter});
    _textController.clear();
    //myFocusNode.requestFocus();
  }

  Future<bool> _onWillPop() async {
    return Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
      child :
      Scaffold(
      appBar: new AppBar(
        backgroundColor: Hexcolor("#075e55"),
        title: new Text(getNamaDokter,
            style: TextStyle(
                color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => Home()));
            },
          ),
        ),
      ),
      body: new Container(
        child: Column(
          children: [
            _roomchat(),
          ],
        ),
      ),
      bottomSheet: new Container(child: _buildTextComposer()),
    ));
  }

  Widget _buildTextComposer() {
    return new Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          /*borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),*/
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        //margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _textController,
                    //focusNode: myFocusNode,
                    //onSubmitted: _handleSubmitted,
                    // onChanged: _handleChanged,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'VarelaRound',
                    ),
                    decoration: new InputDecoration.collapsed(
                      hintText: 'Kirim Pesan..',
                    ),
                  )),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () {
                    _addchat();
                    setState(() {
                      _roomchat();
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                      //FocusScope.of(context).requestFocus(myFocusNode);
                    });
                    // _roomchat();
                  }),
            ),
          ],
        ));
  }

  Widget _roomchat() {
    return Flexible(
        child: Container(
            margin: const EdgeInsets.only(bottom: 50.0),
            child: new FutureBuilder(
                future: getDataChat(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      padding: new EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 40.0),
                      reverse: false,
                      itemCount:
                      snapshot.data == null ? 0 : snapshot.data.length,
                      itemBuilder: (context, i) {
                          if (data[i]["d"] == '1') {
                            return Column(children: [
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      width: 250,
                                      alignment: Alignment.bottomRight,
                                      padding: const EdgeInsets.only(
                                          top: 15.0, bottom: 5.0),
                                      child: Card(
                                        color: Hexcolor("#f5f5dc"),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(data[i]["e"],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'VarelaRound',
                                              )),
                                        ),
                                      ))),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        right: 1.0, top: 0),
                                    child: Text(
                                        data[i]["g"].substring(12),
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: 'VarelaRound',
                                        )),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0))
                            ]);
                          } else {
                            return Column(children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      width: 300,
                                      padding: const EdgeInsets.only(
                                          top: 15.0, bottom: 5.0, right: 40),
                                      child: Card(
                                          color: Hexcolor("#f0f8ff"),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(data[i]["e"],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'VarelaRound',
                                                )),
                                          )))),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, top: 0),
                                    child: Text(
                                       data[i]["g"].substring(12),
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontFamily: 'VarelaRound',
                                        )),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0))
                            ]);
                          }

                      });
                })));
  }
}
