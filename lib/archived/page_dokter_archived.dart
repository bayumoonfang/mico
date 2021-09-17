import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_home.dart';
import 'package:mico/archived/page_regional_archive.dart';
import 'package:mico/page_login.dart';
import 'package:mico/konsultasi/page_detaildokter.dart';
import 'package:mico/mico_searchdokter.dart';
import 'package:toast/toast.dart';



class ListDokter extends StatefulWidget {
  final String regional;
  final String getPhone;
  const ListDokter(this.regional, this.getPhone);
  @override
  _ListDokterState createState() => _ListDokterState();
}


class _ListDokterState extends State<ListDokter> {
  List data;
  Icon custIcon = Icon(Icons.search);
  String valq = "0";
  String getFilter = '';
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }




  @override
  void initState() {
    super.initState();
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
         Uri.encodeFull(AppHelper().applink+"do=getdata_dokter&id="+widget.regional+"&filter="+getFilter),
         headers: {"Accept":"application/json"}
     );
     return json.decode(response.body);
  }


  Future<void> _getData() async {
    setState(() {
      getFilter = '';
      getData();
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  void _addfavorite(String iddokter) {
    var url = AppHelper().applink+"do=action_addfavorite";
    http.post(url,
        body: {
          "iduser": widget.getPhone,
          "iddokter" : iddokter
        });
    setState(() {});
  }

  void _deletefavorite(String iddokter) {
    var url = AppHelper().applink+"do=action_deletefavorite";
    http.post(url,
        body: {
          "iduser": widget.getPhone,
          "iddokter" : iddokter
        });
    setState(() {});
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context, String stringme) {
    final snackBar = SnackBar(content: Text(stringme));
    _scaffoldKey.currentState.showSnackBar(snackBar); }


  void _filterMe() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content:
              Container(
                  height: 125,
                  child:
                  SingleChildScrollView(
                    child :
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              //filter = 'Semua';
                              Navigator.pop(context);
                            });
                          },
                          child: Align(alignment: Alignment.centerLeft,
                            child:    Text(
                              "Favorite",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 15),
                            ),),
                        ),
                        Padding(padding: const EdgeInsets.only(top:15,bottom: 15,left: 4,right: 4),
                          child: Divider(height: 5,),),

                        InkWell(
                          onTap: (){
                            setState(() {
                              //filter = 'Semua';
                              Navigator.pop(context);
                            });
                          },
                          child: Align(alignment: Alignment.centerLeft,
                            child:    Text(
                              "Abjad",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 15),
                            ),),
                        ),
                        Padding(padding: const EdgeInsets.only(top:15,bottom: 15,left: 4,right: 4),
                          child: Divider(height: 5,),),

                        InkWell(
                          onTap: (){
                            setState(() {
                              //filter = 'Semua';
                              Navigator.pop(context);
                            });
                          },
                          child: Align(alignment: Alignment.centerLeft,
                            child:    Text(
                              "Diskon",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 15),
                            ),),
                        ),
                        Padding(padding: const EdgeInsets.only(top:15,bottom: 15,left: 4,right: 4),
                          child: Divider(height: 5,),),

                      ],
                    ),
                  ))
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          key: _scaffoldKey,
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
                      child: Text(widget.regional,
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),

             /* actions: [
                Padding(padding: const EdgeInsets.only(top:0,right: 18), child:
                Builder(
                  builder: (context) => IconButton(
                      icon: new FaIcon(FontAwesomeIcons.sortAmountDown,size: 18,),
                      color: Colors.black,
                      onPressed: ()  {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _filterMe();
                      }
                  ),
                )),

              ],*/
            ),

            body:
            Container(
                child :
                    Column(
                        children: <Widget>[
                          Padding(padding: const EdgeInsets.only(left: 15,top: 10,
                              right: 15),
                              child: Container(
                                height: 42,
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  onChanged: (text) {
                                    setState(() {
                                      getFilter = text;
                                      //_isvisible = false;
                                      //startSCreen();
                                    });
                                  },
                                  style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                                  decoration: new InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    fillColor: HexColor("#f4f4f4"),
                                    filled: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Icon(Icons.search,size: 18,
                                        color: HexColor("#6c767f"),),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white,
                                        width: 1.0,),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: HexColor("#f4f4f4"),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: 'Cari Dokter...',
                                  ),
                                ),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),),
                                  Expanded(
                                    child :
                                            _datafield()
                                  ),
                          Padding(padding: const EdgeInsets.only(bottom:10),)
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
        if (snapshot.data == null) {
          return Center(
              child: CircularProgressIndicator()
          );
        } else {
          return snapshot.data.length == 0 ?
          Container(
              height: double.infinity, width : double.infinity,
              child: new
              Center(
                  child :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Mohon maaf",
                        style: new TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 22,fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: const EdgeInsets.only(left: 25,right:25,top: 10),
                      child: new Text(
                        "Saat ini tidak ada dokter yang sedang online, mohon mencoba beberapa saat lagi",
                        style: new TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 12,height: 1.5),textAlign: TextAlign.center,
                      ),)
                    ],
                  )))
              :
          RefreshIndicator(
              onRefresh: _getData,
              child :
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
                    ListTile(
                        leading:
                    CircleAvatar(
                          backgroundImage:
                          snapshot.data[i]["e"] == '' ? AssetImage("assets/mira-ico.png") :
                          CachedNetworkImageProvider("https://duakata-dev.com/miracle/media/photo/"+snapshot.data[i]["e"],
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
