import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_cekappointment.dart';
import 'package:mico/page_detailimagedokter.dart';
import 'package:mico/page_login.dart';
import 'package:mico/pagelist_dokter.dart';
import 'package:http/http.dart' as http;
import 'package:mico/services/page_chatroom.dart';
import 'package:mico/services/page_chatroomprepare.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class Pembayaran extends StatefulWidget {
  final String iddokter;
  final String namaKlinik, namaDokter;



  const Pembayaran(this.iddokter, this.namaKlinik, this.namaDokter);
  @override
  _PembayaranState createState() => new _PembayaranState(
      getDokter: this.iddokter,
      getKlinik: this.namaKlinik,
      getNamaDokter: this.namaDokter);
}

class _PembayaranState extends State<Pembayaran> {
  String getKlinik;
  String getDokter, getNamaDokter, getAcc;
  bool _isvisible = true ;


  _PembayaranState({this.getDokter, this.getKlinik, this.getNamaDokter});
  List data;
  String getChatStatus, getVideoStatus;

  _session() async {
    int value = await Session.getValue();
    getAcc = await Session.getPhone();
    if (value != 1) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }

  String getPhoto, getNama, getRegional, getLokasi, getSRT;
  _getDetail() async {
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_dokterdetail&id=" +
            getDokter);
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
    await _session();
    await _getDetail();
  }


  @override
  void initState() {
    super.initState();
    _sinkronall();
  }



  Future<List> getDateJadwal() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_jadwalhari&id=" +
            getDokter);
    if (response.body.isNotEmpty) {
      data =  json.decode(response.body);
    } else {
      //Widget.of(context).showSnackBar(SnackBar(content: Text('Empty Data')));
    }
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
            backgroundColor: Hexcolor("#075e55"),
            title: Text(
              "Detail Dokter",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => {
                  Navigator.pop(context)
                  }),
            ),
          ),
          body:
              _isvisible == true ?
          Center(
                    child: Image.asset(
                    "assets/loadingq.gif",
                      width: 180.0,
                    )
                )
              :
              Padding(
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                      child:
              GestureDetector(
                  child: Hero(
                  tag: getPhoto.toString(),
                  child :
                      CachedNetworkImage(
                        imageUrl:
                        "http://duakata-dev.com/miracle/media/photo/" +
                            getPhoto.toString(),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                        imageBuilder: (context, image) =>
                            CircleAvatar(
                              backgroundImage: image,
                              radius: 60,
                            ),
                      )
                   ),
                onTap: (){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => DetailImageDokter(getPhoto.toString())));
                },
              )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15.0, right: 15.0),
                      child: Divider(height: 3.0)),
                  Padding(padding: const EdgeInsets.only(top: 30)),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Nama",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text(getNama.toString(),
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15),
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
                          left: 15, top: 8, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Lokasi Praktik",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text(getLokasi.toString(),
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      )),
                     Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15),
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
                          top: 30, left: 15.0, right: 15.0),
                      child: Divider(height: 3.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 40),
                    child: Text("Tanggal Konsultasi",
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5,bottom: 10),
                    child: Text("Pilih tanggal dan jam konsultasi ",
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
                          itemCount: data == null ? 0 : data.length ,
                          itemBuilder: (context, i) {
                            return (data.isEmpty || data == null) ?
                                Center (
                                  child :
                                   Text(
                                      "Jadwal tidak ditemukan",
                                      style: new TextStyle(
                                          fontFamily: 'VarelaRound', fontSize: 20),
                                    ))

                                :
                                  Container(
                                   width: 160,
                                   padding: const EdgeInsets.only(right:10),
                                   child:
                                   data[i]['g'] == 'ONLINE' ?
                                   Card(
                                     elevation:0,
                                     margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                     shape: RoundedRectangleBorder(
                                       side: new BorderSide(color:
                                           _selectedIndex == i && _selectedIndex != 200  && _selectedIndex != null ?
                                           Hexcolor("#075e55") : Hexcolor("#DDDDDD"), width: 1.0
                                       ),
                                       borderRadius: BorderRadius.circular(5.0),
                                     ),
                                     child:
                                     InkWell(
                                         splashColor: Colors.blue.withAlpha(30),
                                         onTap: () {
                                           _onSelected(i);
                                           _onButton(2);
                                           _getDate(data[i]['i']);

                                         },
                                         child :
                                     Container(
                                       child: Center(child:
                                       Column(
                                         children: [
                                           Padding (
                                           child :
                                           Text(new DateFormat.EEEE().format(DateTime.parse(data[i]['f'])), style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'VarelaRound',
                                             fontWeight: FontWeight.bold,
                                             fontSize: 18
                                             ),),
                                             padding: const EdgeInsets.only(top : 15),
                                           ),
                                           Padding (
                                             child :
                                             Text("("+data[i]['d'] + " " +new DateFormat.MMM().format(DateTime.parse(data[i]['f']))+")",
                                                 style: new TextStyle(
                                                 color: Colors.black,
                                                 fontFamily: 'VarelaRound',
                                             ),),
                                             padding: const EdgeInsets.only(top : 5),
                                           ),
                                           Padding (
                                             child :
                                             Text(data[i]['e'],
                                               style: new TextStyle(
                                                   color: Colors.black,
                                                   fontFamily: 'VarelaRound',
                                                   fontWeight: FontWeight.bold
                                               ),),
                                             padding: const EdgeInsets.only(top : 5,bottom: 10),
                                           )
                                         ],
                                       )

                                       ),
                                     )
                                   ),
                                   )

                            : data[i]['g'] == 'BOOKED' ?
                               Opacity (
                                 opacity: 0.3,
                                  child :
                                   Card(
                                     color: Colors.green,
                                     elevation:0,
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
                                               Padding (
                                                 child :
                                                 Text(new DateFormat.EEEE().format(DateTime.parse(data[i]['f'])), style: new TextStyle(
                                                     color: Colors.black,
                                                     fontFamily: 'VarelaRound',
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 18
                                                 ),),
                                                 padding: const EdgeInsets.only(top : 15),
                                               ),
                                               Padding (
                                                 child :
                                                 Text("("+data[i]['d'] + " " +new DateFormat.MMM().format(DateTime.parse(data[i]['f']))+")",
                                                   style: new TextStyle(
                                                     color: Colors.black,
                                                     fontFamily: 'VarelaRound',
                                                   ),),
                                                 padding: const EdgeInsets.only(top : 5),
                                               ),
                                               Padding (
                                                 child :
                                                 Text(data[i]['e'],
                                                   style: new TextStyle(
                                                       color: Colors.black,
                                                       fontFamily: 'VarelaRound',
                                                       fontWeight: FontWeight.bold
                                                   ),),
                                                 padding: const EdgeInsets.only(top : 5,bottom: 10),
                                               )
                                             ],
                                           )

                                           ),
                                         ),
                                   )
                                       )
                                  :
                                   Opacity (
                                       opacity: 0.3,
                                       child :
                                       Card(
                                         color: Colors.grey,
                                         elevation:0,
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
                                               Padding (
                                                 child :
                                                 Text(new DateFormat.EEEE().format(DateTime.parse(data[i]['f'])), style: new TextStyle(
                                                     color: Colors.black,
                                                     fontFamily: 'VarelaRound',
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 18
                                                 ),),
                                                 padding: const EdgeInsets.only(top : 15),
                                               ),
                                               Padding (
                                                 child :
                                                 Text("("+data[i]['d'] + " " +new DateFormat.MMM().format(DateTime.parse(data[i]['f']))+")",
                                                   style: new TextStyle(
                                                     color: Colors.black,
                                                     fontFamily: 'VarelaRound',
                                                   ),),
                                                 padding: const EdgeInsets.only(top : 5),
                                               ),
                                               Padding (
                                                 child :
                                                 Text(data[i]['e'],
                                                   style: new TextStyle(
                                                       color: Colors.black,
                                                       fontFamily: 'VarelaRound',
                                                       fontWeight: FontWeight.bold
                                                   ),),
                                                 padding: const EdgeInsets.only(top : 5,bottom: 10),
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
                      color:  Hexcolor("#075e55"),
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
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => CekAppointment(_isGetJadwal.toString(),getAcc.toString(),getDokter,getNamaDokter, getKlinik)));
                      },
                    ),



                  ))

            ],
          )),
        ),
        onWillPop: _onWillPop);
  }
}
