


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mico/helper/PageRoute.dart';
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

  String getColor = '1';
  String getFilter = 'DONE';
  Future<List> getData() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_appointment3&id=" +
            widget.getPhone+"&filter=" +
        getFilter);
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
        backgroundColor: HexColor("#f5f5f5"),
          appBar: new AppBar(
            bottomOpacity: 0.0,
            elevation: 0.0,
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
        body:
        Container(
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
                          color: getColor == '1' ? HexColor("#00b24e") : HexColor("#f7f7f7"),
                          child: Text("Selesai",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontWeight: FontWeight.bold,
                                  color: getColor == '1' ? HexColor("#ffffff") : HexColor("#9a9a9a")
                              )),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: ()async {
                            getColor = '1';
                            getFilter = 'DONE';
                            data.clear();

                          },
                        )
                    ),


                    Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: RaisedButton(
                          elevation: 0,
                          color: getColor == '2' ? HexColor("#ef6352") : HexColor("#f7f7f7"),
                          child: Text("Batal",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontWeight: FontWeight.bold,
                                  color: getColor == '2' ? HexColor("#ffffff") : HexColor("#9a9a9a")
                              )),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: ()async {
                            getColor = '2';
                            getFilter = 'DECLINE';
                            data.clear();

                          },
                        )
                    ),


                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Divider(
                  height: 4,
                ),
              ),

              Expanded(
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
                                    "Tidak ada history transaksi",
                                    style: new TextStyle(
                                        fontFamily: 'VarelaRound', fontSize: 18),
                                  ),
                                ],
                              ))
                              :
                          new ListView.builder(
                              padding: const EdgeInsets.only(top: 5.0,left: 10,right: 10,bottom: 10),
                              itemCount: data == null ? 0 : data.length,
                              itemBuilder: (context, i) {
                                        return InkWell(
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child :
                                                Card(
                                                  margin: const EdgeInsets.all(8),
                                                  color: HexColor("#f7f7f7"),
                                                    elevation: 0,
                                                child: ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage: AssetImage("assets/mira-ico.png") ,
                                                    radius: 20,
                                                    backgroundColor: Colors.white,
                                                  ),
                                                  title: Text(data[i]["f"],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color : Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'VarelaRound'),
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Opacity(
                                                          opacity: 0.9,
                                                          child: Text("Konsultasi "+data[i]["m"]+ " |  (" +data[i]["d"]+")",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color : HexColor("#686868"),
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'VarelaRound'),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  trailing:Text(data[i]["k"]+" "+new DateFormat.MMM().format(DateTime.parse(data[i]["l"]))+
                                                      " "+data[i]["i"].substring(2),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color : HexColor("#686868"),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'VarelaRound'),
                                                  ),

                                                )),
                                              ),
                                          onTap: (){
                                            Navigator.push(context, ExitPage(page: DetailAppointment(data[i]["a"].toString())));
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