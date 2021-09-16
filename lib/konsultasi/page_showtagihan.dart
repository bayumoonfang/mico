



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mico/page_home.dart';

class ShowTagihan extends StatefulWidget{
  final String getTotal;
  const ShowTagihan(this.getTotal);
  @override
  _ShowTagihan createState() => _ShowTagihan();
}



class _ShowTagihan extends State<ShowTagihan> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context, String stringme) {
    final snackBar = SnackBar(content: Text(stringme));
    _scaffoldKey.currentState.showSnackBar(snackBar); }

  String nomorRekening = "081938548797";
  @override
  Widget build(BuildContext context) {
        return WillPopScope(
            child: Scaffold(
              key: _scaffoldKey,
              appBar: new AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(
                          builder: (BuildContext context) => Home()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20,top: 15),
                      child: FaIcon(FontAwesomeIcons.timesCircle,color: Colors.black,
                      size: 22,),
                    ),
                  )
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Tagihan Anda",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',)),
                    Padding(padding: const EdgeInsets.only(top: 10),
                    child: Text("Rp "+NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(int.parse(widget.getTotal)),
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 44)
                        ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        child: RaisedButton(
                          elevation: 0,
                          child: Text("Salin Nominal",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'VarelaRound',)),
                          onPressed: (){
                            Clipboard.setData(new ClipboardData(text: widget.getTotal)).then((_){
                              _displaySnackBar(context, "Nominal berhasil disalin");
                            });
                          },
                        ),
                      )
                    ),


                    Padding(padding: const EdgeInsets.only(top: 10),
                      child: Text("(Mohon melakukan pembayaran senilai yang tertera)",
                          style: TextStyle(
                            fontSize: 12,
                              fontFamily: 'VarelaRound',)
                      ),
                    ),

                    Padding(
                      padding: const  EdgeInsets.only(top: 20,left: 25,right: 25),
                      child: Divider(height: 5,color: Colors.black,),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 30),
                      child: Text("Pembayaran menggunakan",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'VarelaRound',)
                      ),
                    ),



                    Padding(padding: const EdgeInsets.only(top: 10),
                      child: Image.asset("assets/ovo.png",width: 70,)
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10),
                      child: Text(nomorRekening,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'VarelaRound',)
                      ),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Salin Nomor Rekening",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'VarelaRound',)),
                            onPressed: (){
                              Clipboard.setData(new ClipboardData(text: widget.getTotal)).then((_){
                                _displaySnackBar(context, "Nomor Rekening berhasil disalin");
                              });
                            },
                          ),
                        )
                    ),
                    


                  ],
                ),
              ),
            ),
        );
  }
}