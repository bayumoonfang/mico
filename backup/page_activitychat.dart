


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityChat extends StatefulWidget {
  final String getPhone;
  const ActivityChat(this.getPhone);
  @override
  _ActivityChatState createState() => new _ActivityChatState(getPhoneState: this.getPhone);

}


class _ActivityChatState extends State<ActivityChat> {
  String getAcc, getPhoneState;

  _ActivityChatState({this.getPhoneState});

  String getName = '';
  String getPhone = '';

  Future<bool> _onWillPop() async {

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(

        ),
      ),
    );

  }


}