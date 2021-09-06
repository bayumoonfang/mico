
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/konsultasi/page_detaildokter.dart';
import 'package:mico/page_home.dart';
import 'package:mico/mico_homesearchdetail.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:toast/toast.dart';


class Favorite extends StatefulWidget {
  final String getPhone ;
  const Favorite(this.getPhone);
  @override

  _FavoriteState createState() => new _FavoriteState();
}


class _FavoriteState extends State<Favorite> {
  List data;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(AppHelper().applink+"do=getdata_dokterfavorite&id="+widget.getPhone),
        headers: {"Accept":"application/json"}
    );
    return json.decode(response.body);
  }

  void _addfavorite(String iddokter) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_addfavorite";
    http.post(url,
        body: {
          "iduser": widget.getPhone,
          "iddokter" : iddokter
        });
    setState(() {    getData();});
  }

  void _deletefavorite(String iddokter) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_deletefavorite";
    http.post(url,
        body: {
          "iduser": widget.getPhone,
          "iddokter" : iddokter
        });
    setState(() {
      getData();
    });
  }


  @override
  void initState() {
    super.initState();
  }


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context, String stringme) {
    final snackBar = SnackBar(content: Text(stringme));
    _scaffoldKey.currentState.showSnackBar(snackBar); }


  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          key: _scaffoldKey,
          child: Scaffold(
            backgroundColor: Colors.white,
              appBar: new AppBar(
                backgroundColor: Colors.white,
                title: Text("Wishlist",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'VarelaRound',
                        fontSize: 16)),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              body:
              Container(
                  child :
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        /* child: Divider(
                              height: 3,
                            ),*/
                      ),
                      Expanded(
                          child :
                          _datafield()
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:10),
                      )
                    ],
                  )
              )

          ),
        );
  }





  Widget _datafield() {
    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
              child: CircularProgressIndicator()
          );
        } else {

          return snapshot.data.length == 0 ?
          Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Dokter tidak ditemukan",
                    style: new TextStyle(
                        fontFamily: 'VarelaRound', fontSize: 20),
                  ),
                  new Text(
                    "Silahkan coba beberapa saat lagi..",
                    style: new TextStyle(
                        fontFamily: 'VarelaRound', fontSize: 16),
                  ),
                ],
              ))
              :

          new ListView.builder(
            padding: const EdgeInsets.only(top: 10.0,bottom: 10),
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) => DetailDokter(
                                    snapshot.data[i]["a"].toString(),
                                    widget.getPhone)));
                      },
                      child:
                     Opacity(
                       opacity: snapshot.data[i]["g"] != 'Online' ? 0.5 : 1,
                       child:  ListTile(
                           leading:
                           CircleAvatar(
                             backgroundImage:
                             snapshot.data[i]["e"] == '' ? AssetImage("assets/mira-ico.png") :
                             CachedNetworkImageProvider(AppHelper().applinksource+"media/photo/"+snapshot.data[i]["e"],
                             ),
                             backgroundColor: Colors.white,
                             radius: 28,
                           ),
                           title:  Align(
                             alignment: Alignment.centerLeft,
                             child: Text(
                               snapshot.data[i]["b"],
                               style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: 'VarelaRound'),
                             ),
                           ),
                           subtitle:  Column(
                               children: <Widget>[
                                 Padding(
                                     padding: const EdgeInsets.all(3.0)
                                 ),
                                 Align(
                                   alignment: Alignment.bottomLeft,
                                   child: Text(
                                       snapshot.data[i]["c"],
                                       style: TextStyle(
                                           fontFamily:
                                           'VarelaRound', fontSize: 12)),
                                 ),
                                 Padding(
                                     padding: const EdgeInsets.only(top:5),
                                     child :

                                     snapshot.data[i]["j"] == 100 ?
                                     Row(
                                         children: [
                                           Text("Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                               snapshot.data[i]["i"]),style: new TextStyle(decoration: TextDecoration.lineThrough,fontFamily:
                                           'VarelaRound',fontSize: 12),),
                                           Padding(padding: const EdgeInsets.only(left:10), child : Text("FREE",
                                               style: new TextStyle(color: HexColor("#2ECC40"),fontFamily:
                                               'VarelaRound',fontSize: 12,fontWeight: FontWeight.bold)))
                                         ])

                                         : (snapshot.data[i]["j"] != 100 && snapshot.data[i]["j"] != 0 ) ?

                                     Row(children: [
                                       Text("Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                           snapshot.data[i]["i"]),style: new TextStyle(decoration: TextDecoration.lineThrough,
                                           fontFamily:'VarelaRound',fontSize: 13),),
                                       Padding(
                                           padding: const EdgeInsets.only(left:10),child :Text( "Rp "+
                                           NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                               snapshot.data[i]["i"] - double.parse(snapshot.data[i]["k"])), style: new TextStyle(color:
                                       Colors.black,fontFamily: 'VarelaRound',fontSize: 12),)),
                                     ])

                                         :

                                     Row(
                                         children: [ Text( "Rp "+
                                             NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                                 snapshot.data[i]["i"]), style: new TextStyle(color: Colors.black,
                                             fontFamily: 'VarelaRound',fontSize: 12),),
                                         ]))
                               ]),
                           trailing:
                           Builder(
                             builder: (context) => IconButton(
                                 icon: snapshot.data[i]["l"] == widget.getPhone ?
                                 new Icon(Icons.favorite,color: Colors.red,) :
                                 new Icon(Icons.favorite_border_outlined),
                                 color: Colors.black,
                                 onPressed: () {
                                   snapshot.data[i]["l"] == widget.getPhone ?
                                   _deletefavorite(snapshot.data[i]["a"].toString())
                                       :
                                   _addfavorite(snapshot.data[i]["a"].toString());
                                   _displaySnackBar(context, "Favorite berhasil dirubah");
                                 }
                               //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => DokterSearch())),
                             ),
                           )
                       ),
                     )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 95, right: 15,bottom: 10,top: 10),
                      child: Divider(
                        height: 3.0,
                      )),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 2, bottom: 5),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }


}