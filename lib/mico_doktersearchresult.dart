import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/mico_detaildokter.dart';
import 'package:mico/mico_searchdokter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/mico_dokter.dart';
import 'package:mico/helper/PageRoute.dart';

class SearchResultDokter extends StatefulWidget {
  //HomePage({this.namaklinik});
  //final String namaklinik;
  final String namaklinik;
  final String valCari;
  const SearchResultDokter(this.namaklinik, this.valCari);
  @override
  _SearchResultDokterPageState createState() =>
      new _SearchResultDokterPageState(
          getKlinik: this.namaklinik, getValcari: this.valCari);
}

class _SearchResultDokterPageState extends State<SearchResultDokter> {
  List data;
  String getKlinik;
  String getValcari;
  String getFilter = '';
  Icon custIcon = Icon(Icons.search);
  String valq = "0";
  _SearchResultDokterPageState({this.getKlinik, this.getValcari});

  Future<List> getData() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_doktercari&id=" +
            getKlinik +
            "&cari=" +
            getValcari);
    setState((){
      data = json.decode(response.body);
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  Future<void> _getData() async {
    setState(() {
      getFilter = '';
      getData();
    });
  }



  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: Hexcolor("#075e55"),
              title: Text(
               getValcari.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VarelaRound',
                    fontSize: 16),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context)
                ),
              )
            ),

            body:
            Container(
                child :
                Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                     /* child: Divider(
                        height: 3,
                      ),*/
                    ),
                    Expanded(
                        child :
                        _datafield()
                    )
                  ],
                )
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
          RefreshIndicator(
              onRefresh: _getData,
              child :
              new ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) => Pembayaran(
                                        data[i]["f"],
                                        widget.namaklinik,
                                        data[i]["b"])));
                          },
                          child:
                          ListTile(
                            leading:
                            CachedNetworkImage(
                              imageUrl: "https://duakata-dev.com/miracle/media/photo/" +
                                  data[i]["e"],
                              imageBuilder: (context, image) =>
                                  GFIconBadge(
                                    child: CircleAvatar(
                                      backgroundImage: image,
                                      radius: 26,
                                    ),
                                  ),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            title:  Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                data[i]["b"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
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
                                                  style: new TextStyle(color: Hexcolor("#2ECC40"),fontWeight: FontWeight.bold, fontFamily:
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
                                        ]))

                              ],
                            ),
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 95, right: 15),
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
              ));
        }
      },
    );
  }



}

