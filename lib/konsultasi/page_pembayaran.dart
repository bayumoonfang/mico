


import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/konsultasi/page_showtagihan.dart';
import 'package:responsive_container/responsive_container.dart';


class CekPembayaran2 extends StatefulWidget{
  final String getPhone, amountPromo, amountDiskon, amountAdmin, grossOrder, totalOrder, accDokter, namaLayanan, amountHarga,noPromo  ;
  const CekPembayaran2(this.getPhone, this.amountPromo, this.amountDiskon, this.amountAdmin, this.grossOrder, this.totalOrder,
      this.accDokter, this.namaLayanan, this.amountHarga, this.noPromo);
  @override
  _cekPembayaran2State createState() => _cekPembayaran2State();
}


class _cekPembayaran2State extends State<CekPembayaran2> {
  List data;
  String btn_bayar = "1";


  bool _isVisible = false;
  bool _isVisibleBayar = false;
  startSplashScreen() async {
    _isVisible = false;
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      setState(() {
        _isVisible = true;
      });
    });
  }


  String getPPN = "0";
  var getTotalSemua = 0;
  _getPPN() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_ppn&total="+widget.totalOrder,
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      getPPN = data["a"].toString();
      getTotalSemua = int.parse(widget.totalOrder) + int.parse(getPPN);
    });
  }

  void addInvoiced() async {
    final response = await http.post(
        AppHelper().applink+"do=add_invoicedorder",
        body: {
          "iduser": widget.getPhone,
          "amountPromo" : widget.amountPromo,
          "amountDiskon" : widget.amountDiskon,
          "amountAdmin" : widget.amountAdmin,
          "grossOrder" : widget.grossOrder,
          "totalOrder":widget.totalOrder,
          "accDokter": widget.accDokter,
          "ppn": getPPN,
          "gettotalsemua": getTotalSemua.toString(),
          "namaLayanan": widget.namaLayanan,
          "amountHarga": widget.amountHarga,
          "kodePromo" : widget.noPromo
        },
        headers: {"Accept":"application/json"});
        Map data2 = jsonDecode(response.body);
        setState(() {
          _isVisibleBayar = false;
          btn_bayar = "1";
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => ShowTagihan(widget.totalOrder, data2["message"].toString())));
        });
  }


  prepare() async{
    await _getPPN();
  }

  prosesbayar() async {
    setState(() {
      _isVisibleBayar = true;
      btn_bayar = "0";
    });
    await addInvoiced();


  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
    prepare();

  }



  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Pembayaran",
            style: TextStyle(
              color: Colors.black,
               fontWeight: FontWeight.bold,
               fontFamily: 'VarelaRound', fontSize: 16),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                color: Colors.black,
                icon: new Icon(Icons.arrow_back),
                onPressed: () => {
                  Navigator.pop(context)
                }),
          ),
        ),
        body:
        _isVisible == false ?
              Center(
                  child: CircularProgressIndicator()
              )

            :
         Container(
          child : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25,top:20),
                child:
                      Align(
                        alignment: Alignment.centerLeft,
                        child:     Text("Metode Pembayaran", style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)
                        ),
                      )
              ),

              Padding(
                padding: const EdgeInsets.only(left:9,top:20),
                child:
                     ListTile(
                       leading: Image.asset("assets/ovo.png",
                       width: 50,),
                       title: Text("Pembayaran dengan OVO", style: TextStyle(
                         fontFamily: 'VarelaRound',
                         fontSize: 14,)),
                     ),
              ),

              Padding(padding: const EdgeInsets.only(top: 20,bottom: 10),
                child: Container(
                  height: 8,
                  width: double.infinity,
                  color: HexColor("#f3f4f6"),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(left: 25,top:20),
                  child:
                  Align(
                    alignment: Alignment.centerLeft,
                    child:     Text("Ringkasan Pembayaran", style: TextStyle(
                        fontFamily: 'VarelaRound',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)
                    ),
                  )
              ),

              Padding(
                  padding: const EdgeInsets.only(left: 25,top:15,right: 25),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Total Tagihan",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 13),
                      ),
                      Text("Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(widget.totalOrder)),
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 13)),
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
                        "Tax (PPN)",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 13),
                      ),
                      Text("Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getPPN.toString())),
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 13)),
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
                        "Penukaran Poin",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            color: Colors.red,
                            fontSize: 13),
                      ),
                      Text("- Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(0),
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              color: Colors.red,
                              fontSize: 13)),

                    ],
                  )
              ),


              Visibility(
                 visible: _isVisibleBayar,
                  child: Center(
                    child: Padding(padding: const EdgeInsets.only(top: 100),child:
                    CircularProgressIndicator()),
                  )),

            ],
          )
        ),

            bottomSheet:
            _isVisible == false ?
            Center()

                :

            new Container(
              height: 60,
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(alignment: Alignment.topLeft,child: Padding(
                        padding:    const EdgeInsets.only(top: 16,left: 20)
                        ,
                        child:
                        Text(
                            getTotalSemua.toString() != "0" ?
                          "Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getTotalSemua.toString()))
                          :
                                "FREE"

                          ,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                color: getTotalSemua.toString() == "0" ? Colors.green : Colors.orange,
                                fontSize: 24),textAlign: TextAlign.left,),),
                      ),

                    ],
                  ),

                        Padding(padding: const EdgeInsets.only(right: 15),
                        child: Container(
                          width: 150,
                          child: RaisedButton(
                            elevation: 0,
                            color:  HexColor(AppHelper().app_color4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              //side: BorderSide(color: Colors.red, width: 2.0)
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.shieldAlt,color: Colors.white,size: 15,),
                                  Padding(padding: const EdgeInsets.only(left: 10),
                                    child: Text("Bayar",
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 13),textAlign: TextAlign.center,),)

                                ],
                              ),

                            onPressed: (){
                              prosesbayar();
                            },
                          ),
                        ),)
                ],
              ),
            ),


      ),

    );
  }



}