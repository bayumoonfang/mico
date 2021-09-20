import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/konsultasi/page_checkout.dart';
import 'package:mico/mico_cekappointment.dart';
import 'package:mico/konsultasi/page_detailimagedokter.dart';
import 'package:mico/archived/page_checkout_archived.dart';
import 'package:mico/konsultasi/page_pembayaran.dart';
import 'package:mico/page_login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';

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



  String getPhoto, getNama, getRegional, getLokasi, getSRT, getSpesialis;
  String getStatus = '';
  String getAccnum = "...";
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
          getStatus = data2["j"].toString();
          getAccnum = data2["f"].toString();
          getSpesialis = data2["o"].toString();
          _isvisible = false;
        });
  }


  _sinkronall() async {
    await _getDetail();
  }
  showFlushBar(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 5),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);


  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String getMessage = "...";
  _cekAvaible() async {
    final response = await http.post(
        AppHelper().applink+"do=cek_avaible",
        body: {"phone": widget.getPhone.toString(), "iddokter": widget.idDokter});
    Map showdata = jsonDecode(response.body);
    setState(() {
      if (showdata["message"].toString() == '1') {
        showFlushBar(context, "Mohon maaf, dokter sedang tidak online");
        return;
      } else if (showdata["message"].toString() == '2') {
        showFlushBar(context, "Anda masih mempunyai konsultasi berjalan, mohon selesaikan dahulu konsultasi anda");
        return;
      } else if (showdata["message"].toString() == '3') {
        showFlushBar(context, "Anda masih mempunyai tagihan yang belum dibayar, silahkan selesaikan tagihan anda atau batalkan tagihan anda");
        return;
      } else {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (BuildContext context) => Checkout(
            widget.idDokter,
            getAccnum.toString(),
            widget.getPhone)));
      }
    });


  }



  Timer mytimer;
  @override
  void initState() {
    super.initState();
    _sinkronall();
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _getDetail();
      });
    });
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




  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 1,
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
                    imageUrl: AppHelper().applinksource+"media/photo/"+getPhoto,
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

                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("NO STR : "+getSRT.toString(),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child : Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: HexColor("#DDDDDD"),
                                      width: 1,
                                    ),)),
                              child: Column(
                                children: [
                                  Text("Regional",style: GoogleFonts.varelaRound(fontSize: 12),),
                                  Padding(padding: const EdgeInsets.only(top: 5),
                                      child: Text(getRegional.toString(),style: GoogleFonts.varelaRound(fontWeight: FontWeight.bold,fontSize: 16),))
                                ],
                              ),
                            )),
                        Expanded(
                            child : Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: HexColor("#DDDDDD"),
                                      width: 1,
                                    ),)),
                              child: Column(
                                children: [
                                  Text("Status",style: GoogleFonts.varelaRound(fontSize: 12),),
                                  Padding(padding: const EdgeInsets.only(top: 5),
                                      child: Text(getStatus.toString(),style: GoogleFonts.varelaRound(fontWeight: FontWeight.bold,fontSize: 16),))
                                ],
                              ),
                            )),

                        Expanded(
                            child : Container(
                              child: Column(
                                children: [
                                  Text("Spesialis",style: GoogleFonts.varelaRound(fontSize: 12),),
                                  Padding(padding: const EdgeInsets.only(top: 5),
                                    child: Text(getSpesialis.toString(),style: GoogleFonts.varelaRound(fontWeight: FontWeight.bold,fontSize: 16),))
                                ],
                              ),
                            )),

                      ],
                    ),
                  ),






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
                      if (snapshot.data == null) {
                              return Padding(padding: const EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator()
                              ));
                      } else {
                      return Container(
                          height: 120,
                          padding: const EdgeInsets.only(right: 15),
                          child:
                          snapshot.data.length == 0 ?
                                Container(
                                    width: double.infinity,
                                    height: 200,
                                    padding: const EdgeInsets.only(right: 10),
                                    child:
                                   Align(
                                     alignment: Alignment.center,
                                     child:  Text(
                                       "Tidak ada jadwal",
                                       style: new TextStyle(
                                           fontFamily: 'VarelaRound', fontSize: 15),
                                     ),
                                   )
                                )
                            :

                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(top: 10.0, left: 10),
                            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                            itemBuilder: (context, i) {
                              return
                              Container(
                                  width: 160,
                                  padding: const EdgeInsets.only(right: 10),
                                  child:
                                  Card(
                                    elevation: 0,
                                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                    shape: RoundedRectangleBorder(
                                      side: new BorderSide(color:
                                      HexColor("#DDDDDD"), width: 1.0
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child:
                                    InkWell(
                                        splashColor: Colors.blue.withAlpha(30),
                                        onTap: () {
                                        },
                                        child:
                                        Container(
                                          child: Center(child:
                                          Column(
                                            children: [
                                              Padding(
                                                child:
                                                Text(new DateFormat.EEEE().format(
                                                    DateTime.parse(snapshot.data[i]['f'])),
                                                  style: new TextStyle(
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
                                                        DateTime.parse(snapshot.data[i]['f'])) +
                                                    ")",
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
                                                padding: const EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                              )
                                            ],
                                          )

                                          ),
                                        )
                                    ),
                                  )


                              );
                            },
                          )
                      );
    }},
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
                    getStatus != 'Online' ?
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        //side: BorderSide(color: Colors.red)
                      ),
                      child: Text(
                        "Mulai Konsultasi",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 14,
                        ),
                      ),
                    )
                  :

                    RaisedButton(
                      color:  HexColor(AppHelper().app_color1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        //side: BorderSide(color: Colors.red, width: 2.0)
                      ),
                      child: Text(
                        "Mulai Konsultasi",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 14,
                          color: Colors.white
                        ),
                      ),
                      onPressed: () {
                        _cekAvaible();
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
