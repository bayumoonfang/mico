

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
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
        a = place.name.toString(); //EMBUH
        b = place.locality.toString(); // Kecamatan
        c = place.position.toString(); // Koordinate
        d = place.administrativeArea.toString(); // Propinsi
        e = place.subAdministrativeArea.toString(); // Kota / KABUPATEM
        f = place.country.toString(); // Negara
        g = place.thoroughfare.toString(); // Jalan alamat
        h = place.subThoroughfare.toString(); // Nomor Alamat
        i = place.subLocality.toString(); // JALAN (FORMAT LAIN)
      });
    }catch(e) {
      print(e);
    }
  }



  @override
  void initState() {
    super.initState();
   _getCurrentLocation();
    _getAddress();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child:  Scaffold(
          appBar: new AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context)
              ),
            ),
            title: Column(
              children: [
            Align(
              alignment: Alignment.centerLeft,
              child:     Text(
                "Current Location",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VarelaRound',
                    fontSize: 12),
              ),
            ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:     Text(
                    e.toString() + " , "+b.toString()+" , "+d.toString()+ " , "+f.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'VarelaRound',
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        body: Container(
          child :Column(
            children: [

          ],
        )
        ),
      ));
  }

}