import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';
import 'package:mico/pagelist_dokter.dart';
import 'package:http/http.dart' as http;
import 'package:mico/services/page_chatroom.dart';
import 'package:mico/services/page_chatroomprepare.dart';


class Pembayaran extends StatefulWidget {
  final String iddokter;
  final String namaKlinik, namaDokter;



  const Pembayaran(this.iddokter, this.namaKlinik, this.namaDokter);
  @override
  _PembayaranState createState() => new _PembayaranState(
      getDokter: this.iddokter,
      getKlinik: this.namaKlinik,
      getNamaDokter: this.namaDokter);
}

class _PembayaranState extends State<Pembayaran> {
  String getKlinik;
  String getDokter, getNamaDokter, getAcc;

  _PembayaranState({this.getDokter, this.getKlinik, this.getNamaDokter});
  List data;
  String getChatStatus, getVideoStatus;

  _session() async {
    int value = await Session.getValue();
    getAcc = await Session.getPhone();
    if (value != 1) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }

_cekroomchat() async {
  final response = await http.post(
      "https://duakata-dev.com/miracle/api_script.php?do=act_cekroomchat",
      body: {"idcust": getAcc});
  Map data = jsonDecode(response.body);
  setState(() {
    getChatStatus = data["message"].toString();
    //getVideoStatus = data2["message"].toString();
  });

}

  void _cekroom() async {
    await _session();
    await _cekroomchat();
  }

  @override
  void initState() {
    super.initState();
    _cekroom();
  }



  Future<List> getDataDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_dokterdetail&id=" +
            getDokter);
    if (response.body.isNotEmpty) {
      return json.decode(response.body);
    } else {
      //Widget.of(context).showSnackBar(SnackBar(content: Text('Empty Data')));
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


void _doChat() {
  Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => ChatRoomPrepare(
          widget.iddokter,
          widget.namaDokter,
          widget.namaKlinik,
      getAcc)));
}

  void _doAskChat() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Text(
                "Apakah anda yakin untuk melakukan konsultasi chat dengan dokter ini  ?",
                style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18)),
            actions: [
              new FlatButton(
                  onPressed: () {
                    _doChat();
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





  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            backgroundColor: Hexcolor("#075e55"),
            title: Text(
              "Detail Dokter",
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
          body: new FutureBuilder<List>(
            future: getDataDetail(),
            builder: (context, snapshot) {
            if (snapshot.data == null) {
                    return Center(
                          child: Image.asset(
                          "assets/loadingq.gif",
                          width: 180.0,
                          )
                    );
            } else {
      return ListView.builder(
          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          itemBuilder: (context, i) {
            return Padding(
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                      child:
                      CachedNetworkImage(
                        imageUrl:
                        "http://duakata-dev.com/miracle/media/photo/" +
                            snapshot.data[i]["c"],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                        imageBuilder: (context, image) =>
                            CircleAvatar(
                              backgroundImage: image,
                              radius: 60,
                            ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15.0, right: 15.0),
                      child: Divider(height: 3.0)),
                  Padding(padding: const EdgeInsets.only(top: 30)),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Nama",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text(snapshot.data[i]["a"],
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14)),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15),
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
                                fontSize: 14),
                          ),
                          Text(snapshot.data[i]["e"],
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14)),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Lokasi Praktik",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text(snapshot.data[i]["b"],
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14)),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 40),
                    child: Text("Harga Konsultasi",
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 20, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Jenis Layanan",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text("Online Service",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14)),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Konsultasi Chat (15 Menit)",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text("Rp. 0",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14)),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Konsultasi Video (15 Menit)",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14),
                          ),
                          Text("Rp. 0",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14)),
                        ],
                      )),
                ],
              ),
            );
          });
    }
            },
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
                    getChatStatus == '1' ?
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        //side: BorderSide(color: Colors.red)
                      ),
                      child: Text(
                        "Chat",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 12,
                        ),
                      ),
                    )
                        :
                    OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          side: BorderSide(color: Colors.black)
                        ),
                        child: Text(
                          "Chat",
                          style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 12,
                          ),
                        ),
                        onPressed: () {
                _doAskChat();
                        }
                    )

                  )
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 15.0, bottom:10),
                      child:
                      getChatStatus == '1' ?
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          //side: BorderSide(color: Colors.red)
                        ),
                          child: Text(
                            "Video",
                            style: TextStyle(
                                fontFamily: 'VarelaRound', fontSize: 12),
                          ),
                      )
                          :
                      OutlineButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: Colors.black)
                          ),
                          child: Text(
                            "Video",
                            style: TextStyle(
                                fontFamily: 'VarelaRound', fontSize: 12),
                          ),
                          onPressed: () {
                          /*  Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    VideoChatHome(widget.iddokter)));*/
                              }
                          )

                  )),
            ],
          )),
        ),
        onWillPop: _onWillPop);
  }
}
