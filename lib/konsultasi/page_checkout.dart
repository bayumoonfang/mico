


import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/konsultasi/page_pembayaran.dart';
import 'package:mico/konsultasi/page_promouser.dart';
import 'package:mico/mico_preparekonsultasi.dart';
import 'package:toast/toast.dart';


class Checkout extends StatefulWidget{
  final String idDokter, accnumDokter, getPhone;
  const Checkout(this.idDokter, this.accnumDokter, this.getPhone);
  @override
  _Checkout createState() => _Checkout();
}


class _Checkout extends State<Checkout> {


  String _valGender;
  bool _isVisible = false;
  List _myFriends = [
    "Konsultasi Chat",
    "Konsultasi Video Call",
  ];

  String getPhoto = "...";
  String valLayanan = "";
  String getNamaDokter = "...";
  String getCabang = "...";
  String getHarga = "0";
  String getDiskonPersen = "0";
  String getDiskonRupiah = "0";
  String getBiayaLain = "0";
  String getTotalGross = "0";
  String getTotalNett = "0";
  String getrossHitung = "0";
  String getNamaPromo = "...";
  String getTypePromo = "...";
  String getQtyPromo = "0";
  int totalPromo = 0;
  var getTotalNett1 = 0;
  _getDetailDokter() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_dokterdetail&id="+widget.idDokter,
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      getPhoto = data["e"].toString();
      getHarga = data["k"].toString();
      getDiskonPersen = data["l"].toString();
      getDiskonRupiah = data["m"].toString();
      getTotalGross = data["n"].toString();
      getNamaDokter = data["b"].toString();
      getCabang = data["c"].toString();
    });
  }


  _getBiayaAdmin() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_biayaadmin",
        headers: {"Accept":"application/json"});
    Map data2 = jsonDecode(response.body);
    setState(() {
      if(getDiskonPersen == "100") {
        getBiayaLain = "0";
      } else {
        getBiayaLain = data2["a"].toString();
      }
    });
  }


  _getPromo() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_promoq&id="+widget.getPhone,
        headers: {"Accept":"application/json"});
    Map data2 = jsonDecode(response.body);
    setState(() {
          getrossHitung = getTotalGross.toString();
          if(data2["message"].toString() != "0") {
            getTypePromo = data2["d"].toString();
            getQtyPromo = data2["e"].toString();
            getNamaPromo = data2["c"].toString();
            if(getQtyPromo == "0") {
              getTotalNett1 = int.parse(getrossHitung.toString()) + int.parse(getBiayaLain.toString());
            } else {
              if(getTypePromo == 'amount') {
                getTotalNett1 = (int.parse(getrossHitung.toString()) + int.parse(getBiayaLain.toString())) - int.parse(getQtyPromo.toString());
              } else if (getTypePromo == 'percent') {
                totalPromo = int.parse(getQtyPromo.toString()) / 100 * (int.parse(getrossHitung.toString()) + int.parse(getBiayaLain.toString())) as int;
                getTotalNett1 = (int.parse(getrossHitung.toString()) + int.parse(getBiayaLain.toString())) - int.parse(totalPromo.toString());
              }
            }
          } else {
            getQtyPromo = "0";
            getTotalNett1 = int.parse(getrossHitung.toString()) + int.parse(getBiayaLain.toString());
          }
    });
  }



  startSplashScreen() async {
    _isVisible = false;
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  _preparedata() async {
    await _getDetailDokter();
    await _getBiayaAdmin();
    await _getPromo();
  }


  @override
  void initState() {
    super.initState();
    _preparedata();
    startSplashScreen();
  }

  int _isButtonDisabled = 0;
  _onButton(int index) {
    setState(() => _isButtonDisabled = index);
  }


  FutureOr onGoBack(dynamic value) {
    _preparedata();
    startSplashScreen();
  }


  void resetPromo() {
    var url = AppHelper().applink + "do=action_resetpromo";
    http.post(url,
        body: {
          "iduser": widget.getPhone
        });
    setState(() {
      _preparedata();
      getQtyPromo = "0";
      startSplashScreen();
    });
  }


  alertReset() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 178,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Konfirmasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.save,
                      color: Colors.redAccent,size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin mereset promo anda ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            Navigator.pop(context);
                            resetPromo();
                          }, child: Text("Reset", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Checkout",
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
                _isVisible == false ?
                        Center(
                            child: CircularProgressIndicator()
                        )

                :
            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25),
                  child: Text("Jenis Konsultasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14)),
                ),
                Padding (
                  padding: const EdgeInsets.only(left: 25),
                  child :
                  DropdownButton(
                    hint: Text("Pilih Jenis Konsultasi",style: TextStyle(fontSize: 15),),
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
                      backgroundImage:
                          getPhoto != '' ?
                      CachedNetworkImageProvider(AppHelper().applinksource+"media/photo/"+getPhoto)
                          :
                          AssetImage('assets/mira-ico.png'),
                      radius: 29,
                      backgroundColor: Colors.transparent,
                    ),
                    title: Padding(padding: const EdgeInsets.only(top: 18),
                    child: Text(getNamaDokter.toString(),   style: TextStyle(
                        fontFamily: 'VarelaRound',
                        fontSize: 17,
                        color: Colors.black
                    )),),
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
                        Text(getCabang.toString(),   style: TextStyle(
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

                  Padding(padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Container(
                      height: 8,
                      width: double.infinity,
                      color: HexColor("#f3f4f6"),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
                  child:
                  getQtyPromo == "0" && getDiskonPersen != "100" ?
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => PromoUser(widget.getPhone))).then(onGoBack);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: HexColor("#d6d7d9"),
                              width: 2
                          )
                      ),
                      child: ListTile(
                        /*shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      selected: true,
                      selectedTileColor: Colors.blue[100],*/
                        leading: Image.asset("assets/discme2.png",
                          height: 26,width: 26,),
                        title: Text("Gunakan Promo Lebih Murah",   style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        )),
                        trailing: FaIcon(FontAwesomeIcons.chevronRight,size: 18,),
                      ),
                    ),
                  )
          : getDiskonPersen == "100" ?
                      Opacity(
                        opacity: 0.5,
                        child :
                      Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: HexColor("#d6d7d9"),
                              width: 2
                          )
                      ),
                      child: ListTile(
                        leading: Image.asset("assets/discme2.png",
                          height: 26,width: 26,),
                        title: Text("Gunakan Promo Lebih Murah",   style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        )),
                        trailing: FaIcon(FontAwesomeIcons.chevronRight,size: 18,),
                      ),
                    ))
                  :

                  Column(
                    children: [
                      InkWell(
                          onTap: (){
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => PromoUser(widget.getPhone))).then(onGoBack);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: HexColor("#d6d7d9"),
                                    width: 2
                                )
                            ),
                            child: ListTile(
                              leading: Image.asset("assets/discme2.png",
                                height: 26,width: 26,),
                              title: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(getNamaPromo,   style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    )
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top:5),
                                    child:  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("1 Promo terpakai",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'VarelaRound',
                                              fontSize: 12
                                          )
                                      ),
                                    ),)
                                ],
                              ),
                              trailing: FaIcon(FontAwesomeIcons.chevronRight,size: 18,),
                            ),
                          ),
                      ),

                      InkWell(
                        child: Align(alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left:5,top: 15),
                              child: Container(
                                height: 25,
                                child: RaisedButton(
                                  onPressed: (){
                                    alertReset();
                                  },
                                  elevation: 0,
                                  child: Text("Reset Promo",
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      )),
                                ),
                              )
                            )),
                      )
                    ],
                  )
                ),

                Padding(padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Container(
                    height: 8,
                    width: double.infinity,
                    color: HexColor("#f3f4f6"),
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.only(left: 25,top:20),
                  child:
                  Text("Ringkasan Biaya", style: TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                        Text("Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getHarga)),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
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
                          "Biaya Admin",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14),
                        ),
                        Text("Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getBiayaLain.toString())),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14))
                      ],
                    )
                ),


                getQtyPromo != "0" ?
                Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Promo",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              color: Colors.red,
                              fontSize: 14),
                        ),
                        Text("- Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getQtyPromo.toString())),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                color: Colors.red,
                                fontSize: 14))
                      ],
                    )
                )
                    : Container(),

                getDiskonPersen != '0' ?
                Padding(
                    padding: const EdgeInsets.only(left: 25,top:10,right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Diskon (" + getDiskonPersen+ "%)",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              color: Colors.red,
                              fontSize: 14),
                        ),
                        Text("- Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getDiskonRupiah.toString())),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                color: Colors.red,
                                fontSize: 14))
                      ],
                    )
                )
                : Container(),



                Padding(
                  padding: const EdgeInsets.only(left:0),
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
                        Text("Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(getTotalNett1.toString())),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
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
                            fontSize: 15,
                          ),
                        ),
                      )
                          :

                      RaisedButton(
                        color:  HexColor("#00aa5b"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          //side: BorderSide(color: Colors.red, width: 2.0)
                        ),
                        child: Text(
                          "Lanjutkan",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => CekPembayaran2(
                                widget.getPhone,
                                getQtyPromo.toString(),
                                getDiskonRupiah.toString(),
                                getBiayaLain.toString(),
                                getTotalGross.toString(),
                                getTotalNett1.toString(),
                                widget.accnumDokter,
                                valLayanan,
                                getHarga.toString()
                              )));
                         /* getDiskonPersen == '100' ?

                              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                              builder: (BuildContext context) => PrepareRoom(widget.idJadwal.toString(),widget.idUser,widget.idDokter, valLayanan)))

                          :
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(
                          builder: (BuildContext context) => CekPembayaran2(widget.idJadwal.toString(),widget.idUser,widget.idDokter, getTotal, valLayanan)));

*/
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