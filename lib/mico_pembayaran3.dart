


import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:responsive_container/responsive_container.dart';


class CekPembayaran2 extends StatefulWidget{
  final String idJadwal, idUser, idDokter, idTotal, idLayanan;
  const CekPembayaran2(this.idJadwal, this.idUser, this.idDokter, this.idTotal, this.idLayanan);
  @override
  _cekPembayaran2State createState() => _cekPembayaran2State(
      getIDJadwal: this.idJadwal,
      getUser: this.idUser,
      getDokter: this.idDokter,
      getTotal : this.idTotal,
      getLayanan : this.idLayanan
  );
}


class _cekPembayaran2State extends State<CekPembayaran2> {
  String
  getIDJadwal,
      getUser,
      getDokter,
      getNamaDokter,
      getKlinik,
      getTotal,
      getPhoto,
      getLayanan = "";

  _cekPembayaran2State({
    this.getIDJadwal,
    this.getUser,
    this.getDokter,
    this.getTotal,
    this.getLayanan});

  List data;

  Future<List> getData_rekening() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://duakata-dev.com/miracle/api_script.php?do=getdata_rekening"),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }


  @override
  void initState() {
    super.initState();
      getData_rekening();
  }

  int _selectedIndex = 100;
  int _isButtonDisabled = 0;
  String _getPembayaran = "";


  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _isButtonDisabled = 1;
    });
  }

  _onButton(int index) {
    setState(() => _isButtonDisabled = index);
  }



  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          backgroundColor: HexColor("#075e55"),
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
        SingleChildScrollView(
    child :
         Container(
          child : Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding : const EdgeInsets.only(bottom: 5),
                child: Center(
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2.0,
                                  offset: Offset(0.0, 0.10)
                              )
                            ],
                            color: HexColor("#ffffff"),
                        ),
                        //color : Hexcolor("#ffffff"),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 15  ,right: 25,top: 15,bottom: 15),
                            child:
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [

                                      Text("Bayar",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: HexColor("#516067"),
                                            fontFamily: 'VarelaRound'),textAlign: TextAlign.left,),

                                      Text("Rp. "+ NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(widget.idTotal)),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: HexColor("#516067"),
                                            fontFamily: 'VarelaRound',fontWeight: FontWeight.bold), textAlign: TextAlign.right,),

                                ],
                              )
                        )
                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15,top: 10),
                child:
                Align(
                  alignment: Alignment.centerLeft,
                  child :
                Text("Bank Pembayaran",
                  style: TextStyle(
                      fontSize: 14,
                      color: HexColor("#516067"),
                      fontFamily: 'VarelaRound'))
                ),
              ),
                ResponsiveContainer (
                  padding: const EdgeInsets.only(left: 10,top: 5),
                        heightPercent: 100,
                        widthPercent: 100,
                        child :
                      _getData()
                    ,
                )
            ],
          )
        )),

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
                      _isButtonDisabled == 0 ?
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          //side: BorderSide(color: Colors.red)
                        ),
                        child: Text(
                          "Bayar",
                          style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 14,
                          ),
                        ),
                      )
                          :

                      RaisedButton(
                        color:  HexColor("#075e55"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          //side: BorderSide(color: Colors.red, width: 2.0)
                        ),
                        child: Text(
                          "Bayar",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14,
                              color: Colors.white
                          ),
                        ),
                        onPressed: () {

                        },
                      ),



                    ))

              ],
            )),
      ),

    );
  }


  Widget _getData() {
    return FutureBuilder<List>(
        future: getData_rekening(),
        builder: (context, snapshot){
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
                  return
                      Padding(
                          padding: const EdgeInsets.only(top: 10, right: 15),
                          child :

                              InkWell(
                          child :
                          _selectedIndex == i && _selectedIndex != 200  && _selectedIndex != null ?
                                 Card (
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(15.0),
                                       side: new BorderSide(color: HexColor("#075e55"), width: 2.0),
                                     ),
                                     child :
                                     ListTile(
                                    title:
                                    Padding(
                                        padding: const EdgeInsets.only(top:10),
                                        child :
                                            Text(data[i]["d"],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'VarelaRound')),
                                            ),
                                            subtitle:
                                            Column(
                                            children: [
                                              Align(
                                              alignment: Alignment.centerLeft,
                                              child :
                                              Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child :
                                                      Text("a.n " +data[i]["c"],
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)
                                                     )
                                              ),
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child :
                                                  Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child :
                                                      Text(data[i]["e"],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:10)
                                              )
                                            ],
                                        ),
                                )
                              )

                          :
                          Card (
                              child :
                              ListTile(
                                title:
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child :
                                  Text(data[i]["d"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'VarelaRound')),
                                ),
                                subtitle:
                                Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child :
                                        Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child :
                                            Text("a.n " +data[i]["c"],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child :
                                        Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child :
                                            Text(data[i]["e"],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontFamily: 'VarelaRound'),textAlign: TextAlign.left,)
                                        )
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top:10)
                                    )
                                  ],
                                ),
                              )
                          ),

                              onTap: (){
                                    setState(() {
                                        _onSelected(i);
                                        _isButtonDisabled = 1;
                                        //_valBank = data[i]["a"].toString();
                                    });
                              }),





                    );
                }
              }
          );
        }
    );
  }

}