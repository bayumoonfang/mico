import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/mico_cekappointment.dart';
import 'package:mico/konsultasi/page_detailimagedokter.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:responsive_container/responsive_container.dart';

class DetailDokter extends StatefulWidget {
  final String idDokter;
  final String getPhone;
  const DetailDokter(this.idDokter, this.getPhone);
  @override
  _DetailDokter createState() => new _DetailDokter();
}

class _DetailDokter extends State<DetailDokter> {
  bool _isvisible = true ;
  List data;
  String getChatStatus, getVideoStatus;



  String getPhoto, getNama, getRegional, getLokasi, getSRT;
  _getDetail() async {
    final response = await http.post(
       AppHelper().applink+"do=getdata_dokterdetail&id=" +
            widget.idDokter);
    Map data2 = jsonDecode(response.body);
    setState(() {
      getPhoto = data2["e"].toString();
      getNama = data2["b"].toString();
      getRegional = data2["g"].toString();
      getLokasi = data2["c"].toString();
      getSRT = data2["i"].toString();
      _isvisible = false;
    });

  }


  _sinkronall() async {
    await _getDetail();
  }


  @override
  void initState() {
    super.initState();
    _sinkronall();
  }



  Future<List> getDateJadwal() async {
    http.Response response = await http.get(
        Uri.encodeFull(AppHelper().applink+"do=getdata_jadwalhari&id=" +
            widget.idDokter),
        headers: {"Accept":"application/json"}
    );
    return json.decode(response.body);
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  int _selectedIndex = 200;
  int _isButtonDisabled = 1;
  int _isGetJadwal = 0;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  _onButton(int index) {
    setState(() => _isButtonDisabled = index);
  }

  _getDate(int index) {
    setState(() => _isGetJadwal = index);
  }


  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Detail Dokter",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'VarelaRound', fontSize: 16),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => {
                  Navigator.pop(context)
                  }),
            ),

          ),
          body:
              _isvisible == true ?
          Center(
                    child: CircularProgressIndicator()
                )
              :
              Padding(
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

            ResponsiveContainer(
              widthPercent: 100,
              heightPercent: 25,
              padding: const EdgeInsets.only(left: 10,right: 10),
              child:

              GestureDetector(
                child: Hero(
                  tag: getPhoto.toString(),
                  child :
                  getPhoto == '' ?
                  Image.asset('assets/mira-ico.png')
                      :
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "https://duakata-dev.com/miracle/media/photo/"+getPhoto,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => DetailImageDokter(getPhoto.toString())));
                },
              )
            )
               ,
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15.0, right: 15.0),
                      child: Divider(height: 3.0)),

                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getNama.toString(),
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getLokasi.toString(),
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 14),),
                    ),
                  ),


                  Padding(padding: const EdgeInsets.only(top: 30)),

                  Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 8, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Regional",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text(getRegional.toString(),
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      )),

                     Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 8, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Nomor SRT",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text(getSRT.toString(),
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 30, left: 10.0, right: 15.0),
                      child: Divider(height: 3.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: Text("Tanggal Available",
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5,bottom: 10),
                    child: Text("Dokter juga akan online pada jam berikut ",
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 14)),
                  ),
                  new FutureBuilder<List>(
                      future: getDateJadwal(),
                      builder: (context, snapshot) {
                        return Container(
                            height: 115,
                        padding: const EdgeInsets.only(right : 15),
                        child :
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          itemCount: snapshot.data == null ? 0 : snapshot.data.length ,
                          itemBuilder: (context, i) {
                                          return snapshot.data.isEmpty ?
                                                Container(
                                                    width: 160,
                                                    height: 200,
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child:
                                                    Text(
                                                      "Jadwal tidak ditemukan",
                                                      style: new TextStyle(
                                                          fontFamily: 'VarelaRound', fontSize: 20),
                                                    ))
                                           :
                                                Container(
                                                    width: 160,
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child:
                                                    snapshot.data[i]['g'] == 'ONLINE' ?
                                                    Card(
                                                      elevation: 0,
                                                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                                      shape: RoundedRectangleBorder(
                                                        side: new BorderSide(color:
                                                        _selectedIndex == i && _selectedIndex != 200 &&
                                                            _selectedIndex != null ?
                                                        HexColor("#075e55") : HexColor("#DDDDDD"), width: 1.0
                                                        ),
                                                        borderRadius: BorderRadius.circular(5.0),
                                                      ),
                                                      child:
                                                      InkWell(
                                                          splashColor: Colors.blue.withAlpha(30),
                                                          onTap: () {
                                                            _onSelected(i);
                                                            _onButton(2);
                                                            _getDate(snapshot.data[i]['i']);
                                                          },
                                                          child:
                                                          Container(
                                                            child: Center(child:
                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  child:
                                                                  Text(new DateFormat.EEEE().format(
                                                                      DateTime.parse(snapshot.data[i]['f'])), style: new TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'VarelaRound',
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 18
                                                                  ),),
                                                                  padding: const EdgeInsets.only(top: 15),
                                                                ),
                                                                Padding(
                                                                  child:
                                                                  Text("(" + snapshot.data[i]['d'] + " " +
                                                                      new DateFormat.MMM().format(
                                                                          DateTime.parse(snapshot.data[i]['f'])) + ")",
                                                                    style: new TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'VarelaRound',
                                                                    ),),
                                                                  padding: const EdgeInsets.only(top: 5),
                                                                ),
                                                                Padding(
                                                                  child:
                                                                  Text(snapshot.data[i]['e'],
                                                                    style: new TextStyle(
                                                                        color: Colors.black,
                                                                        fontFamily: 'VarelaRound',
                                                                        fontWeight: FontWeight.bold
                                                                    ),),
                                                                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                                                                )
                                                              ],
                                                            )

                                                            ),
                                                          )
                                                      ),
                                                    )

                                                        : snapshot.data[i]['g'] == 'BOOKED' ?
                                                    Opacity(
                                                        opacity: 0.3,
                                                        child:
                                                        Card(
                                                          color: Colors.green,
                                                          elevation: 0,
                                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                                          shape: RoundedRectangleBorder(
                                                            side: new BorderSide(color: Colors.green, width: 1.0),
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                          child:
                                                          Container(
                                                            child: Center(child:
                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  child:
                                                                  Text(new DateFormat.EEEE().format(
                                                                      DateTime.parse(snapshot.data[i]['f'])), style: new TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'VarelaRound',
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 18
                                                                  ),),
                                                                  padding: const EdgeInsets.only(top: 15),
                                                                ),
                                                                Padding(
                                                                  child:
                                                                  Text("(" + snapshot.data[i]['d'] + " " +
                                                                      new DateFormat.MMM().format(
                                                                          DateTime.parse(data[i]['f'])) + ")",
                                                                    style: new TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'VarelaRound',
                                                                    ),),
                                                                  padding: const EdgeInsets.only(top: 5),
                                                                ),
                                                                Padding(
                                                                  child:
                                                                  Text(snapshot.data[i]['e'],
                                                                    style: new TextStyle(
                                                                        color: Colors.black,
                                                                        fontFamily: 'VarelaRound',
                                                                        fontWeight: FontWeight.bold
                                                                    ),),
                                                                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                                                                )
                                                              ],
                                                            )

                                                            ),
                                                          ),
                                                        )
                                                    )
                                                        :
                                                    Opacity(
                                                        opacity: 0.3,
                                                        child:
                                                        Card(
                                                          color: Colors.grey,
                                                          elevation: 0,
                                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                                          shape: RoundedRectangleBorder(
                                                            side: new BorderSide(color: Colors.grey, width: 1.0),
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                          child:
                                                          Container(
                                                            child: Center(child:
                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  child:
                                                                  Text(new DateFormat.EEEE().format(
                                                                      DateTime.parse(snapshot.data[i]['f'])), style: new TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'VarelaRound',
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 18
                                                                  ),),
                                                                  padding: const EdgeInsets.only(top: 15),
                                                                ),
                                                                Padding(
                                                                  child:
                                                                  Text("(" + snapshot.data[i]['d'] + " " +
                                                                      new DateFormat.MMM().format(
                                                                          DateTime.parse(snapshot.data[i]['f'])) + ")",
                                                                    style: new TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'VarelaRound',
                                                                    ),),
                                                                  padding: const EdgeInsets.only(top: 5),
                                                                ),
                                                                Padding(
                                                                  child:
                                                                  Text(snapshot.data[i]['e'],
                                                                    style: new TextStyle(
                                                                        color: Colors.black,
                                                                        fontFamily: 'VarelaRound',
                                                                        fontWeight: FontWeight.bold
                                                                    ),),
                                                                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                                                                )
                                                              ],
                                                            )

                                                            ),
                                                          ),
                                                        )
                                                    )
                                                );

                                            },
                                         )
                                    );
                                  },
                          )
                ],
              )

              ),


          bottomSheet: new

          Container (
            color: Colors.white,
          child :
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 20.0, bottom:10),
                    child:
                    _isButtonDisabled == 1 ?
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        //side: BorderSide(color: Colors.red)
                      ),
                      child: Text(
                        "Buat Janji",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 14,
                        ),
                      ),
                    )
                  :

                    RaisedButton(
                      color:  HexColor("#075e55"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        //side: BorderSide(color: Colors.red, width: 2.0)
                      ),
                      child: Text(
                        "Buat Janji",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 14,
                          color: Colors.white
                        ),
                      ),
                      onPressed: () {
                      /*  Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => CekAppointment(_isGetJadwal.toString(),getAcc.toString(),getDokter,getNamaDokter, getKlinik)));*/
                      },
                    ),



                  ))

            ],
          )),
        ),
        onWillPop: _onWillPop);
  }
}
