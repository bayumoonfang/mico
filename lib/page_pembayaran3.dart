


import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class CekPembayaran2 extends StatefulWidget{
  final String idJadwal, idUser, idDokter;
  const CekPembayaran2(this.idJadwal, this.idUser, this.idDokter);
  @override
  _cekPembayaran2State createState() => _cekPembayaran2State(
      getIDJadwal: this.idJadwal,
      getUser: this.idUser,
      getDokter: this.idDokter
  );
}


class _cekPembayaran2State extends State<CekPembayaran2> {
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


  String getDOCID, getDateAvaible, getJam, getStatus, getTanggal = "";

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
      getTanggal = data["h"].toString()+ " - "+new DateFormat.MMM().format(DateTime.parse(data['c'])) + " - "+data["f"].toString();
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

  _cekPembayaran2State({
    this.getIDJadwal,
    this.getUser,
    this.getDokter});
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
        body: new Container(
          child : Column(
            children: [
              Padding(
                padding : const EdgeInsets.only(bottom: 5),
                child: Center(
                    child: Container(
                        width: double.infinity,
                        color : Hexcolor("#ffffff"),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10  ,right: 10,top: 15,bottom: 15),
                            child:
                            GestureDetector(
                              child :
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding :  const EdgeInsets.only(left: 5),
                                      child :
                                      Text("Bayar",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Hexcolor("#516067"),
                                            fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)),
                                  Padding(
                                      padding :  const EdgeInsets.only(right: 10),
                                      child :
                                      Text("Detail",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Hexcolor("#516067"),
                                            fontFamily: 'VarelaRound',fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),

                                ],
                              ),
                              onTap: (){

                              },)



                        )
                    )
                ),
              ),
            ],
          )
        ),

      ),

    );
  }

}