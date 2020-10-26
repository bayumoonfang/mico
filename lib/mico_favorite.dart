
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/mico_detaildokter.dart';
import 'package:mico/mico_home.dart';
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
    Navigator.pushReplacement(context, EnterPage(page: Home()));
  }


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://duakata-dev.com/miracle/api_script.php?do=getdata_dokterfavorite&id="+widget.getPhone),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  void _addfavorite(String iddokter) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_addfavorite";
    http.post(url,
        body: {
          "iduser": widget.getPhone,
          "iddokter" : iddokter
        });
    showToast("Favorite berhasil ditambahkan", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    return;
  }

  void _deletefavorite(String iddokter) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_deletefavorite";
    http.post(url,
        body: {
          "iduser": widget.getPhone,
          "iddokter" : iddokter
        });
    showToast("Favorite berhasil dihapus", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    return;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.white,
              appBar: new AppBar(
                backgroundColor: Colors.white,
                title: Text("Favorite",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'VarelaRound',
                        fontSize: 16)),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () => Navigator.push(context, EnterPage(page: Home())),
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
        if (data == null) {
          return Center(
              child: Image.asset(
                "assets/loadingq.gif",
                width: 110.0,
              )
          );
        } else {

          return data.isEmpty ?
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
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) => DetailDokterHome(
                                        data[i]["f"],
                                        data[i]["b"])));
                          },
                          child:
                          ListTile(
                              leading:

                              CircleAvatar(

                                backgroundImage:
                                data[i]["e"] == '' ? AssetImage("assets/mira-ico.png") :
                                CachedNetworkImageProvider("https://duakata-dev.com/miracle/media/photo/"+data[i]["e"],
                                ),
                                backgroundColor: Colors.white,
                                radius: 28,
                              ),
                              title:  Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data[i]["b"],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'VarelaRound'),
                                ),
                              ),
                              subtitle:  Column(
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            2.0)
                                    ),
                                    Align(
                                      alignment:
                                      Alignment.bottomLeft,
                                      child: Text(
                                          data[i]["c"],
                                          style: TextStyle(
                                              fontFamily:
                                              'VarelaRound')),
                                    ),
                                    data[i]["j"] == 100 ?
                                    Padding(
                                        padding: const EdgeInsets.only(top:5),
                                        child :
                                        Row(
                                            children: [
                                              Text("Rp "+
                                                  NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"]),
                                                style: new TextStyle(decoration: TextDecoration.lineThrough,fontFamily:
                                                'VarelaRound'),),
                                              Padding(
                                                  padding: const EdgeInsets.only(left:10),
                                                  child :
                                                  Text("FREE",
                                                      style: new TextStyle(color: HexColor("#2ECC40"),fontWeight: FontWeight.bold, fontFamily:
                                                      'VarelaRound',)))
                                            ])
                                    )

                                        : (data[i]["j"] != 100 && data[i]["j"] != 0 ) ?
                                    Padding(
                                        padding: const EdgeInsets.only(top:5),
                                        child :
                                        Row(
                                            children: [
                                              Text("Rp "+
                                                  NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"]),
                                                style: new TextStyle(decoration: TextDecoration.lineThrough, fontFamily:
                                                'VarelaRound'),),
                                              Padding(
                                                  padding: const EdgeInsets.only(left:10),
                                                  child :
                                                  Text( "Rp "+
                                                      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"] - data[i]["j"]),
                                                    style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily:
                                                    'VarelaRound'),)),
                                            ]))
                                        :
                                    Padding(
                                        padding: const EdgeInsets.only(top:5),
                                        child :
                                        Row(
                                            children: [
                                              Text( "Rp "+
                                                  NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"]),
                                                style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily:
                                                'VarelaRound'),),
                                            ])
                                    ),


                                  ]),
                              trailing:

                              data[i]["l"] == widget.getPhone ?
                              Builder(
                                builder: (context) => IconButton(
                                    icon: new Icon(Icons.favorite,color: Colors.red,),
                                    color: Colors.black,
                                    onPressed: () {
                                      _deletefavorite(data[i]["a"].toString());
                                    }
                                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => DokterSearch())),
                                ),
                              )
                                  :
                              Builder(
                                builder: (context) => IconButton(
                                    icon: new Icon(Icons.favorite_border_outlined),
                                    color: Colors.black,
                                    onPressed: () {
                                      _addfavorite(data[i]["a"].toString());
                                    }
                                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => DokterSearch())),
                                ),
                              )


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