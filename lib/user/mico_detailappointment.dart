
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/services/mico_chatroom.dart';
import 'package:mico/user/mico_detailtagihan.dart';
import 'package:mico/user/mico_prepareroom.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:steps/steps.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class DetailAppointment extends StatefulWidget {
  final String idAppointment;
  const DetailAppointment(this.idAppointment);
  @override
  _DetailAppointmentState createState() => new _DetailAppointmentState();
}



class _DetailAppointmentState extends State<DetailAppointment> {
  List data;
  Widget _createEventControlBuilder(BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

        ]
    );
  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future<List> getDetailJadwal() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_appointment2&id=" +
            widget.idAppointment);
    setState(() {
      data =  json.decode(response.body);
    });
  }

  String getStatus = "...";
  _getDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_app2&id=" +
            widget.idAppointment);
    Map data = jsonDecode(response.body);
    setState(() {
      getStatus = data["a"].toString();
    });
  }



  void _cancelAppointment() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Text(
                "Apakah anda yakin untuk membatalkan appointment ini  ?",
                style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18)),
            actions: [
              new FlatButton(
                  onPressed: () {
                    _doCancelAppointment();
                  },
                  child:
                  Text("Iya", style: TextStyle(fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18))),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                  Text("Tidak", style: TextStyle(fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18)))
            ],
          );
        });
  }



  void _doCancelAppointment() async {
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=cancel_appointment",
        body: { "id": widget.idAppointment});
    Map showdata = jsonDecode(response.body);
    setState(() {
      String getMessage = showdata["message"].toString();
      if (getMessage == '0') {
        showToast("Appointment gagal dibatalkan..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.pop(context);
        return false;
      } else{
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => Home()));
      }
    });



  }


  @override
  void initState() {
    super.initState();
    _getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Hexcolor("#075e55"),
        title: Text(
          "Detail Appointment",
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
      body:
      ResponsiveContainer(
          widthPercent: 100,
          heightPercent: 100,
          child :
          new FutureBuilder<List>(
            future: getDetailJadwal(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, i) {
                  if (data == null) {
                    return Center(
                        child: Image.asset(
                          "assets/loadingq.gif",
                          width: 180.0,
                        )
                    );
                  } else {
                    return SingleChildScrollView(
                        child:
                        Column(
                          children: [
                            Container(
                                child:
                                Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 20),
                                        child: Align(
                                            alignment: Alignment
                                                .centerLeft,
                                            child: Text(
                                                "Detail Appointment",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .bold,
                                                    fontFamily: 'VarelaRound'))
                                        )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 15,
                                          top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            "Kode",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'VarelaRound',
                                                fontSize: 14),
                                          ),
                                          Text(data[i]["b"],
                                              style: TextStyle(
                                                  fontFamily: 'VarelaRound',
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 15,
                                          top: 5, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            "Tanggal Appointment",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'VarelaRound',
                                                fontSize: 14),
                                          ),
                                          Text( data[i]["k"]+ " - "+ new DateFormat.MMM().format(DateTime.parse(data[i]["l"]))
                                              + " - "+ data[i]["i"] + " (" +data[i]["d"]+")",
                                              style: TextStyle(
                                                  fontFamily: 'VarelaRound',
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ],
                                )

                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Container(
                                color: Hexcolor("#DDDDDD"),
                                width: double.infinity,
                                height: 10,
                              ),
                            ),
                            ResponsiveContainer(
                              widthPercent: 100,
                              heightPercent: 85,
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 120),
                              child:
                              Steps(
                                direction: Axis.vertical,
                                size: 10.0,
                                path: {
                                  'color': Hexcolor("#DDDDDD"),
                                  'width': 1.0
                                },
                                steps: [
                                  {
                                    'background':
                                    data[i]["c"] == 'ON REVIEW' ?
                                    Hexcolor("#DDDDDD") : Colors.green,
                                    'label': '',
                                    'content':
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 10),
                                                child:
                                                Text(
                                                  'Waiting Approval',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Hexcolor(
                                                          "#516067"),
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontFamily: 'VarelaRound'),
                                                )),
                                            Text(
                                                'Status appointment anda sekarang adalah masih menunggu approval dari dokter',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor(
                                                        "#516067"),
                                                    fontFamily: 'VarelaRound')
                                            ),
                                          ],
                                        )
                                    ),
                                  },

                                  data[i]["c"] == 'DECLINE' ?
                                  {
                                    'background': Colors.red,
                                    'label': '',
                                    'content':
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 10),
                                                child:
                                                Text(
                                                  'Appointment Rejected',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Hexcolor(
                                                          "#516067"),
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontFamily: 'VarelaRound'),
                                                )),
                                            Text(
                                                'Mohon maaf appointment anda telah dibatalkan',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor(
                                                        "#516067"),
                                                    fontFamily: 'VarelaRound')
                                            ),
                                          ],
                                        )
                                    ),
                                  }
                                      :

                                  {
                                    'background': (data[i]["c"] == 'ACCEPT' || data[i]["c"] == 'PAID' || data[i]["c"] == 'DONE') ?
                                    Colors.green : Hexcolor("#DDDDDD") ,
                                    'label': '',
                                    'content':
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 10),
                                                child:
                                                Text(
                                                  'Appointment Approved',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Hexcolor(
                                                          "#516067"),
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontFamily: 'VarelaRound'),
                                                )),
                                            Text(
                                                'Status appointment anda sekarang adalah sudah mendapat approval dari dokter',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor(
                                                        "#516067"),
                                                    fontFamily: 'VarelaRound')
                                            ),
                                          ],
                                        )
                                    ),
                                  },
                                  {
                                    'background': (data[i]["c"] == 'ACCEPT' || data[i]["c"] == 'PAID' || data[i]["c"] == 'DONE') ?
                                    Colors.green : Hexcolor("#DDDDDD") ,
                                    'label': '',
                                    'content':
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 10),
                                                child:
                                                Text(
                                                  'Menunggu Pembayaran',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Hexcolor(
                                                          "#516067"),
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontFamily: 'VarelaRound'),
                                                )),
                                            Text(
                                                'Status appointment anda adalah Menunggu Pembayaran , '
                                                    'silahkan melakukan pembayaran ke rekening sesuai tagihan yang kami kirimkan. Jika sudah melakukan pembayaran silahkan melakukan konfirmasi dibawah ini',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor(
                                                        "#516067"),
                                                    fontFamily: 'VarelaRound')
                                            ),


                                            RaisedButton(
                                              color:  Hexcolor("#075e55"),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              child: Text(
                                                "Detail Tagihan",
                                                style: TextStyle(
                                                    fontFamily: 'VarelaRound',
                                                    color: Colors.white
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => DetailTagihan(data[i]["b"])));
                                              },)

                                          ],
                                        )
                                    ),
                                  },


                                  {
                                    'background': (data[i]["c"] == 'PAID' || data[i]["c"] == 'DONE') ?
                                    Colors.green : Hexcolor("#DDDDDD"),
                                    'label': '',
                                    'content':
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 10),
                                                child:
                                                Text(
                                                  'Pembayaran Terverifikasi',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Hexcolor(
                                                          "#516067"),
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontFamily: 'VarelaRound'),
                                                )),
                                            Text(
                                                'Terima Kasih telah melakukan pembayaran, anda dapat langsung melakukan konsultasi dengan dokter',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor(
                                                        "#516067"),
                                                    fontFamily: 'VarelaRound')
                                            ),
                                          ],
                                        )
                                    ),
                                  },


                                  {
                                    'background': (data[i]["c"] == 'PAID' || data[i]["c"] == 'DONE') ?
                                    Colors.green : Hexcolor("#DDDDDD"),
                                    'label': '',
                                    'content':
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 10),
                                                child:
                                                Text(
                                                  'Konsultasi Berjalan',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Hexcolor(
                                                          "#516067"),
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontFamily: 'VarelaRound'),
                                                )),
                                            Text(
                                                'Anda bisa masuk ke room konsultasi dengan klik button yang ada dibawah ini .',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor(
                                                        "#516067"),
                                                    fontFamily: 'VarelaRound')
                                            ),
                                            data[i]["c"] == 'PAID' ?
                                            RaisedButton(
                                              color:  Hexcolor("#075e55"),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              child: Text(
                                                "Mulai Konsultasi",
                                                style: TextStyle(
                                                    fontFamily: 'VarelaRound',
                                                    color: Colors.white
                                                ),
                                              ),
                                              onPressed: () {
                                                (data[i]["n"] == '' || data[i]["n"] == null) ?
                                                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                                    builder: (BuildContext context) => PrepareRoomCreate(data[i]["b"])))
                                                    :
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => Chatroom(data[i]["b"],'2')));

                                              },)
                                                :
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                child: Text("Mulai Konsultasi"))
                                          ],
                                        )
                                    ),
                                  },

                                  {
                                    'background': data[i]["c"] != 'DONE' ?
                                    Hexcolor("#DDDDDD") : Colors.green,
                                    'label': '',
                                    'content':
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 10),
                                                child:
                                                Text(
                                                  'Selesai',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Hexcolor(
                                                          "#516067"),
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontFamily: 'VarelaRound'),
                                                )),
                                            Text(
                                                'Terima Kasih telah menggunakan layanan konsultasi online Miracle.',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Hexcolor(
                                                        "#516067"),
                                                    fontFamily: 'VarelaRound')
                                            ),
                                          ],
                                        )
                                    ),
                                  },


                                ],
                              ),
                            )


                          ],
                        )
                    );
                  }
                },
              );
            },

          )
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


                      getStatus == "ON REVIEW" ?
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.red)
                        ),
                        child: Text(
                          "Cancel Appointment",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14,
                              color: Colors.white
                          ),
                        ),
                        onPressed: (){
                          _cancelAppointment();
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
                              getStatus.toString(),
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14,
                                  color: Colors.black
                              ),
                            ),
                          ))



                  ))

            ],
          )),
    );
  }
}