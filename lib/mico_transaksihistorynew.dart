


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mico/user/mico_detailappointment.dart';
import 'dart:async';
import 'dart:convert';

import 'package:responsive_container/responsive_container.dart';


class TransaksiHistoryNew extends StatefulWidget {
  final String getPhone;
  const TransaksiHistoryNew(this.getPhone);
  @override
  _TransaksiHistoryNewState createState() => new _TransaksiHistoryNewState();

}


class _TransaksiHistoryNewState extends State<TransaksiHistoryNew> {


  List data;
  Future<List> getData() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_appointment3&id=" +
            widget.getPhone);
    setState((){
      data = json.decode(response.body);
    });
  }

  Future<void> _getData() async {
    setState(() {
      getData();
    });
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
            title: Text(
              "Activity History",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'VarelaRound', fontSize: 16),
            ),
          ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10),
                height: 30.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: RaisedButton(
                        elevation: 0,
                        color: HexColor("#f7f7f7"),
                        child: Text("Selesai",
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontWeight: FontWeight.bold,
                                color: HexColor("#00b250")
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: (){


                        },
                      )
                    ),

                    Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: RaisedButton(
                          elevation: 0,
                          color: HexColor("#f7f7f7"),
                          child: Text("Decline",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#FF4136")
                              )),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: (){


                          },
                        )
                    ),


                  ],
                ),
              ),


              ResponsiveContainer(
                widthPercent: 100,
                  heightPercent: 80,
                  margin: EdgeInsets.all(10.0),
                  child: new FutureBuilder<List>(
                      future: getData(),
                      builder : (context, snapshot) {
                        if (data == null) {
                          return Center(
                              child: Image.asset(
                                "assets/loadingq.gif",
                                width: 110.0,
                              )
                          );
                        } else {
                          return data.isEmpty
                              ?
                          Center(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    "Tidak ada Transaksi",
                                    style: new TextStyle(
                                        fontFamily: 'VarelaRound', fontSize: 18),
                                  ),
                                ],
                              ))
                              :
                          new ListView.builder(
                              padding: const EdgeInsets.only(top: 5.0),
                              itemCount: data == null ? 0 : data.length,
                              itemBuilder: (context, i) {
                                return
                                  InkWell(
                                    child :
                                    Padding (
                                        padding: const EdgeInsets.only(bottom: 10,left: 5,right: 5),
                                        child : Card(
                                            child :
                                            Column(
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets.only(bottom: 5),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: <Widget>[
                                                          Expanded(
                                                              child :
                                                              Container (
                                                                  color : data[i]["c"] == 'DECLINE' ? HexColor("#fdebeb") : HexColor("#f2fef2"),
                                                                  child :
                                                                  Center(
                                                                      child : Padding(
                                                                          padding : const EdgeInsets.all(10),
                                                                          child : Text(data[i]["c"] == 'DECLINE' ? "Dibatalkan" : "Selesai",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color : HexColor("#756b6a"),
                                                                                fontFamily: 'VarelaRound'),)
                                                                      )
                                                                  )
                                                              ))

                                                        ],
                                                      )
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10,bottom: 5,left: 15),
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(data[i]["k"]+ " - "+ new DateFormat.MMM().format(DateTime.parse(data[i]["l"]))
                                                          + " - "+ data[i]["i"] + " (" +data[i]["d"]+")",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color : HexColor("#756b6a"),
                                                            fontFamily: 'VarelaRound'),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5,left: 15),
                                                    child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Opacity(
                                                          opacity: 0.7,
                                                          child: Text(data[i]["b"],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color : Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'VarelaRound'),
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.only(bottom: 5,top: 10 ),
                                                      child: Divider(
                                                        height: 5,
                                                        thickness: 2.0,
                                                      )
                                                  ),
                                                  Padding (
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundColor: Colors.white,
                                                          backgroundImage: AssetImage("assets/mira-ico.png"),
                                                          radius: 30,
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text("Konsultasi "+data[i]["m"],
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      color : Colors.black,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontFamily: 'VarelaRound')),
                                                            ),
                                                            Padding (
                                                                padding: const EdgeInsets.only(top:5),
                                                                child : Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Opacity(
                                                                      opacity: 0.5,
                                                                      child: Text(data[i]["f"],
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color : Colors.black,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'VarelaRound')),
                                                                    )
                                                                )
                                                            ),

                                                            Padding (
                                                                padding: const EdgeInsets.only(top:15),
                                                                child : Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Opacity(
                                                                      opacity: 0.5,
                                                                      child: Text("Kode Transaksi",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color : Colors.black,
                                                                              fontFamily: 'VarelaRound')),
                                                                    )
                                                                )
                                                            ),

                                                            Padding (
                                                                padding: const EdgeInsets.only(top:2,bottom: 5),
                                                                child : Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Opacity(
                                                                      opacity: 0.5,
                                                                      child: Text(data[i]["n"] == null ? "-" : data[i]["n"] ,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color : Colors.black,
                                                                              fontFamily: 'VarelaRound')),
                                                                    )
                                                                )
                                                            )


                                                          ],
                                                        )
                                                    ),),

                                                  Padding(
                                                      padding: const EdgeInsets.only(bottom: 5,top: 10 ),
                                                      child: Divider(
                                                        height: 5,
                                                        thickness: 2.0,
                                                      )
                                                  ),
                                                  Padding (
                                                      padding: const EdgeInsets.only(top:2,left: 93),
                                                      child : Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Opacity(
                                                            opacity: 0.5,
                                                            child: Text("Total Pembayaran" ,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color : Colors.black,
                                                                    fontFamily: 'VarelaRound')),
                                                          )
                                                      )
                                                  ),

                                                  Padding (
                                                      padding: const EdgeInsets.only(top:5,bottom: 15, left: 93),
                                                      child : Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                            data[i]["o"] == null ? "-" : data[i]["o"] == 0 ? "Gratis" :
                                                            "Rp. " +NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(data[i]["o"].toString())) ,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color : data[i]["o"] == 0 ? Colors.green : Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'VarelaRound')),

                                                      )
                                                  )



                                                ]
                                            )
                                        )),
                                    onTap: () {
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) => DetailAppointment(data[i]["a"].toString())));

                                    },
                                  );
                              }
                          );
                        }
                      }
                  )
              )



            ],
          ),
        ),
      );
  }
}