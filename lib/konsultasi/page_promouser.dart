

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:mico/helper/app_helper.dart';


class PromoUser extends StatefulWidget{
  final String getPhone;
  const PromoUser(this.getPhone);
  @override
  _PromoUser createState() => _PromoUser();
}


class _PromoUser extends State<PromoUser> {
  List data;
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  showFlushBar(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 5),
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);

  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(AppHelper().applink+"do=getdata_promouser&id="+widget.getPhone),
        headers: {"Accept":"application/json"}
    );
    return json.decode(response.body);
  }

  void addPromo(String namaPromo, String typePromo, String qtyPromo, String validPromo, String idPromo, String noPromo, String statusPromo) async {
    final response = await http.post(
        AppHelper().applink+"do=action_addpromo",
        body: {
          "iduser": widget.getPhone,
          "namaPromo" : namaPromo,
          "typePromo" : typePromo,
          "qtyPromo" : qtyPromo,
          "validPromo" : validPromo,
          "idPromo":idPromo,
          "noPromo": noPromo,
          "statusPromo": statusPromo
        },
        headers: {"Accept":"application/json"});
        Map data2 = jsonDecode(response.body);
        setState(() {
            if(data2["message"].toString() == "1") {
              Navigator.pop(context);
              setState(() {});
              return;
            } else {
              showFlushBar(context, "Mohon maaf.. Anda tidak bisa memakai promo ini");
              return;
            }
        });



  }



  @override
  Widget build(BuildContext context) {
          return WillPopScope(
            onWillPop: _onWillPop,
              child: Scaffold(
                appBar: new AppBar(
                  backgroundColor: Colors.white,
                  leading: Builder(
                    builder: (context) => IconButton(
                        icon: new Icon(Icons.arrow_back),
                        color: Colors.black,
                        onPressed: () => Navigator.pop(context)
                    ),
                  ),
                  title: new Text("Gunakan Promo",
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound', fontSize: 16)),
                ),
                body: Container(
                    child: FutureBuilder<List>(
                      future: getData(),
                      builder: (context, snapshot){
                        if (snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        } else {
                          return snapshot.data.length == 0 ?
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
                                        "Mohon maaf",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 22,fontWeight: FontWeight.bold),
                                      ),
                                      Padding(padding: const EdgeInsets.only(left: 25,right:25,top: 10),
                                        child: new Text(
                                          "Anda tidak tidak memliki promo yang bisa dipakai",
                                          style: new TextStyle(
                                              fontFamily: 'VarelaRound', fontSize: 12,height: 1.5),textAlign: TextAlign.center,
                                        ),)
                                    ],
                                  )))
                              :
                              ListView.builder(
                                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                padding: const EdgeInsets.only(top: 20,left: 15,right: 15),
                                itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: HexColor("#d6d7d9"),
                                                    width: 1
                                                )
                                            ),
                                            child: InkWell(
                                              onTap: (){
                                                  addPromo(snapshot.data[i]["c"].toString(),
                                                      snapshot.data[i]["d"].toString(),
                                                      snapshot.data[i]["e"].toString(),
                                                      snapshot.data[i]["f"].toString(),
                                                      snapshot.data[i]["a"].toString(),
                                                      snapshot.data[i]["g"].toString(),
                                                      snapshot.data[i]["i"].toString());
                                              },
                                              child: ListTile(
                                                title: Text(snapshot.data[i]["c"],
                                                  style: new TextStyle(
                                                      fontFamily: 'VarelaRound', fontSize: 15,
                                                      fontWeight: FontWeight.bold),),
                                                subtitle: Text("Berakhir pada : "+snapshot.data[i]["f"],
                                                    style: new TextStyle(
                                                        fontFamily: 'VarelaRound', fontSize: 11)) ,
                                              ),
                                            )
                                          ),
                                          Padding(padding: const EdgeInsets.only(bottom:15))
                                        ],
                                      );
                                },

                              );
                        }
                      },
                    )
                ),
              ),
          );
  }
}