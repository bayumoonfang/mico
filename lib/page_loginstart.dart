import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:mico/helper/session_user.dart';
import 'package:mico/page_login.dart';


class LoginStart extends StatefulWidget {
  @override
  _LoginStartState createState() => new _LoginStartState();
}

class _LoginStartState extends State<LoginStart> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Container(
            color: Colors.white,
            child :
            Center(
              child: Image.asset(
                "assets/logo.png",
                width: 200,
                height: 100,
              ),
            )
        ),

        bottomSheet: new
        Container(
            color: Colors.white,
            child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0, top: 10),
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: HexColor("#8cc63e"),
                        child: Text(
                          "Login As Customer",
                          style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: HexColor("#8cc63e"),
                          ),
                        ),
                        onPressed: () =>  Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) => Login())),
                      )
                  )

                  /*
                  Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0,top: 10 ),
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.black,
                        child: Text(
                          "Login As Doctor ",
                          style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => LoginDoctor()));
                        },
                      )
                  ),*/



                ])
        ));
  }
}