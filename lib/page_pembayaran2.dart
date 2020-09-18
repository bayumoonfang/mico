


import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mico/page_pembayaran3.dart';


class CekPembayaran extends StatefulWidget{
  final String idJadwal, idUser, idDokter, idNamaDokter, idKlinik;
  const CekPembayaran(this.idJadwal, this.idUser, this.idDokter, this.idNamaDokter, this.idKlinik);
  @override
  _cekPembayaranState createState() => _cekPembayaranState(
      getIDJadwal: this.idJadwal,
      getUser: this.idUser,
      getDokter: this.idDokter,
      getNamaDokter: this.idNamaDokter,
      getKlinik: this.idKlinik
  );
}


class _cekPembayaranState extends State<CekPembayaran> {
  String
  getIDJadwal,
      getUser,
      getDokter,
      getNamaDokter,
      getKlinik = "";
  String _valGender;
  List _myFriends = [
    "Konsultasi Chat",
    "Konsultasi Video Call",
  ];

  String getPhoto = "";
  String valLayanan = "";
  String getaa = "";
  String getHarga = "";
  String getDiskon = "";
  String getTotal = "";
  _getDetailDokter() async {
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_detaildokter2&id=" +
            widget.idDokter);
    Map data = jsonDecode(response.body);
    setState(() {
      getPhoto = data["e"].toString();
      getaa = data["c"].toString();
      getHarga = data["i"].toString();
      getDiskon = data["j"].toString();
      getTotal = data["l"].toString();
    });
  }


  String getDOCID = "";
  String  getDateAvaible = "";
  String getJam = "";
  String getStatus = "";
  String getbb = "";
  String getcc = "";
  String getTanggal = "";
  _getDetailJadwal() async {
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_detailjadwal&id=" +
            widget.idJadwal);
    Map data = jsonDecode(response.body);
    setState(() {
      getDOCID = data["b"].toString();
      getDateAvaible = data["c"].toString();
      getJam = data["d"].toString();
      getStatus = data["e"].toString();
      getbb = data["c"].toString();
      getcc = data["f"].toString();
      getTanggal = data["h"].toString();
    });
  }



  @override
  void initState() {
    super.initState();
    _getDetailDokter();
    _getDetailJadwal();
  }

  int _isButtonDisabled = 0;
  _onButton(int index) {
    setState(() => _isButtonDisabled = index);
  }

  _cekPembayaranState({
    this.getIDJadwal,
    this.getUser,
    this.getDokter,
    this.getNamaDokter,
    this.getKlinik});
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Hexcolor("#075e55"),
          title: Text(
            "Pembayaran",
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
            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 25),
                  child: Text("Jenis Konsultasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14)),
                ),
                Padding (
                  padding: const EdgeInsets.only(left: 25),
                  child :
                  DropdownButton(
                    hint: Text("Pilih Jenis Konsultasi"),
                    value: _valGender,
                    items: _myFriends.map((value) {
                      return DropdownMenuItem(
                        child: Text(value,   style: TextStyle(
                            fontFamily: 'VarelaRound'
                        )),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valGender = value;
                        valLayanan = value;
                        _onButton(1);//Untuk memberitahu _valGender bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                      });
                    },

                )),
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child : Divider(
                    height: 2,
                  )
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10,top:10),
                  child: ListTile(
                    leading:
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider("https://duakata-dev.com/miracle/media/photo/" +
                          getPhoto,
                      ),
                      radius: 29,
                    ),
                    title: Text(widget.idNamaDokter,   style: TextStyle(
                        fontFamily: 'VarelaRound',
                        fontSize: 17,
                        color: Colors.black
                    )),
                    subtitle: Column(
                      children: [
                    Padding (
                    padding : const EdgeInsets.only(top: 5),
                    child :
                        Align(
                        child :
                        Opacity(
                          opacity : 0.5,
                        child :
                        Text(getaa.toString(),   style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14,
                                color: Colors.black
                            )
                          )
                        ),
                        alignment: Alignment.centerLeft,)),
                        Padding (
                            padding : const EdgeInsets.only(top: 5),
                            child :
                            Align(
                              child : Text
                                (valLayanan,   style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  color: Colors.black
                              ) ),
                              alignment: Alignment.centerLeft,)
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25,top:40),
                  child:
                  Text("Detail Konsultasi", style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 18,
                      color: Colors.black)
                  ),
                ),
                    Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "Hari Konsultasi",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14),
                            ),
                            Text(new DateFormat.EEEE().format(DateTime.parse(getDateAvaible)),
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        )
                    ),

                Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Tanggal Konsultasi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14),
                        ),
                        Text(getTanggal+ " - "+new DateFormat.MMM().format(DateTime.parse(getbb)) + " - "+getcc.toString(),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ],
                    )
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Jam Konsultasi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14),
                        ),
                        Text(getJam.toString(),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ],
                    )
                ),

      Padding(
        padding: const EdgeInsets.only(left: 25,top:20,right: 25),
        child: Divider(height: 2,)),




                Padding(
                  padding: const EdgeInsets.only(left: 25,top:20),
                  child:
                  Text("Ringkasan", style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 18,
                      color: Colors.black)
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Biaya sesi untuk 30 menit",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14),
                        ),
                        Text("Rp "+
                            NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getHarga)),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ],
                    )
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Diskon",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14),
                        ),
                        Text("Rp "+
                            NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getDiskon)),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ],
                    )
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Bayar",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text("Rp "+
                            NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getTotal)),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    )
                ),



        ],
            ),
        bottomSheet: new
        Container (
            color: Colors.white,
            child :
            Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom:10),
                      child:
                      _isButtonDisabled == 0 ?
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          //side: BorderSide(color: Colors.red)
                        ),
                        child: Text(
                          "Lanjutkan",
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
                          "Lanjutkan",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14,
                              color: Colors.white
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(
                              builder: (BuildContext context) => CekPembayaran2(widget.idJadwal.toString(),widget.idUser,widget.idDokter)));
                        },
                      ),
                   )
                )
              ],
            )),
      ),

    );
  }

}