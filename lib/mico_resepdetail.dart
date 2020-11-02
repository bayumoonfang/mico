
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:http/http.dart' as http;


class ResepDetail extends StatefulWidget {
  final String idResep;
  const ResepDetail(this.idResep);
  @override
  _ResepDetailState createState() => new _ResepDetailState();
}



class _ResepDetailState extends State<ResepDetail> {

  List data;
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  Future<List> getDetailInvoiced() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_resepdetail&id=" +
            widget.idResep);
    setState(() {
      data =  json.decode(response.body);
    });
  }


  String getStatus = "...";


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor("#075e55"),
            title: Text(
              "Detail Resep",
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
              child:  _datafield(),

          ),

        )
    );
  }

  Widget _datafield() {
    return FutureBuilder<List>(
        future: getDetailInvoiced(),
        builder: (context, snapshot) {
          if (data == null) {
            return Center(
                child: Image.asset(
                  "assets/loadingq.gif",
                  width: 100.0,
                )
            );
          } else {
            return ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, i) {
                  return SingleChildScrollView(
                      child : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15,left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Nomor Resep", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 11)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5,left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.idResep, style: TextStyle(fontFamily: 'VarelaRound',fontSize: 15,fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(height: 5,),
                      ),




                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:20,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Diterbitkan Oleh",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
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
                                "Dokter",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(data[i]["f"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
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
                                "SIP",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(data[i]["t"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
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
                                    fontSize: 14),
                              ),
                              Text(data[i]["k"]+" "+new DateFormat.MMMM().format(DateTime.parse(data[i]["l"]))+
                                  " "+data[i]["i"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          )
                      ),

Padding(padding: const EdgeInsets.only(top:20,left: 15,right: 15),child: Divider(height: 4,),),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:20,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Pengambilan Resep",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
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
                                "Apotik/ Klinik",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(data[i]["g"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
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
                                "Kota / Regional",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(data[i]["u"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          )
                      ),




                      Padding(padding: const EdgeInsets.only(top:20,left: 15,right: 15),child: Divider(height: 4,),),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:20,right: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Infromasi Lainnya",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
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
                                "Kode Konsultasi",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(data[i]["b"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
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
                                "Tanggal Konsultasi",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(data[i]["x"]+" "+new DateFormat.MMMM().format(DateTime.parse(data[i]["y"]))+
                                  " "+data[i]["v"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
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
                                "Status Resep",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(data[i]["s"] == 'OPEN' ? 'Belum Diambil' : 'Sudah Diambil',
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          )
                      ),


                      Padding(
                          padding: const EdgeInsets.only(left: 15,top:70,right: 25),
                          child:        Text(
                            "Dimohon untuk penebusan resep bisa dilakukan di apotik / klinik yang tertera di informasi diatas. Atau hubungi klinik terkait untuk informasi lebih lanjut. Terima Kasih",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontStyle: FontStyle.italic,
                                fontSize: 13),
                          ),
                      ),




                    ],
                  ));
                }

            );
          }
        }
    );
  }



}



