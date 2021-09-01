


import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/helper/session_user.dart';

class AppHelper{

/*
A. How to Use SnackBar=====

Function====================================================
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context, String stringme) {
    final snackBar = SnackBar(content: Text(stringme));
    _scaffoldKey.currentState.showSnackBar(snackBar); }
============================================================

To Use======================================================
_displaySnackBar(context, "Form Tidak Boleh Kosong");
===============================================================

 */

  Future<String> getConnect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        return "ConnInterupted";
      }
    });
  }

  Future<dynamic> getSession () async {
    int value = await Session.getValue();
    String getEmail = await Session.getEmail();
    String getPhone = await Session.getPhone();
    String getBasedLogin = await Session.getBasedLogin();
    return [value,getEmail,getPhone,getBasedLogin];
  }




}