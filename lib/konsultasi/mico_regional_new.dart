

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/konsultasi/mico_dokter.dart';
import 'package:mico/mico_home.dart';
import 'package:permission_handler/permission_handler.dart';



class RegionalNew extends StatefulWidget{
  final String getPhone;
  const RegionalNew(this.getPhone);
  @override
  _RegionalNew createState() => new _RegionalNew();
}

class _RegionalNew extends State<RegionalNew> {


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child:  Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context)
              ),
            ),
            title: new Text("Regional",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'VarelaRound', fontSize: 16)),
          ),
          body: Container(
              color: Colors.white,
              child :Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top : 30.0, left: 25.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Pilih Regional Kamu ? ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16,
                            fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                      )
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top : 2.0, left: 25.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Temukan dokter terbaik di sekitar kamu ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12,),textAlign: TextAlign.left,),
                      )
                  ),
                  Center(
                      child :
                      Wrap(
                        spacing: 65,
                        children: <Widget>[
                          Padding(
                              padding : const EdgeInsets.only(top:40, ),
                              child :
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListDokter("Surabaya",widget.getPhone)));
                                    },
                                    child : Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage("assets/mira-ico.png"),
                                        radius: 30,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top : 10),
                                      child : Text("Surabaya", style: TextStyle(fontFamily: 'VarelaRound',
                                          fontSize: 14),)
                                  )
                                ],
                              )
                          ),


                          Padding(
                              padding : const EdgeInsets.only(top:40, ),
                              child :
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListDokter("Malang",widget.getPhone)));
                                    },
                                    child : Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage("assets/mira-ico.png"),
                                        radius: 30,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top : 10),
                                      child : Text("Malang", style: TextStyle(fontFamily: 'VarelaRound',
                                          fontSize: 14),)
                                  )
                                ],
                              )
                          ),
                          Padding(
                              padding : const EdgeInsets.only(top:40, ),
                              child :
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListDokter("Balikpapan",widget.getPhone)));
                                    },
                                    child : Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage("assets/mira-ico.png"),
                                        radius: 30,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top : 10),
                                      child : Text("Balikpapan", style: TextStyle(fontFamily: 'VarelaRound',
                                          fontSize: 14),)
                                  )
                                ],
                              )
                          ),


                          Padding(
                              padding : const EdgeInsets.only(top:40, ),
                              child :
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListDokter("Denpasar",widget.getPhone)));
                                    },
                                    child : Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage("assets/mira-ico.png"),
                                        radius: 30,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top : 10),
                                      child : Text("Denpasar", style: TextStyle(fontFamily: 'VarelaRound',
                                          fontSize: 14),)
                                  )
                                ],
                              )
                          ),



                        ],
                      )
                  ),
                ],
              )
          ),
        ));
  }

}