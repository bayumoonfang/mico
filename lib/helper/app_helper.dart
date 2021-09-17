


import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/helper/session_user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


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

  String main_color = '#602d98';
  String second_color = "#4e2986";
  String third_color = "#594d75";
  String fourth_color = "#dad0e9";
  String color_5 = "#f8f8f8";
  String color_6 = "#eff0f4";
  String color_7 = "#72bd00";
  String color_8 = "#07b2ba";
  String color_9 = "#6d767d";


  String applink = "https://duakata-dev.com/miracle/api_script.php?";
  String applinksource = "https://duakata-dev.com/miracle/";
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


    Future<dynamic> cekAppointment(String getValue) async {
    http.Response response = await http.Client().get(
        Uri.parse(applink+"do=cekappointment&id="+getValue.toString()+""),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 10),onTimeout: (){
              http.Client().close();
              return http.Response('Error',500);
            });
            var data = jsonDecode(response.body);
            return [
              data["a"].toString(),
              data["b"].toString(),
              data["c"].toString(),
              data["d"].toString()];
          }


  Future<dynamic> getUserDetail(String getPhone, String getEmail) async {
    http.Response response = await http.Client().get(
        Uri.parse(applink+"do=act_getdetailcust&phone="+getPhone.toString()+"&email="+getEmail.toString()+""),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);});
    var data = jsonDecode(response.body);
    return [
      data["b"].toString()];
  }



          Future<dynamic> getAppDetailWithInvoiced(String getValue) async {
            http.Response response = await http.Client().get(
                Uri.parse(applink+"do=getdata_appdetail_withinvoiced&id="+getValue.toString()+""),
                headers: {
                  "Content-Type": "application/json",
                  "Accept": "application/json"}).timeout(
                Duration(seconds: 10),onTimeout: (){
              http.Client().close();
              return http.Response('Error',500);
            });
            var data = jsonDecode(response.body);
            return [
              data["a"].toString(),
              data["b"].toString(),
              data["c"].toString()];
          }






}