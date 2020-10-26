import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/mico_regional.dart';
import 'package:mico/page_login.dart';
import 'package:mico/mico_detaildokter.dart';
import 'package:mico/mico_searchdokter.dart';
import 'package:toast/toast.dart';



class ListDokter extends StatefulWidget {
  final String namaklinik;
  const ListDokter(this.namaklinik);
  @override
  _ListDokterState createState() =>
      new _ListDokterState(getKlinik: this.namaklinik);
}


class _ListDokterState extends State<ListDokter> {
  List data;
  String getKlinik;
  _ListDokterState({this.getKlinik});
  Icon custIcon = Icon(Icons.search);
  String valq = "0";
  String getFilter = '';
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();

    String getPhone = "...";
  _session() async {
    getPhone = await Session.getPhone();
    int value = await Session.getValue();
    if (value != 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }


  @override
  void initState() {
    super.initState();
   _session();
   getData();
    _focus.addListener(_onFocusChange);
  }

  FocusNode _focus = new FocusNode();
  TextEditingController _controller = new TextEditingController();



  void _onFocusChange(){
    debugPrint("Focus: "+_focus.hasFocus.toString());
  }



  Future<List> getData() async {
     http.Response response = await http.get(
         Uri.encodeFull("https://duakata-dev.com/miracle/api_script.php?do=getdata_dokter&id="+widget.namaklinik),
         headers: {"Accept":"application/json"}
     );
     setState((){
       data = json.decode(response.body);
     });
  }


  Future<void> _getData() async {
    setState(() {
      getFilter = '';
      getData();
    });
  }


  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: Regional()));
  }

  void _addfavorite(String iddokter) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_addfavorite";
    http.post(url,
        body: {
          "iduser": getPhone,
          "iddokter" : iddokter
        });
    showToast("Favorite berhasil ditambahkan", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    return;
  }

  void _deletefavorite(String iddokter) {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_deletefavorite";
    http.post(url,
        body: {
          "iduser": getPhone,
          "iddokter" : iddokter
        });
    showToast("Favorite berhasil dihapus", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              title: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child:     Opacity(
                        opacity: 0.6,
                        child: Text(
                          "Regional",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'VarelaRound',
                              fontSize: 12),
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:2),
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.namaklinik,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'VarelaRound',
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => Navigator.push(context, ExitPage(page: Regional())),
                ),
              ),
            ),

            body:
            Container(
                child :
                    Column(
                        children: <Widget>[
                    Container(
                    margin: const EdgeInsets.only(left: 13,right: 15,top: 10),
                    height: 45.0,
                         child :
                             GestureDetector(
                               onTap: () {
                                 Navigator.push(context, ExitPage(page: DokterSearch(widget.namaklinik)));
                               },
                               child :
                         Image(image: AssetImage("assets/cardokter.jpg"))
                             )


                    ),
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

          RefreshIndicator(
            onRefresh: _getData,
          child :
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
                              builder: (BuildContext context) => Pembayaran(
                                  data[i]["f"],
                                  widget.namaklinik,
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

              data[i]["l"] == getPhone ?
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
          ));
        }
      },
    );
  }



}
