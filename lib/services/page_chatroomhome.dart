import 'dart:io';

import 'package:badges/badges.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/page_login.dart';
import 'package:mico/services/page_detailimagechat.dart';
import 'package:mico/user/page_detailhistorytransaksi.dart';
import 'package:toast/toast.dart';
import 'package:photo_view/photo_view.dart';


class Chatroomhome extends StatefulWidget {
  final String MyPhone,Pageid;
  const Chatroomhome(this.MyPhone, this.Pageid);

  @override
  _ChatroomhomeState createState() => new _ChatroomhomeState(
      getPhoneState: this.MyPhone);
}

class _ChatroomhomeState extends State<Chatroomhome> {
  List data, data2;

  String getPhoneState, getBasedLogin;
  String getNamaDokter = '';
  String getIDDokter, getRoomChat, getRoomStatus, getInvNumber = '';
  File galleryFile;
  String Base64;
  String _isLoading = '0';
  bool _isVisible = false;

  _ChatroomhomeState({this.getPhoneState});
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController;
  FocusNode myFocusNode;


  Future<List> getDataChat2() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_chat2&"
            "idclient="+widget.MyPhone);
    setState((){
      data = json.decode(response.body);

    });
  }


  Future<List> getDataChat3() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countchatfixed&"
            "idclient="+widget.MyPhone);
    setState((){
      data2 = json.decode(response.body);

    });
  }


  void _getChatDetail() async {
    await _session();
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_chatdetail&id="+getPhoneState);
    Map dataq = jsonDecode(response.body);
    setState(() {
      getNamaDokter = dataq["nama"].toString();
      getIDDokter = dataq["iddokter"].toString();
      getRoomChat = dataq["roomchat"].toString();
      getRoomStatus = dataq["roomstatus"].toString();
      getInvNumber = dataq["invnumber"].toString();
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


  void _goScroll() {
    _scrollController
        .jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _connect();
    _session();
    _getChatDetail();

  }

  _scrollListener() {

    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        //bottom
        _isVisible = false;
        _removeread();
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


  void _removeread() async {
      var url = "https://duakata-dev.com/miracle/api_script.php?do=action_removeread";
      http.post(url,
          body: {
            "idclient": getPhoneState,
            "iddokter":getIDDokter,
            "room":getRoomChat
          });
  }


  void _addchat() async {
    if(_textController.text.isEmpty) {
      //showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else {
     final response = await http.post(
          "https://duakata-dev.com/miracle/api_script.php?do=addata_chat",
          body: { "messagetext": _textController.text,
            "idclient": getPhoneState,
            "iddokter":getIDDokter,
            "room":getRoomChat});
      Map dataq = jsonDecode(response.body);
      setState(() {
        _textController.clear();
          myFocusNode.requestFocus();
        _isLoading = '0';
        //_howloading();
      });
    }
  }

  Future<bool> _onWillPop() async {

    widget.Pageid == '1' ?
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
            builder: (BuildContext context) => Home()))
        :
    Navigator.pop(context);
    //Navigator.push(context, ExitPage(page: Home()));
  }


  void _dodeletepesan(String valID) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_deletechatuser";
    http.post(url,
        body: {
          "idmessage": valID
        });
    print(valID);
  }



  void _doDeleteMessage(String IDMessage) {
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
                    _dodeletepesan(IDMessage);
                    Navigator.pop(context);
                    myFocusNode.dispose();
                  },
                  child:
                  Text("Iya", style: TextStyle(fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18))),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                  Text("Tidak", style: TextStyle(fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18)))
            ],
          );
        });
  }



  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    String fileName = galleryFile.path.split('/').last;
    Base64 = base64Encode((galleryFile.readAsBytesSync()));
    http.post("https://duakata-dev.com/miracle/api_script.php?do=addata_chatimage", body: {
      "image": Base64,
      "name": fileName,
      "idclient": widget.MyPhone,
      "iddokter":getIDDokter,
      "room":getRoomChat
    });
    print("You selected gallery image : " + Base64);
    setState(() {
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent);
      //FocusScope.of(context).requestFocus(myFocusNode);
    });
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
            title: new Text(getNamaDokter,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16)),
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  widget.Pageid == '1' ?
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => Home()))
                      :
                  Navigator.pop(context);
                  //Navigator.push(context, ExitPage(page: Home()));
                },
              ),
            ),
             actions: [
               /*
               Padding(
                 padding : const  EdgeInsets.only(right : 20.0),
           child :
           DropdownButtonHideUnderline(
               child:
                        DropdownButton(
                          icon: FaIcon(FontAwesomeIcons.ellipsisV,size: 19,color: Colors.white,),
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text("Report", style: TextStyle(color: Hexcolor("#075e55"), fontFamily: 'VarelaRound', fontSize: 16),),
                              value: 1,
                            ),
                          ],
                          onChanged: (value) {
                               setState(() {
                                      _value = value;
                                   });
                               },
                        )
                     )
               )*/
             ],

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
                                                          _doDeleteMessage(data[i]["i"].toString());
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

