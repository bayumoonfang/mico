import 'dart:io';
import 'package:badges/badges.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/page_home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mico/page_homenew.dart';
import 'package:mico/services/page_chatroom_detailtagihan.dart';
import 'package:mico/services/page_detailimagechat.dart';
import 'package:mico/user/mico_detailtagihan.dart';


class ChatroomDoctor extends StatefulWidget {
  final String idApp, getPhone, getRole;
  const ChatroomDoctor(this.idApp,this.getPhone,this.getRole);

  @override
  _ChatroomDoctor createState() => new _ChatroomDoctor();
}


class _ChatroomDoctor extends State<ChatroomDoctor> {
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
    Navigator.pop(context);
  }


  //==================HTTP GET DATA========================================================
  String getInvNumber, getNamaPasien = "...";
  String getStatusRoom = 'OPEN';
  _startingVariable() async {
    await AppHelper().getAppDetailWithInvoiced(widget.idApp.toString()).then((value){
      setState(() {
        getInvNumber = value[0];
        getNamaPasien = value[3];
        getStatusRoom = value[2];
      });});
  }

  Future<List> getDataChat2() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_chat2&"
            "id="+widget.idApp);
    return json.decode(response.body);
  }

  Future<List> getDataChat3() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_countchatfixed&"
            "id="+widget.idApp+"&role="+widget.getRole);
    return json.decode(response.body);
  }

//==========================================================================================






