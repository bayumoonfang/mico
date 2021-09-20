
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/app_helper.dart';
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
          body: ResponsiveContainer(
            heightPercent: 100,
            widthPercent: 100,
            child: _datafield(),
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

                          getStatus == 'OPEN' ?
                          RaisedButton(
                            color: HexColor("#075e55"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              //side: BorderSide(color: Colors.red)
                            ),
                            child: Text(
                              "Bayar",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14,
                                  color: Colors.white
                              ),
                            ),
                            onPressed: (){

                            },
                          )

                              :

                          Opacity(
                              opacity: 0.5,
                              child :
                              OutlineButton(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.red)
                                ),
                                child: Text(
                                  "Bayar",
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14,
                                      color: Colors.black
                                  ),
                                ),
                              ))



                      ))

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
                              Text(snapshot.data[i]["f"],
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
                                "Regional",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(snapshot.data[i]["g"],
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          )
                      ),

                    ],
                  );
                }

            );
          }
        }
    );
  }



}



