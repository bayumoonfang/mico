import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/mico_home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mico/services/mico_detailimagechat.dart';
import 'package:mico/user/mico_detailtagihan.dart';


class Chatroomhistory extends StatefulWidget {
  final String idAppointment, idPage;
  const Chatroomhistory(this.idAppointment,this.idPage);

  @override
  _ChatroomhistoryState createState() => new _ChatroomhistoryState();
}


class _ChatroomhistoryState extends State<Chatroomhistory> {
  List data;
  List data2;
  ScrollController _scrollController;
  bool _isVisible = false;
  final TextEditingController _textController = new TextEditingController();
  FocusNode myFocusNode;
  File galleryFile;
  String Base64;
  String _isLoading = '0';

  Future<bool> _onWillPop() async {
    widget.idAppointment == '1' ?
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
            builder: (BuildContext context) => Home()))
        :
    Navigator.pop(context);
  }



  //==================HTTP GET DATA========================================================
  String getInvNumber, getNamaDokter = "...";
  _getChatDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_chatdetail2&id="+widget.idAppointment);
    Map dataq = jsonDecode(response.body);
    setState(() {
      getInvNumber = dataq["a"].toString();
      getNamaDokter = dataq["b"].toString();
    });
  }

  Future<List> getDataChat2() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_chat3&"
            "id="+widget.idAppointment);
    setState((){
      data = json.decode(response.body);
    });
  }

  Future<List> getDataChat3() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countchatfixed&"
            "id="+widget.idAppointment);
    setState((){
      data2 = json.decode(response.body);

    });
  }

//==========================================================================================



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







  @override
  void initState() {
    super.initState();
    _getChatDetail();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);


  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child :
        Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor("#075e55"),
            title: new Text(getNamaDokter,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16)),
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  widget.idAppointment == '1' ?
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => Home()))
                      :
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          body: new Container(
              color: HexColor("#efe6dd"),
              child: Column(
                  children: [
                    Padding(
                      padding : const EdgeInsets.only(bottom: 5),
                      child: Center(
                          child: Container(
                              width: double.infinity,
                              color : HexColor("#ffffff"),
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
                                            Text(getInvNumber == null ? '...' : getInvNumber,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: HexColor("#516067"),
                                                  fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)),
                                        Padding(
                                            padding :  const EdgeInsets.only(right: 10),
                                            child :
                                            Text("Detail",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: HexColor("#516067"),
                                                  fontFamily: 'VarelaRound',fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(context, EnterPage(page: DetailTagihan(widget.idAppointment)));
                                    },)

                              )
                          )
                      ),
                    ),
                    Flexible(
                        child: Container(
                            color: HexColor("#efe6dd"),
                            height: double.infinity,
                            margin: const EdgeInsets.only(bottom: 1.0),
                            child: new FutureBuilder(
                                future: getDataChat2(),
                                builder: (context, snapshot) {
                                  return ListView.builder(
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      padding: new EdgeInsets.only(
                                          left: 15.0, right: 15.0, bottom: 60.0),
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
                                                              color : HexColor("#ffffff"),
                                                              boxShadow: [
                                                                //BoxShadow(color: Colors.white, spreadRadius: 1),
                                                              ],
                                                            ),
                                                            child :
                                                            data[i]["e"] != 'Message has been deleted..' ?
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
                                                                  onLongPress: (){
                                                                    //_doDeleteMessageImage(data[i]["i"].toString());
                                                                  },
                                                                )
                                                                    :
                                                                GestureDetector(
                                                                  child :
                                                                  Text(data[i]["e"],
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'VarelaRound',
                                                                      )),
                                                                  onLongPress: (){
                                                                    // _doDeleteMessage(data[i]["i"].toString());
                                                                  },
                                                                )
                                                            )
                                                                :
                                                            Padding (
                                                                padding: const EdgeInsets.all(10),
                                                                child :
                                                                Text(data[i]["e"],
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'VarelaRound',
                                                                        fontStyle: FontStyle.italic
                                                                    )))
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
                                                                    color : HexColor("#e2ffc7"),
                                                                    boxShadow: [
                                                                      // BoxShadow(color: Colors.white, spreadRadius: 1),
                                                                    ],
                                                                  ),
                                                                  child :
                                                                  data[i]["e"] != 'Message has been deleted..' ?
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
                                                                        onLongPress: (){

                                                                        },
                                                                      )
                                                                          :
                                                                      GestureDetector(
                                                                        child :
                                                                        Text(data[i]["e"],
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'VarelaRound',
                                                                            )),
                                                                        onLongPress: (){

                                                                        },
                                                                      )
                                                                  )
                                                                      :
                                                                  Padding (
                                                                      padding: const EdgeInsets.all(10),
                                                                      child :
                                                                      Text(data[i]["e"],
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'VarelaRound',
                                                                              fontStyle: FontStyle.italic
                                                                          )))
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


                  ])
          ),

        )
    );

  }



}

