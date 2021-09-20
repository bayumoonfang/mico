
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/Pesanan/page_installroom.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/page_homenew.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:http/http.dart' as http;


class DetailTagihan extends StatefulWidget {
  final String idAppointment;
  const DetailTagihan(this.idAppointment);
  @override
  _DetailTagihan createState() => new _DetailTagihan();
}



class _DetailTagihan extends State<DetailTagihan> {

  List data;
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  Future<List> getDetailInvoiced() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_invoiced2&id=" +
            widget.idAppointment);
    return json.decode(response.body);
  }


  String getStatus = "...";
  _getDetail() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_statusinv&id=" +
            widget.idAppointment);
    Map data = jsonDecode(response.body);
    setState(() {
      getStatus = data["a"].toString();
    });
  }

  void konfirmBayar() async {
    final response = await http.post(
        AppHelper().applink+"do=action_konfirmbayar",
        body: {
          "idtransaksi": widget.idAppointment
        },
        headers: {"Accept":"application/json"});
    Map data2 = jsonDecode(response.body);
    setState(() {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => InstallRoom()));
    });
  }

  void batalPesanan() async {
    final response = await http.post(
        AppHelper().applink+"do=action_batalpesanan",
        body: {
          "idtransaksi": widget.idAppointment
        },
        headers: {"Accept":"application/json"});
    Map data2 = jsonDecode(response.body);
    setState(() {
       Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => PageHomeNew()));
    });
  }

  alertkonfirmBayar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 185,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Konfirmasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.fileInvoice,
                      color: HexColor
                        (AppHelper().app_color1),size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin sudah membayar ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: HexColor
                            (AppHelper().app_color1)),
                          onPressed: () {
                            konfirmBayar();
                            //Navigator.pop(context);
                          }, child: Text("Iya", style: TextStyle(color : HexColor
                          (AppHelper().app_color1)),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }



  alertBatalPesanan() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 185,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Konfirmasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.fileInvoice,
                      color: Colors.redAccent,size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin membatalkan pesanan ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            batalPesanan();
                            Navigator.pop(context);
                          }, child: Text("Iya", style: TextStyle(color :Colors.redAccent),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _getDetail();
  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: new AppBar(
            //backgroundColor: HexColor("#075e55"),
            backgroundColor: Colors.white,
            title: Text(
              "Detail Tagihan",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'VarelaRound', fontSize: 16),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new FaIcon(FontAwesomeIcons.times,size: 20,),
                  color: Colors.black,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: _datafield(),
          ),


          bottomSheet: new
          Container (
            height: 120,
              color: Colors.white,
              child :
             Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 Row(
                   children: [
                     Expanded(
                         child: Padding(
                             padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                             child:
                             RaisedButton(
                               color: HexColor(AppHelper().app_color4),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                 //side: BorderSide(color: Colors.red)
                               ),
                               child: Text(
                                 "Konfirmasi Pembayaran",
                                 style: TextStyle(
                                     fontFamily: 'VarelaRound',
                                     fontSize: 14,
                                     color: Colors.white
                                 ),
                               ),
                               onPressed: (){
                                 alertkonfirmBayar();
                               },
                             )
                         )
                     )
                   ],
                 ),

                 Row(
                   children: [
                     Expanded(
                         child: Padding(
                             padding: const EdgeInsets.only(right: 20.0, left: 20.0,bottom: 5),
                             child:
                             RaisedButton(
                               color: HexColor(AppHelper().app_color6),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                 //side: BorderSide(color: Colors.red)
                               ),
                               child: Text(
                                 "Batalkan Pesanan",
                                 style: TextStyle(
                                     fontFamily: 'VarelaRound',
                                     fontSize: 14,
                                     color: Colors.white
                                 ),
                               ),
                               onPressed: (){
                                 alertBatalPesanan();
                               },
                             )
                         )
                     )
                   ],
                 )
               ],
             )
          ),
        )
    );
  }

  Widget _datafield() {
    return FutureBuilder<List>(
        future: getDetailInvoiced(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
                child: CircularProgressIndicator()
            );
          }else {
            return snapshot.data == 0 ?
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
                          "Data tidak ditemukan",
                          style: new TextStyle(
                              fontFamily: 'VarelaRound', fontSize: 18),
                        ),
                      ],
                    )))
                :
            ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15,left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Status Pesanan", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 11)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5,left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              snapshot.data[i]["d"] == 'OPEN' ? 'Belum Dibayar' : snapshot.data[i]["d"]

                              , style: TextStyle(fontFamily: 'VarelaRound',fontSize: 15,fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(height: 5,),
                      ),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:40,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Detail Tagihan",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),

                            ],
                          )
                      ),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Nomor Tagihan",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(snapshot.data[i]["a"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Tanggal",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(snapshot.data[i]["c"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Nama Tagihan",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text("Pembayaran Konsultasi "+snapshot.data[i]["i"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),



                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:40,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Detail Dokter",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),

                            ],
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Nama Dokter",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(snapshot.data[i]["e"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Cabang",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(snapshot.data[i]["f"]+" - "+snapshot.data[i]["g"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),



                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Spesialis",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(snapshot.data[i]["j"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(height: 5,),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:40,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Detail Jumlah Tagihan",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ],
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Harga Konsultasi",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text("Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                  snapshot.data[i]["k"]),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Biaya admin",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text("Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                  snapshot.data[i]["l"]),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "PPN",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text("Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                  snapshot.data[i]["o"]),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
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
                                    color: Colors.red,
                                    fontSize: 13),
                              ),
                              Text("- Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                  snapshot.data[i]["n"]),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 13)),
                            ],
                          )
                      ),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
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
                                    fontSize: 13),
                              ),
                              Text("- Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                  snapshot.data[i]["m"]),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 13)),
                            ],
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Total ",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 15),
                              ),
                              Text("Rp "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(
                                  snapshot.data[i]["p"]),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          )
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(height: 5,),
                      ),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:10,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Metode Pembayaran ",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              CachedNetworkImage(
                                width: 40,
                                imageUrl: AppHelper().applinksource+"media/pembayaran/"+snapshot.data[i]["q"].toString(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ],
                          )
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(height: 5,),
                      ),

                      Container(
                        height: 200,
                      )


                    ],
                  );
                }

            );
          }
        }
    );
  }



}