Visibility(
  visible: _isVisible,
  maintainSize: true,
  maintainAnimation: true,
  maintainState: true,
  child: Align(
    alignment: Alignment.bottomRight,
    child : Container(
        height: 55,
        width: 60,
        child : new FutureBuilder(
          future: getDataChat3(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: data2 == null ? 0 : data2.length ,
              itemBuilder: (context, i) {
                return   Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child:
                  Container(
                      child :
                      SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child:

                          data2[i]["a"] != 0 ?
                          Badge(
                            badgeContent: Text(data2[i]["a"].toString(), style: TextStyle(color: Colors.white),),
                            animationType: null,
                            toAnimate: false,
                            child: FloatingActionButton(
                              elevation: 1,
                                backgroundColor: Hexcolor("#f8f7f5"),
                                child:  Center(
                                  child: FaIcon(FontAwesomeIcons.angleDoubleDown, size: 18,color: Hexcolor("#727270"),),
                                ),onPressed: (){
                                _removeread();
                              _scrollController
                                  .jumpTo(_scrollController.position.maxScrollExtent);
                            },
                            ),
                          )
                              :
                          FloatingActionButton(
                            elevation: 1,
                            backgroundColor: Hexcolor("#f8f7f5"),
                            child:  Center(
                              child: FaIcon(FontAwesomeIcons.angleDoubleDown, size: 18,color: Hexcolor("#727270"),),
                            ),onPressed: (){
                            _scrollController
                                .jumpTo(_scrollController.position.maxScrollExtent);
                          },
                          ),
                      )
                  )
                  ,
                );
              },
            );
          },
        )
    ),
  ),
),



                _buildTextComposer()
              ],
            ),
          ),

          ),
    );
  }



  Widget _buildTextComposer() {
    return new
    GestureDetector(
    child :
    Column(
      children: <Widget>[
       // _howloading(),
    Container(
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

             Flexible(
              child: Padding(
                  padding: const EdgeInsets.only(left: 15,bottom: 5,top:5),
                  child: TextField(
                    onTap: () {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    },
                    minLines: 1,
                    maxLines: 5,
                    controller: _textController,
                    focusNode: myFocusNode,
                    //onSubmitted: _handleSubmitted,
                    // onChanged: _handleChanged,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'VarelaRound',
                    ),
                    decoration: new InputDecoration.collapsed(
                      hintText: 'Tulis Pesan..',
                    ),
                  )),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child:
                Row (
                    children: <Widget>[
                      Opacity(
                        opacity: 0.8,
                      child :
                      new IconButton(
                          icon: new FaIcon(FontAwesomeIcons.image),
                          onPressed:
                          imageSelectorGallery
                        // _roomchat();
                      )),
                Opacity(
                    opacity: 0.8,
                    child :
                      new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: () {
                            _isLoading = '1';
                            _addchat();
                            /*_scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                            );*/
                            _scrollController
                                .jumpTo(_scrollController.position.maxScrollExtent);
                            // _roomchat();
                          })),
                    ])
            ),
          ],
        ))
      ],
    ),
    onTap: (){
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent);
    },);
  }

  }



