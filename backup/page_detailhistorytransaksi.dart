



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

/*

class DetailHistoryTransaksi extends StatefulWidget {
  final String InvNumber;
  const DetailHistoryTransaksi(this.InvNumber);
  @override
  _DetailHistoryTransaksiState createState() => new _DetailHistoryTransaksiState
    (getInvNumber: this.InvNumber);
}

class _DetailHistoryTransaksiState extends State<DetailHistoryTransaksi> {
  List data;
  String getInvNumber;
  String
  getStatusInv,
  getStatusRoom,
  getRoom,
  getTglKonsultasi,
  getNamaDoktor,
  getJenisKonsul = '';

  _DetailHistoryTransaksiState({this.getInvNumber});


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://duakata-dev.com/miracle/api_script.php?do=getdata_transaksidetail&id="+getInvNumber),
        headers: {"Accept": "application/json"}
    );
    setState(() {
      data = json.decode(response.body);
    });
  }


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  @override
  void initState() {
    super.initState();
    //_getAccountDetail();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: Hexcolor("#075e55"),
                title: Text("Detail Transaksi",      style: TextStyle(
                    color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16)),
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
          Container(
              color: Hexcolor("#ffffff"),
              width: double.infinity,
              child :
                        FutureBuilder<List>(
                              future: getData(),
                          builder: (context, snapshot) {
                            if (data == null) {
                              return Center(
                                  child: Image.asset(
                                    "assets/loadingq.gif",
                                    width: 180.0,
                                  )
                              );
                            } else {
                                            return ListView.builder(
                                                itemCount: data== null ? 0 : data.length,
                                                itemBuilder: (context, i) {
                                                          return  Padding(
                                                            padding: const EdgeInsets.only(left: 10.0,top:20.0,right: 10.0),
                                                            child :
                                                              Card(
                                                                    child : Align(
                                                                        alignment: Alignment.centerLeft,
                                                                       child: Padding(
                                                                         padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                                                         child: Column(
                                                                           children: <Widget>[
                                                                             Padding(
                                                                               padding: const EdgeInsets.only(top:20.0,bottom: 15.0),
                                                                               child: Align(
                                                                                   alignment: Alignment.centerLeft,
                                                                                   child : Text("Status Pesanan",
                                                                                       textAlign: TextAlign.left,
                                                                                       style: TextStyle(
                                                                                           color: Colors.black,
                                                                                           fontFamily: 'VarelaRound',
                                                                                           fontSize: 15))
                                                                               )
                                                                             ),
                                                                             Divider(
                                                                               height: 3,
                                                                             ),
                                                                             Padding(
                                                                               padding: const EdgeInsets.only(top:15.0,
                                                                                   bottom: 15.0),
                                                                               child :
                                                                               Row(
                                                                                 mainAxisAlignment:
                                                                                 MainAxisAlignment.spaceBetween,
                                                                                 //mainAxisSize: MainAxisSize.max,
                                                                                 children: <Widget>[
                                                                                   Text(
                                                                                     "Tagihan ("+getInvNumber+")",
                                                                                     textAlign: TextAlign.left,
                                                                                     style: TextStyle(
                                                                                         fontFamily: 'VarelaRound',
                                                                                         fontSize: 13),
                                                                                   ),
                                                                                   Text(data[i]["a"],
                                                                                       style: TextStyle(
                                                                                           fontFamily: 'VarelaRound',
                                                                                           fontWeight: FontWeight.bold,
                                                                                           fontSize: 14)),
                                                                                 ],
                                                                               ),
                                                                             ),

                                                                             Padding(
                                                                               padding: const EdgeInsets.only(
                                                                                   bottom: 15.0),
                                                                               child :
                                                                               Row(
                                                                                 mainAxisAlignment:
                                                                                 MainAxisAlignment.spaceBetween,
                                                                                 //mainAxisSize: MainAxisSize.max,
                                                                                 children: <Widget>[
                                                                                   Text(
                                                                                     "Status Konsultasi",
                                                                                     textAlign: TextAlign.left,
                                                                                     style: TextStyle(
                                                                                         fontFamily: 'VarelaRound',
                                                                                         fontSize: 13),
                                                                                   ),
                                                                                   Text(data[i]["b"],
                                                                                       style: TextStyle(
                                                                                           fontFamily: 'VarelaRound',
                                                                                           fontWeight: FontWeight.bold,
                                                                                           fontSize: 14)),
                                                                                 ],
                                                                               ),
                                                                             ),

                                                                             Padding(
                                                                               padding: const EdgeInsets.only(
                                                                                   bottom: 15.0),
                                                                               child :
                                                                               Row(
                                                                                 mainAxisAlignment:
                                                                                 MainAxisAlignment.spaceBetween,
                                                                                 //mainAxisSize: MainAxisSize.max,
                                                                                 children: <Widget>[
                                                                                   Text(
                                                                                     "Room Konsultasi",
                                                                                     textAlign: TextAlign.left,
                                                                                     style: TextStyle(
                                                                                         fontFamily: 'VarelaRound',
                                                                                         fontSize: 13),
                                                                                   ),
                                                                                   Text(data[i]["c"],
                                                                                       style: TextStyle(
                                                                                           fontFamily: 'VarelaRound',
                                                                                           fontWeight: FontWeight.bold,
                                                                                           fontSize: 14)),
                                                                                 ],
                                                                               ),
                                                                             ),
                                                                             Divider(
                                                                               height: 3,
                                                                             ),

                                                                             Padding(
                                                                                 padding: const EdgeInsets.only(top:20.0,bottom: 15.0),
                                                                                 child :
                                                                                 Align(
                                                                                     alignment: Alignment.centerLeft,
                                                                                     child :
                                                                                     Text("Detail Pesanan",
                                                                                         textAlign: TextAlign.left,
                                                                                         style: TextStyle(
                                                                                             color: Colors.black,
                                                                                             fontFamily: 'VarelaRound',
                                                                                             fontSize: 15))
                                                                                 )),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 5.0),
                                                                        child: Card(
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(15.0),
                                                                          ),
                                                                          color: Hexcolor("#f9f9f9"),
                                                                          child: Align(
                                                                              alignment: Alignment.center,
                                                                              child : Column(
                                                                                children: <Widget>[
                                                                                  Opacity(
                                                                                      opacity: 0.7,
                                                                                      child :
                                                                                      Padding (
                                                                                          padding:
                                                                                          const EdgeInsets.only(top:15),
                                                                                          child :
                                                                                          Text("Konsultasi pada",
                                                                                              style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontFamily: 'VarelaRound',
                                                                                                  fontSize: 12)))),
                                                                                  Padding (
                                                                                      padding: const EdgeInsets.only(top:10),
                                                                                      child :
                                                                                      Text(data[i]["d"],
                                                                                          style: TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontFamily: 'VarelaRound',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: 16))),
                                                                                  Padding (
                                                                                    padding: const EdgeInsets.only(top : 10),
                                                                                    child :
                                                                                    Opacity(
                                                                                        opacity: 0.7,
                                                                                        child :
                                                                                        Text("Konsultasi dengan",
                                                                                            style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontFamily: 'VarelaRound',
                                                                                                fontSize: 12))),
                                                                                  ),
                                                                                  Padding (
                                                                                      padding: const EdgeInsets.only(top:10),
                                                                                      child :
                                                                                      Text(data[i]["e"],
                                                                                          style: TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontFamily: 'VarelaRound',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: 16))),
                                                                                  Padding (
                                                                                    padding: const EdgeInsets.only(top : 10),
                                                                                    child :
                                                                                    Opacity(
                                                                                        opacity: 0.7,
                                                                                        child :
                                                                                        Text("Jenis Konsultasi",
                                                                                            style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontFamily: 'VarelaRound',
                                                                                                fontSize: 12))),
                                                                                  ),
                                                                                  Padding (
                                                                                      padding: const EdgeInsets.only
                                                                                        (top:10,bottom: 15),
                                                                                      child :
                                                                                      Text(data[i]["f"]+" Consultation",
                                                                                          style: TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontFamily: 'VarelaRound',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: 16))),
                                                                                ],
                                                                              )
                                                                          )
                                                                        )
                                                                      ),
                                                                             Padding(
                                                                               padding: const EdgeInsets.all(10),
                                                                             )


                                                                           ],
                                                                         ),
                                                                       ),
                                                                    )
                                                              )
                                                          );

                                                  }
                                            );
                            }
                          },
                        )
                  ),
        )
    );

    }


}*/

