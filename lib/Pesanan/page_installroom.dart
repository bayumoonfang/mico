


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mico/page_homenew.dart';

class InstallRoom extends StatefulWidget{

  @override
  _InstallRoom createState() => _InstallRoom();
}


class _InstallRoom extends State<InstallRoom> {


  Future<bool> _onWillPop() async {

  }



  Timer mytimer;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => PageHomeNew()));
      });
    });
  }



  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onWillPop,
          child: Scaffold(
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Center(
                   child:       SizedBox(
                     child: CircularProgressIndicator(),
                     height:100,
                     width: 100,
                   ),
                 ),
                  Center(
                    child: Padding(padding: const EdgeInsets.only(top: 40),
                    child: Text("Mohon menunggu sebentar",style: GoogleFonts.varelaRound(fontSize: 18,fontWeight: FontWeight.bold),),),
                  ),
                  Center(
                    child: Padding(padding: const EdgeInsets.only(top: 10),
                      child: Text("Sedang mengkonfirmasi pembayaran kamu",style: GoogleFonts.varelaRound(fontSize: 15),),),
                  )


                ],
              ),
            ),
          )
      );

  }
}