//========================HTTP POST DATA========================================================
  _addchat() async {
    if(_textController.text.isEmpty) {
      return;
    } else {
      final response = await http.post(
          AppHelper().applink+"do=addata_chat2",
          body: {
            "messagetext": _textController.text,
            "id": widget.idApp,
            "role" : widget.getRole
          });
      setState(() {
        _textController.clear();
        myFocusNode.requestFocus();
        //FocusScope.of(context).requestFocus(FocusNode());
        _isLoading = '0';
      });
    }
  }

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    String fileName = galleryFile.path.split('/').last;
    Base64 = base64Encode((galleryFile.readAsBytesSync()));
    http.post(AppHelper().applink+"do=addata_chatimage2", body: {
      "image": Base64,
      "name": fileName,
      "id": widget.idApp,
      "role": widget.getRole
    });
    print("You selected gallery image : " + Base64);
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent);
    });
  }


  void _dodeletepesan(String valID) {
    var url = AppHelper().applink+"do=action_deletechatuser";
    http.post(url,
        body: {
          "idmessage": valID
        });
    FocusScope.of(context).requestFocus(FocusNode());
  }


  void _dodeletepesanimage(String valID) {
    var url = AppHelper().applink+"do=action_deletechatimageuser";
    http.post(url,
        body: {
          "idmessage": valID
        });
    FocusScope.of(context).requestFocus(FocusNode());
  }


  void doAkhiri() {
    var url = AppHelper().applink+"do=action_akhirichat";
    http.post(url,
        body: {
          "idAppointment": widget.idApp
        });
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) =>
              PageHomeNew()));
    });
  }


  //=================================================================================================

  _doDeleteMessage(String IDMessage) {
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
                      fontSize: 14)))
            ],
          );
        });
  }




  _doDeleteMessageImage(String IDMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Text(
                "Apakah anda yakin untuk menghapus pesan ini  ?",
                style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14)),
            actions: [
              new FlatButton(
                  onPressed: () {
                    _dodeletepesanimage(IDMessage);
                    Navigator.pop(context);
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


  akhiriChat() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 185,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Konfirmasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.envelope,
                      color: Colors.redAccent,size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin mengakhiri konsultasi ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            doAkhiri();
                          }, child: Text("Iya", style: TextStyle(color :Colors.redAccent),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }

  void _removeread() async {
    var url = AppHelper().applink+"do=action_removeread";
    http.post(url,
        body: {
          "id": widget.idApp,
          "role" : widget.getRole
        });
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

  void _loaddata() async {
    await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    _loaddata();
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _startingVariable();
      });
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _removeread();
  }





  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child :
        Scaffold(
          appBar: new AppBar(
            //backgroundColor: HexColor("#075e55"),
            backgroundColor: Colors.white,
            title: new Text(getNamaPasien,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'VarelaRound', fontSize: 16)),
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.check),
                  color: Colors.black,
                  onPressed: () {
                    akhiriChat();
                  },
                ),
              ),
            ],
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
                              height: 40,
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
                                                  fontSize: 12,
                                                  color: HexColor("#516067"),
                                                  fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)),
                                        Padding(
                                            padding :  const EdgeInsets.only(right: 10),
                                            child :
                                            Text("Detail",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: HexColor("#516067"),
                                                  fontFamily: 'VarelaRound',fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) => ChatRoomDetailTagihan(getInvNumber)));
                                      FocusScope.of(context).requestFocus(FocusNode());
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
                                color : HexColor("#d4eaf5"),
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
                                      color: HexColor("#516067"),
                                      fontFamily: 'VarelaRound',)),
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
                                  if (snapshot.data == null) {
                                    return Center(
                                        child: CircularProgressIndicator()
                                    );
                                  } else {
                                    return ListView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        padding: new EdgeInsets.only(
                                            left: 15.0, right: 15.0, bottom: 60.0),
                                        reverse: false,
                                        itemCount:
                                        snapshot.data == null ? 0 : snapshot.data.length,
                                        itemBuilder: (context, i) {
                                          if (snapshot.data[i]["d"] == '2') {
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
                                                              snapshot.data[i]["e"] != 'Message has been deleted..' ?
                                                              Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child:
                                                                  snapshot.data[i]["h"] != '' && snapshot.data[i]["d"] == '1' ?
                                                                  GestureDetector(
                                                                    child: Hero(
                                                                        tag: snapshot.data[i]["h"],
                                                                        child :
                                                                        Image(
                                                                          image: NetworkImage(AppHelper().applinksource+"media/imgchat/"+ snapshot.data[i]["h"]),
                                                                          height: 160,
                                                                          width: 160,
                                                                        )),
                                                                    onTap: (){
                                                                      Navigator.of(context).push(
                                                                          new MaterialPageRoute(
                                                                              builder: (BuildContext context) => DetailScreen(snapshot.data[i]["h"].toString())));
                                                                    },
                                                                    onLongPress: (){
                                                                      //_doDeleteMessageImage(data[i]["i"].toString());
                                                                    },
                                                                  )
                                                                      :
                                                                  GestureDetector(
                                                                    child :
                                                                    Text(snapshot.data[i]["e"],
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
                                                                  Text(snapshot.data[i]["e"],
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
                                                        snapshot.data[i]["g"],
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
                                                                    snapshot.data[i]["e"] != 'Message has been deleted..' ?
                                                                    Padding(
                                                                        padding: const EdgeInsets.all(10.0),
                                                                        child:
                                                                        snapshot.data[i]["h"] != '' && snapshot.data[i]["d"] == '2' ?
                                                                        GestureDetector(
                                                                          child: Hero(
                                                                              tag: snapshot.data[i]["h"],
                                                                              child :
                                                                              Image(
                                                                                image: NetworkImage(AppHelper().applinksource+"media/imgchat/"+ snapshot.data[i]["h"]),
                                                                                height: 160,
                                                                                width: 160,
                                                                              )),
                                                                          onTap: (){
                                                                            Navigator.of(context).push(
                                                                                new MaterialPageRoute(
                                                                                    builder: (BuildContext context) => DetailScreen(snapshot.data[i]["h"].toString())));
                                                                          },
                                                                          onLongPress: (){
                                                                            _doDeleteMessageImage(snapshot.data[i]["i"].toString());
                                                                          },
                                                                        )
                                                                            :
                                                                        GestureDetector(
                                                                          child :
                                                                          Text(snapshot.data[i]["e"],
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: 'VarelaRound',
                                                                              )),
                                                                          onLongPress: (){
                                                                            _doDeleteMessage(snapshot.data[i]["i"].toString());
                                                                          },
                                                                        )
                                                                    )
                                                                        :
                                                                    Padding (
                                                                        padding: const EdgeInsets.all(10),
                                                                        child :
                                                                        Text(snapshot.data[i]["e"],
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
                                                              snapshot.data[i]["g"],
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
                                  }}
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
                            color: Colors.transparent,
                            height: 55,
                            width: 60,
                            child : new FutureBuilder(
                              future: getDataChat3(),
                              builder: (context, snapshot) {
                                return ListView.builder(
                                  itemCount: snapshot.data == null ? 0 : snapshot.data.length ,
                                  itemBuilder: (context, i) {
                                    return   Padding(
                                      padding: const EdgeInsets.only(right: 15, bottom: 15),
                                      child:
                                      SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child:

                                        snapshot.data[i]["a"] != 0 ?
                                        Badge(
                                          badgeContent: Text(snapshot.data[i]["a"].toString(), style: TextStyle(color: Colors.white),),
                                          animationType: null,
                                          toAnimate: false,
                                          child: FloatingActionButton(
                                            elevation: 1,
                                            backgroundColor: HexColor("#f8f7f5"),
                                            child:  Center(
                                              child: FaIcon(FontAwesomeIcons.angleDoubleDown, size: 18,color: HexColor("#727270"),),
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
                                          backgroundColor: HexColor("#f8f7f5"),
                                          child:  Center(
                                            child: FaIcon(FontAwesomeIcons.angleDoubleDown, size: 18,color: HexColor("#727270"),),
                                          ),onPressed: (){
                                          _scrollController
                                              .jumpTo(_scrollController.position.maxScrollExtent);
                                        },
                                        ),
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
                  ])
          ),

        )
    );

  }



  Widget _buildTextComposer() {
    return
      getStatusRoom == 'CLOSED' ?
      Opacity(
        opacity: 0.4,
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: new Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 15,bottom: 5,top:5),
                          child: TextField(
                            readOnly: true,
                            minLines: 1,
                            maxLines: 5,
                            controller: _textController,
                            focusNode: myFocusNode,
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
                                  )),
                              Opacity(
                                  opacity: 0.8,
                                  child :
                                  new IconButton(
                                      icon: new Icon(Icons.send))),
                            ])
                    ),
                  ],
                ))
          ],
        ),
      )

          :
      GestureDetector(
        child :
        Column(
          children: <Widget>[
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
                                        _scrollController
                                            .jumpTo(_scrollController.position.maxScrollExtent);
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
        },)


    ;
  }



}

