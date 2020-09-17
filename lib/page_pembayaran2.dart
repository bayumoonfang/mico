


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CekPembayaran extends StatefulWidget{
  final String idJadwal, idUser, idDokter, idNamaDokter, idKlinik;
  const CekPembayaran(this.idJadwal, this.idUser, this.idDokter, this.idNamaDokter, this.idKlinik);
  @override
  _cekPembayaranState createState() => _cekPembayaranState(
      getIDJadwal: this.idJadwal,
      getUser: this.idUser,
      getDokter: this.idDokter,
      getNamaDokter: this.idNamaDokter,
      getKlinik: this.idKlinik
  );
}


class _cekPembayaranState extends State<CekPembayaran> {
  String
  getIDJadwal,
      getUser,
      getDokter,
      getNamaDokter,
      getKlinik = "";
  String _valGender;
  List _myFriends = [
    "Konsultasi Chat",
    "Konsultasi Video Call",
  ];


  @override
  void initState() {
    super.initState();

  }


  _cekPembayaranState({
    this.getIDJadwal,
    this.getUser,
    this.getDokter,
    this.getNamaDokter,
    this.getKlinik});
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Hexcolor("#075e55"),
          title: Text(
            "Pembayaran",
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
            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 25),
                  child: Text("Jenis Konsultasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14)),
                ),
Padding (
  padding: const EdgeInsets.only(left: 25),
  child :
                  DropdownButton(
                    hint: Text("Pilih Jenis Konsultasi"),
                    value: _valGender,
                    items: _myFriends.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valGender = value;  //Untuk memberitahu _valGender bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                      });
                    },

                )),
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child : Divider(
                    height: 2,
                  )
                )
              ],
            )



        ,
      ),

    );
  }

}