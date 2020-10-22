

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Regional extends StatefulWidget{
  @override
  _RegionalState createState() => new _RegionalState();
}

class _RegionalState extends State<Regional> {

  getUserLocation() async {//call this async method from whereever you need

   /* LocationDa myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    currentLocation = myLocation;
    final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;*/
  }


  @override
  void initState() {
    super.initState();
    //_getCurrentPosition();
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: new AppBar(
            leading: Text(""),
          ),
      );
  }

}