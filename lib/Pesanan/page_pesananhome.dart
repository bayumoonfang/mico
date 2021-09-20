


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mico/Pesanan/page_detailtagihan.dart';
import 'package:mico/helper/app_helper.dart';
class PesananHome extends StatefulWidget {
  final String getPhone;

  const PesananHome(this.getPhone);
  @override
  _PesananHome createState() => _PesananHome();
}



class _PesananHome extends State<PesananHome> {
  TabController controller;
  List data;

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  String getFilter = "";
  Future<List> getDataTagihan() async {
    http.Response response = await http.get(
        Uri.encodeFull(AppHelper().applink+"do=getdata_tagihanlist&filter="+getFilter+"&userapp="+widget.getPhone.toString()+""),
        headers: {"Accept":"application/json"}
    );
    return json.decode(response.body);
  }


  Future<void> refreshTagihan() async {
    setState(() {
      getDataTagihan();
    });
  }


  @override
  void initState(){

    super.initState();
  }





  @override
  Widget build(BuildContext context) {
      return DefaultTabController(
          length: 1,
          child: WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: new AppBar(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  title: Text(
                    "Pesanan",
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
                  bottom: TabBar(
                    labelColor: Colors.black,
                    onTap: (index) {
                      // Tab index when user select it, it start from zero
                    },
                    tabs: [
                      Tab(text: "Tagihan",),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    _view_tab1()
                  ],
                ),
              )
          )
      );
  }

  Widget _view_tab1() {
        return Container(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 15,
                  right: 15,top: 15),
                  child: Container(
                    height: 38,
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      onChanged: (text) {
                        setState(() {
                          //getFilter = text;
                          //_isvisible = false;
                          //startSCreen();
                        });
                      },
                      style: TextStyle(fontFamily: "VarelaRound",fontSize: 14),
                      decoration: new InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: HexColor("#f4f4f4"),
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.search,size: 14,
                            color: HexColor("#6c767f"),),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white,
                            width: 1.0,),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#f4f4f4"),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Cari Tagihan...',
                      ),
                    ),
                  )
              ),

                      Expanded(
                        child: FutureBuilder<List> (
                            future: getDataTagihan(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                    child: CircularProgressIndicator()
                                );
                              } else {
                                return snapshot.data.length == 0 ?
                                Container(
                                    height: double.infinity, width : double.infinity,
                                    padding: const EdgeInsets.only(top: 30),
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
                                                "Saat ini tidak ada dokter yang sedang online, mohon mencoba beberapa saat lagi",
                                                style: new TextStyle(
                                                    fontFamily: 'VarelaRound', fontSize: 12,height: 1.5),textAlign: TextAlign.center,
                                              ),)
                                          ],
                                        )))
                                    :

                                    RefreshIndicator(
                                        onRefresh: refreshTagihan,
                                      child: ListView.builder(
                                        itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                        itemBuilder: (context, i) {
                                              return Column(
                                                children: [
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.of(context).push(new MaterialPageRoute(
                                                            builder: (BuildContext context) => DetailTagihan(snapshot.data[i]["b"])));
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                                        child: Card(
                                                          elevation: 2,
                                                          child: ListTile(
                                                            title: Padding(padding:
                                                                  const EdgeInsets.only(top:10),
                                                              child: Row(
                                                                children: [
                                                                  Text(snapshot.data[i]["b"],style: GoogleFonts.varelaRound(fontSize: 15,
                                                                      fontWeight: FontWeight.bold),),
                                                                  Text(" - "+snapshot.data[i]["d"],style: GoogleFonts.varelaRound(fontSize: 12,),),
                                                                ],
                                                              )
                                                            ),
                                                            subtitle: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 5),
                                                                  child: Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text("Pembayaran Layanan Konsultasi "+snapshot.data[i]["e"]+"",
                                                                      style: GoogleFonts.varelaRound(fontSize: 13,color: Colors.black),),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 5,bottom: 10),
                                                                  child: Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Container(
                                                                      height: 24,
                                                                      child: RaisedButton(
                                                                        child: Text(
                                                                          snapshot.data[i]["f"] == 'OPEN' ?
                                                                          "Belum Dibayar" : snapshot.data[i]["f"]
                                                                          ,style: TextStyle(
                                                                            fontSize: 12
                                                                        ),),
                                                                        onPressed: (){},
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    )
                                                ],
                                              );
                                        },
                                      ),

                                    );
                              }
                            },
                        )
                      )
            ],
          ),

        );
  }


}