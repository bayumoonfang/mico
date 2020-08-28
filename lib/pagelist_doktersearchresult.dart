import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mico/page_home.dart';
import 'package:mico/page_pembayaran.dart';
import 'package:mico/page_searchdokter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/pagelist_dokter.dart';
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
            getValcari +
            "&filter=" +
            getFilter);
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
                    Container(
                      margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10),
                      height: 30.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                //side: BorderSide(color: Colors.red)
                              ),
                              child : Text("Semua", style: TextStyle(
                                  fontFamily: 'VarelaRound')),
                              onPressed: ()  async {
                                getFilter = '';
                                data.clear();
                                await _datafield();
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: OutlineButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  //side: BorderSide(color: Colors.red)
                                ),
                                child : Text("Online", style: TextStyle(
                                    fontFamily: 'VarelaRound')),
                                onPressed: ()  async {
                                  getFilter = 'Online';
                                  data.clear();
                                  const TIMEOUT = const Duration(seconds: 50);
                                  Future.delayed(TIMEOUT,() => getData());
                                }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                //side: BorderSide(color: Colors.red)
                              ),
                              child : Text("Offline", style: TextStyle(
                                  fontFamily: 'VarelaRound')),
                              onPressed: ()  async {
                                getFilter = 'Offline';
                                data.clear();
                                await _datafield();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                //side: BorderSide(color: Colors.red)
                              ),
                              child : Text("Reserved", style: TextStyle(
                                  fontFamily: 'VarelaRound')),
                              onPressed: ()  async {
                                getFilter = 'Reserved';
                                data.clear();
                                await _datafield();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Divider(
                        height: 3,
                      ),
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
                      data[i]['g'] == 'Online' ?
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => Pembayaran(
                                      data[i]["f"],
                                      widget.namaklinik,
                                      data[i]["b"])));
                        },
                        child: ListTile(
                            leading:
                            CachedNetworkImage(
                                imageUrl:
                                "https://duakata-dev.com/miracle/media/photo/" +
                                    data[i]["e"],
                                progressIndicatorBuilder: (context,
                                    url, downloadProgress) =>
                                    Image.asset(
                                      "assets/loadingq.gif",
                                      width: 85.0,
                                    ),
                                imageBuilder: (context, image) =>
                                    GFIconBadge(
                                        child: CircleAvatar(
                                          backgroundImage: image,
                                          radius: 26,
                                        ),
                                        counterChild: GFBadge(
                                          color:
                                          Hexcolor("#2ECC40"),
                                          size: 18,
                                          shape:
                                          GFBadgeShape.circle,
                                        )
                                    )
                            ),
                            title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    data[i]["b"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'VarelaRound'),
                                  ),
                            ),
                            subtitle: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            2.0)),
                                    Align(
                                      alignment:
                                      Alignment.bottomLeft,
                                      child: Text(
                                          data[i]["c"],
                                          style: TextStyle(
                                              fontFamily:
                                              'VarelaRound')),
                                    ),
                                  ],
                                ),
                            trailing: Text("ONLINE",style: TextStyle(fontSize: 10, fontFamily:
                            'VarelaRound', color: Colors.green, fontWeight: FontWeight.bold),)
                        ),
                      )
                          :
                      data[i]['g'] == 'Offline' ?
                      Opacity(
                          opacity : 0.6,
                          child :
                          InkWell(
                            onTap: () {},
                            child: ListTile(
                                leading: CachedNetworkImage(
                                    imageUrl:
                                    "https://duakata-dev.com/miracle/media/photo/" +
                                        data[i]["e"],
                                    progressIndicatorBuilder: (context,
                                        url, downloadProgress) =>
                                        Image.asset(
                                          "assets/loadingq.gif",
                                          width: 85.0,
                                        ),
                                    imageBuilder: (context, image) =>
                                        GFIconBadge(
                                            child: CircleAvatar(
                                              backgroundImage: image,
                                              radius: 26,
                                            ),
                                            counterChild: GFBadge(
                                              color:
                                              Colors.red,
                                              size: 18,
                                              shape:
                                              GFBadgeShape.circle,
                                            )
                                        )
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
                                                2.0)),
                                        Align(
                                          alignment:
                                          Alignment.bottomLeft,
                                          child: Text(
                                              data[i]["c"],
                                              style: TextStyle(
                                                  fontFamily:
                                                  'VarelaRound')),
                                        ),
                                      ],
                                    ),
                                trailing: Text("OFFLINE",style: TextStyle(fontSize: 10, fontFamily:
                                'VarelaRound',color: Colors.red,fontWeight: FontWeight.bold),)
                            ),
                          ))
                          :
                      ListTile(
                          leading: CachedNetworkImage(
                              imageUrl:
                              "https://duakata-dev.com/miracle/media/photo/" +
                                  data[i]["e"],
                              progressIndicatorBuilder: (context,
                                  url, downloadProgress) =>
                                  Image.asset(
                                    "assets/loadingq.gif",
                                    width: 85.0,
                                  ),
                              imageBuilder: (context, image) =>
                                  GFIconBadge(
                                      child: CircleAvatar(
                                        backgroundImage: image,
                                        radius: 26,
                                      ),
                                      counterChild: GFBadge(
                                        color:
                                        Colors.transparent,
                                        size: 18,
                                        shape:
                                        GFBadgeShape.circle,
                                      )
                                  )
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
                                          2.0)),
                                  Align(
                                    alignment:
                                    Alignment.bottomLeft,
                                    child: Text(
                                        data[i]["c"],
                                        style: TextStyle(
                                            fontFamily:
                                            'VarelaRound')),
                                  ),
                                ],
                              ),
                          trailing: Text("RESERVED",style: TextStyle(fontSize: 10, fontFamily:
                          'VarelaRound',color: Colors.black,fontWeight: FontWeight.bold),)
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

