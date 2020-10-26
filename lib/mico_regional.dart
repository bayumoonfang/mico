

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/mico_dokter.dart';
import 'package:mico/mico_home.dart';
import 'package:permission_handler/permission_handler.dart';



class Regional extends StatefulWidget{
  @override
  _RegionalState createState() => new _RegionalState();
}

class _RegionalState extends State<Regional> {



  /*void _getCurrentLocation () async {
    await _handleCameraAndMic();
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      coordinates = position.latitude.toString() + "," + position.longitude.toString();
    });
  }

_getAddress() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(coordinates)
    }
}

/*

  _getLocation () async {
    final query = "1600 Amphiteatre Parkway, Mountain View";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");

// From coordinates
    final coordinates = new Coordinates(1.10, 45.50);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    print("${first.featureName} : ${first.locality}");
  }*/

*/

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPostiion;
  String a,b,c,d,e,f,g,h,i,j = "...";
  String aa = "...";

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.location],
    );
  }

  _getCurrentLocation() async {
    await _handleCameraAndMic();
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() {
        _currentPostiion = position;
      });
      _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try{
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPostiion.latitude, _currentPostiion.longitude);
      Placemark place = p[0];
      setState(() {
        a = place.name; //EMBUH
        b = place.locality; // Kecamatan
        //c = place.position; // Koordinate
        d = place.administrativeArea; // Propinsi
        e = place.subAdministrativeArea; // Kota / KABUPATEM
        f = place.country; // Negara
        g = place.thoroughfare; // Jalan alamat
        h = place.subThoroughfare; // Nomor Alamat
        i = place.subLocality; // JALAN (FORMAT LAIN)
        aa = e.toString() + " , "+b.toString()+" , "+d.toString()+ " , "+f.toString();
      });
    }catch(e) {
      print(e);
    }
  }

  _getalllocation () async {
    await _getCurrentLocation();
    await  _getAddress();
  }

  @override
  void initState() {
    super.initState();
    _getalllocation();
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: Home()));
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
                  onPressed: () => Navigator.pushReplacement(context, EnterPage(page: Home()))
              ),
            ),
            title: Column(
              children: [
            Align(
              alignment: Alignment.centerLeft,
              child:     Opacity(
                opacity: 0.6,
                child: Text(
                  "Current Location",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'VarelaRound',
                      fontSize: 12),
                ),
              )
            ),
               Padding(
                 padding: const EdgeInsets.only(top:2),
                 child:  Align(
                   alignment: Alignment.centerLeft,
                   child: Text(aa.toString(),
                     style: TextStyle(
                         color: Colors.black,
                         fontFamily: 'VarelaRound',
                         fontWeight: FontWeight.bold,
                         fontSize: 15),
                   ),
                 ),
               )
              ],
            ),
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
                    child: Text("Kami temukan dokter terbaik di dekat kamu ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12,),textAlign: TextAlign.left,),
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
                                  Navigator.pushReplacement(context, ExitPage(page: ListDokter("Surabaya")));
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
                                  Navigator.pushReplacement(context, ExitPage(page: ListDokter("Malang")));
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
                                  Navigator.pushReplacement(context, ExitPage(page: ListDokter("Balikpapan")));
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
                                  Navigator.pushReplacement(context, ExitPage(page: ListDokter("Denpasar")));
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