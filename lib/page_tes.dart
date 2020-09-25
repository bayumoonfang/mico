import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:mico/doctor/pagedoktor_home.dart';
import 'dart:async';

import 'package:mico/mico_home.dart';


class TesPage extends StatefulWidget {
  @override
  _TesPageState createState() => _TesPageState();
}

class _TesPageState extends State<TesPage> {
  GifController controller1,controller2,controller3,controller4;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            "assets/loadingq.gif",
            width: 225.0,
          )
        ));
  }
}
