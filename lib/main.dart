import 'package:flutter/material.dart';
import 'package:mico/SplashScreen.dart';
import 'package:mico/mico_home.dart';
import 'package:mico/page_loginstart.dart';
import 'package:mico/page_login.dart';
import 'package:mico/page_verifikasilogin.dart';
import 'file:///D:/PROJECT%20KANTOR/mico/backup/page_chatroomprepare.dart';

import 'file:///D:/PROJECT%20KANTOR/mico/lib/backup/mico_historytransaksi_BACKUP.dart';
import 'package:mico/utils/page_tespertama.dart';

//import 'package:miracle/chatroom.dart';
//import 'package:miracle/services/chatroom_fix.dart';
//import 'package:miracle/home.dart';
//import 'package:miracle/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreenPage(),
      //home : Login()
    );
  }
}
