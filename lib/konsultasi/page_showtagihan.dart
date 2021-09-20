



import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/page_home.dart';
import 'package:http/http.dart' as http;
import 'package:mico/page_homenew.dart';


class ShowTagihan extends StatefulWidget{
  final String getTotal, getInvNumber;
  const ShowTagihan(this.getTotal, this.getInvNumber);
  @override
  _ShowTagihan createState() => _ShowTagihan();
}



class _ShowTagihan extends State<ShowTagihan> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context, String stringme) {
    final snackBar = SnackBar(content: Text(stringme));
    _scaffoldKey.currentState.showSnackBar(snackBar); }


  String getInvoiceNumber, getPembayaran, getNoPembayaran, getPembayaranImg = "...";
  _getInvoiceDetail() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_invoicedetail&id="+widget.getInvNumber,
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      getInvoiceNumber = data["d"].toString();
      getPembayaran = data["a"].toString();
      getNoPembayaran = data["b"].toString();
      getPembayaranImg = data["c"].toString();
    });
  }

  bool _isVisible = false;
  startSplashScreen() async {
    _isVisible = false;
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  Future<bool> _onWillPop() async {

  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
     _getInvoiceDetail();

  }


  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: new AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(
                          builder: (BuildContext context) => PageHomeNew()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20,top: 15),
                      child: FaIcon(FontAwesomeIcons.timesCircle,color: Colors.black,
                      size: 22,),
                    ),
                  )
                ],
              ),
              body:

              _isVisible == false ?
              Center(
                  child: CircularProgressIndicator()
              )

                  :
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Tagihan anda",
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
                      child: CachedNetworkImage(
                        width: 70,
                        imageUrl: AppHelper().applinksource+"media/pembayaran/"+getPembayaranImg.toString(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10),
                      child: Text(getNoPembayaran.toString(),
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