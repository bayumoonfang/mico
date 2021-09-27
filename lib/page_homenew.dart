




import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/helper/based_color.dart';
import 'package:mico/helper/cached_manager.dart';
import 'package:mico/konsultasi/page_dokter.dart';
import 'package:mico/konsultasi/page_regional_new.dart';
import 'package:mico/mico_introduction.dart';
import 'package:mico/mico_transaksihistorynew.dart';
import 'package:mico/page_detailimagehome.dart';
import 'package:mico/page_home.dart';
import 'package:mico/page_loginstart.dart';
import 'package:mico/services/page_chatroom.dart';
import 'package:mico/services/page_chatroomdoctor.dart';
import 'package:mico/services/page_videoroom.dart';
import 'package:mico/user/mico_appointment.dart';
import 'package:mico/user/mico_notifnew.dart';
import 'package:mico/user/mico_userprofile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'Pesanan/page_pesananhome.dart';

final List<String> imgList = [
  AppHelper().applinksource+"media/promo/b.jpg",
  AppHelper().applinksource+"media/promo/a.jpg",
  AppHelper().applinksource+"media/promo/c.jpg",
  AppHelper().applinksource+"media/promo/d.jpg",
  AppHelper().applinksource+"media/promo/promo_new1.jpg",
  AppHelper().applinksource+"media/promo/promo_new2.jpg",
  AppHelper().applinksource+"media/promo/promo_new3.jpg",
];


class PageHomeNew extends StatefulWidget {

  @override
  _PageHomeNew createState() => _PageHomeNew();
}


class _PageHomeNew extends State<PageHomeNew> {

  int _current = 0;

  final CarouselController _controller = CarouselController();
  final List<Widget> imageSliders = imgList.map((item) => Builder(
    builder: (BuildContext context) {
      return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => DetailScreenHome(item)));
                },
                child: CachedNetworkImage(
                    imageUrl: item,
                    progressIndicatorBuilder: (context,
                        url, downloadProgress) =>
                        Center(
                            child :
                            CircularProgressIndicator()),
                    imageBuilder: (context, image) =>
                        Image.network(item, fit: BoxFit.cover,width: 10000,)
                ),
              )
          )
      );
    },
  )).toList();


  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPostiion;
  String addressVal = "...";
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
        _getAddress();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try{
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPostiion.latitude, _currentPostiion.longitude);
      Placemark place = p[0];
      setState(() {
        addressVal = place.thoroughfare+", "+place.locality+ ", "+place.subAdministrativeArea;
      });
    }catch(e) {
      print(e);
    }
  }

  FutureOr onGoBack(dynamic value) {
   setState(() {
     _currentTabIndex = 0;
   });
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String getEmail = "...";
  String getPhone = "...";
  String getRole = "...";
  String getNamaUser = "...";
  String appKode = "...";
  String namaDokters = "...";
  String jenisKonsuls = "...";
  String roomKonsul = "...";
  String namaPasien = '...';
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi Terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){if(value[0] != 1) {
      Navigator.pushReplacement(context, ExitPage(page: IntroductionPage()));} else{setState(() {
      getEmail = value[1]; getPhone = value[2]; getRole = value[3]; getNamaUser = value[4];});}});
    await _getCurrentLocation();
    await _getCountApp2();
    if(countapp2 != "0") {
      await AppHelper().cekAppointment(getPhone.toString(), getRole.toString()).then((value){
        setState(() {
          appKode = value[0];
          namaDokters = value[1];
          jenisKonsuls = value[2];
          roomKonsul = value[3];
          namaPasien = value[4];
        });});
      if(jenisKonsuls == "CHAT") {
        await _getCountChatRead();
      }
    } else {
      await _getCountTagihan();
    }
  }


  String countmessagenotif = '0';
  String countapp2 = '0';
  String countmessageq = '0';
  String countchatread = "0";


  String counttagihanq = "0";
  _getCountTagihan() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_counttagihan&id="+getPhone);
    Map data6 = jsonDecode(response.body);
    setState(() {
      counttagihanq = data6["a"].toString();
    });
  }




  _getCountApp2() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_countapp2&id="+getPhone+"&role="+getRole.toString());
    Map data2 = jsonDecode(response.body);
    setState(() {
      countapp2 = data2["a"].toString();
    });
  }

  _getCountChatRead() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_countchatread&id="+getPhone+"&role="+getRole.toString());
    Map data3 = jsonDecode(response.body);
    setState(() {
      countchatread = data3["a"].toString();
    });
  }

   reloadVariable() async {
     await _getCountApp2();
     if(countapp2 != "0") {
       await AppHelper().cekAppointment(getPhone.toString(), getRole.toString()).then((value){
         setState(() {
           appKode = value[0];
           namaDokters = value[1];
           jenisKonsuls = value[2];
           roomKonsul = value[3];
           namaPasien = value[4];
         });});
       if(jenisKonsuls == "CHAT") {
         await _getCountChatRead();
       }
     } else {
       await _getCountTagihan();
     }
   }


  Timer mytimer;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        reloadVariable();
      });
    });
    _startingVariable();
    _currentTabIndex = 0;
  }


  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("phone", null);
      preferences.setString("email", null);
      preferences.setString("idcustomer", null);
      preferences.setString("accnumber", null);
      preferences.setString("role", null);
      preferences.setString("basedlogin", null);
      preferences.setString("namauser", null);
      preferences.commit();
      Navigator.pushReplacement(context, ExitPage(page: LoginStart()));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("#602c98"),
        padding: const EdgeInsets.only(top:5),
          child: Column(
            children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              color: HexColor(AppHelper().app_color1),
              height: 150,
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 30),child:
                  //Text("Mico",style: GoogleFonts.comfortaa(fontSize: 22,fontWeight: FontWeight.bold),),),)
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getRole == "Doctor" ? "Mico Doctor" : "Mico",style: GoogleFonts.fredokaOne(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white)),
                      Row(
                        children: [
                          Padding(padding: const EdgeInsets.only(right: 30),child: FaIcon(FontAwesomeIcons.star,size: 20,color: Colors.white),),
                          Padding(padding: const EdgeInsets.only(right: 10),child:
                                InkWell(
                                  onTap: (){signOut();},
                                  child: FaIcon(FontAwesomeIcons.cog,size: 20,color: Colors.white),
                                )

                            ,),

                        ],
                      )

                    ],
                  )

                    ,),),
                  Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 5),child:
                  Text(getRole == "null" ? "..." :
                  getRole == null ? "..." :
                  getNamaUser.toString() == null ? "..." :
                  getNamaUser.toString() == "null" ? "..." :
                  getRole == "Doctor" ? getNamaUser.toString() : "Hai, "+getNamaUser.toString(), style: GoogleFonts.nunitoSans(fontSize: 16,color: Colors.white),),),),
                  Align(alignment: Alignment.centerLeft,
                      child: Container(
                        width: 250,
                        child: Padding(padding: const EdgeInsets.only(top: 5),child:
                        Row(
                          children: [
                            FaIcon(FontAwesomeIcons.mapMarker,size: 13,color: Colors.white),
                            Expanded(
                              child: Padding(padding: const EdgeInsets.only(left: 7,top: 2),child: Text(addressVal, style: GoogleFonts.nunitoSans(
                              color: Colors.white
                              ),
                                overflow: TextOverflow.ellipsis
                              ),),
                            )
                          ],
                        )
                          ,),
                      )

                  ),
                ],
              ),
            ),


              Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                    ),
                    child:  Container(
                      margin: const EdgeInsets.all(10),
                      child :
                      SingleChildScrollView(
                        child : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Apa yang kamu butuhkan ?",style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.bold,fontSize: 16
                              ),),

                             Padding(padding: const EdgeInsets.only(right: 20),
                             child:  InkWell(
                               child: Text(
                                   "Lihat Semua",
                                 style: GoogleFonts.varelaRound(color: HexColor((AppHelper().app_color3)),fontSize: 12),
                               ),
                             ),)
                            ],
                          ),
                        ),

                        Padding(padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              height: 135,
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 20),
                              child:
                                getRole.toString() == "Customer" ?
                                ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Padding(
                                        padding : const EdgeInsets.only(top:20,right: 40 ),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => ListDokter(getPhone.toString(), "")));
                                              },
                                              child : Container(
                                                child: CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor: HexColor(AppHelper().app_color2),
                                                  child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage:  CachedNetworkImageProvider(
                                                    AppHelper().applinksource+"media/photo/konsul.png",
                                                  ),
                                                  radius: 25,
                                                ),
                                              )),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("Konsultasi", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),


                                    Padding(
                                        padding : const EdgeInsets.only(top:20,right: 44),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => RegionalNew(getPhone.toString())));
                                              },
                                              child : Container(
                                                child: CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor: HexColor(AppHelper().app_color2),
                                                  child:CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage:
                                                  CachedNetworkImageProvider(
                                                    AppHelper().applinksource+"media/photo/resep.png",
                                                  ),
                                                  radius: 25,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("Resep", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),


                                    Padding(
                                        padding : const EdgeInsets.only(top:20, ),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => RegionalNew(getPhone.toString())));
                                              },
                                              child : Container(
                                                child: CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor: HexColor(AppHelper().app_color2),
                                                  child:CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: CachedNetworkImageProvider(
                                                    AppHelper().applinksource+"media/photo/mira-ico.png",
                                                  ),
                                                  radius: 25,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("Promo", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),
                                  ],
                                )

                                    :

                                ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Padding(
                                        padding : const EdgeInsets.only(top:20,right: 40 ),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => ListDokter(getPhone.toString(), "")));
                                              },
                                              child : Container(
                                                  child: CircleAvatar(
                                                    radius: 26,
                                                    backgroundColor: HexColor(AppHelper().app_color2),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: AssetImage("assets/appsaya.jpg"),
                                                      radius: 25,
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("App. Saya", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),


                                    Padding(
                                        padding : const EdgeInsets.only(top:20,right: 40 ),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => ListDokter(getPhone.toString(), "")));
                                              },
                                              child : Container(
                                                  child: CircleAvatar(
                                                    radius: 26,
                                                    backgroundColor: HexColor(AppHelper().app_color2),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: AssetImage("assets/resepdok.jpg"),
                                                      radius: 25,
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("Resep Saya", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),


                                    Padding(
                                        padding : const EdgeInsets.only(top:20,right: 40 ),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => ListDokter(getPhone.toString(), "")));
                                              },
                                              child : Container(
                                                  child: CircleAvatar(
                                                    radius: 26,
                                                    backgroundColor: HexColor(AppHelper().app_color2),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: AssetImage("assets/pasien.jpg"),
                                                      radius: 25,
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("Pasien Saya", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),





                                  ],
                                )
                            )
                        ),


                        countapp2 != '0' ?
                        Padding(
                            padding: const EdgeInsets.only(left: 15,bottom: 30,right: 15),
                            child:
                            Container (
                                child :
                                GestureDetector(
                                  child :

                                  jenisKonsuls.toString == "CHAT" ?
                                  Badge(
                                      position: BadgePosition.topStart(top: 0,start: 2),
                                      animationDuration: Duration(milliseconds: 300),
                                      animationType: BadgeAnimationType.slide,
                                      badgeColor: HexColor("#ef6352"),
                                      badgeContent: Text(countchatread,
                                        style: TextStyle(color: Colors.white,fontSize: 15),
                                      ),
                                      child :
                                      Card(
                                          elevation: 0,
                                          color: HexColor("#ebf5fe"),
                                          //f2eff6 ebf5fe f9f8fa
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: HexColor("#DDDDDD"), width: 1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child : ListTile(
                                            title: Text(
                                                namaDokters.toString() == null ? "..."
                                                : namaDokters.toString() == "null" ? "..." :
                                                namaPasien.toString() == null ? "..." :
                                                namaPasien.toString() == "null" ? "..." :
                                                getRole.toString() == "Customer" ?
                                                namaDokters.toString() :
                                                namaPasien.toString() ,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'VarelaRound',
                                                    fontWeight: FontWeight.bold
                                                )),
                                            subtitle: Text("Konsultasi "+jenisKonsuls.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'VarelaRound',
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            trailing: Text("On Going",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'VarelaRound',
                                                )),
                                          )
                                      )
                                  )
                                  :
                                  Card(
                                      elevation: 0,
                                      color: HexColor("#ebf5fe"),
                                      //f2eff6 ebf5fe f9f8fa
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: HexColor("#DDDDDD"), width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child : ListTile(
                                        title: Text(getRole.toString() == "Customer" ? namaDokters.toString() : namaPasien.toString() ,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'VarelaRound',
                                                fontWeight: FontWeight.bold
                                            )),
                                        subtitle: Text("Konsultasi "+jenisKonsuls.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'VarelaRound',
                                              fontWeight: FontWeight.bold,
                                            )),
                                        trailing: Text("On Going",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'VarelaRound',
                                            )),
                                      )
                                  ),
                                  onTap: (){
                                    getRole == "Doctor" && jenisKonsuls.toString() == "CHAT" ?
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => ChatroomDoctor(appKode.toString(), getPhone.toString(), getRole.toString())))
                                    : getRole == "Customer" && jenisKonsuls.toString() == "CHAT" ?
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => Chatroom(appKode.toString(), getPhone.toString(), getRole.toString())))
                                        : getRole == "Customer" && jenisKonsuls.toString() == "VIDEO" ?
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => VideoRoom(appKode.toString(), getPhone.toString(), getRole.toString(), roomKonsul.toString())))
                                        :
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => VideoRoom(appKode.toString(), getPhone.toString(), getRole.toString(), roomKonsul.toString())));
                                  },
                                )

                            ))

                            :
                        Text(""),


                        getRole.toString() == "Customer" ?
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              CarouselSlider(
                                items: imageSliders,
                                carouselController: _controller,
                                options: CarouselOptions(
                                    autoPlay: false,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    pauseAutoPlayOnTouch: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.8,
                                    aspectRatio: 2.0,
                                    height: 150,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top :10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: imgList.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () => _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: _current == entry.key ? 8.0 : 6.0,
                                        height: _current == entry.key ? 8.0 : 6.0,
                                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: (Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                                .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                        : Container(),


                        getRole.toString() == "Customer" ?
                        Padding(
                          padding: const EdgeInsets.only(top: 40,left: 25),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tentukan Konsultasi ?",style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.bold,fontSize: 16
                              ),),

                              Padding(padding: const EdgeInsets.only(right: 20),
                                child:  InkWell(
                                  child: Text(
                                    "Lihat Semua",
                                    style: GoogleFonts.varelaRound(color: HexColor((AppHelper().app_color3)),fontSize: 12),
                                  ),
                                ),)
                            ],
                          ),
                        ): Container(),

                        getRole.toString() == "Customer" ?
                        Padding(padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              height: 135,
                              padding: const EdgeInsets.only(left: 20),
                              child:  ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Padding(
                                        padding : const EdgeInsets.only(top:20,right: 40 ),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => ListDokter(getPhone.toString(), "Aesthetic")));
                                              },
                                              child : Container(
                                                child: CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor: HexColor(AppHelper().app_color2),
                                                  child:CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage:  CachedNetworkImageProvider(
                                                    AppHelper().applinksource+"media/photo/kecantikan.png",
                                                  ),
                                                  radius: 25,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("Aesthetics", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),


                                    Padding(
                                        padding : const EdgeInsets.only(top:20,right: 44),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => ListDokter(getPhone.toString(), "MBAC")));
                                              },
                                              child : Container(
                                                child: CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor: HexColor(AppHelper().app_color2),
                                                  child:CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage:  CachedNetworkImageProvider(
                                                    AppHelper().applinksource+"media/photo/mbac.jpg",
                                                  ),
                                                  radius: 25,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("MBAC", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),


                                    Padding(
                                        padding : const EdgeInsets.only(top:20, ),
                                        child :
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                //Navigator.push(context, ExitPage(page: Regional()));
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => ListDokter(getPhone.toString(), "Surgery")));
                                              },
                                              child : Container(
                                                child: CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor: HexColor(AppHelper().app_color2),
                                                  child:CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage:  CachedNetworkImageProvider(
                                                    AppHelper().applinksource+"media/photo/surgery2.jpg",
                                                  ),
                                                  radius: 25,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top : 10),
                                                child : Text("Surgery", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 13),)
                                            )
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                            )
                        ) : Container()





                      ],
                    ),
                  ),
              )))
              
              
              
            ],
          ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  int _currentTabIndex = 0;
  Widget _bottomNavigationBar() {
    return Theme(
        data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
    ), child :

    getRole == "Customer" ?
    BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _onTap,
      iconSize: 23,
      currentIndex: _currentTabIndex,
      //selectedItemColor: HexColor("#737373"),
      items: [
        BottomNavigationBarItem(
          //backgroundColor: HexColor("#2196f3"),
          icon: FaIcon(FontAwesomeIcons.home),
          label: 'Home',
        ),

          BottomNavigationBarItem(
            icon:
            counttagihanq == "0" ? FaIcon(FontAwesomeIcons.fileInvoice) :
            Badge(
              toAnimate: true,
              position: BadgePosition.topEnd(top: -1, end: -4),
              child: FaIcon(FontAwesomeIcons.fileInvoice),
            ),
            label: 'Pesanan',
          ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.mailBulk),
          label: 'Kotak Masuk',
        ),

          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Profile',
          ),
        ],
      )
        :
    BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _onTap,
      iconSize: 23,
      currentIndex: _currentTabIndex,
      //selectedItemColor: HexColor("#737373"),
      items: [
        BottomNavigationBarItem(
          //backgroundColor: HexColor("#2196f3"),
          icon: FaIcon(FontAwesomeIcons.home),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.mailBulk),
          label: 'Kotak Masuk',
        ),

        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user),
          label: 'Profile',
        ),
      ],
    )


    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => PageHomeNew()));

        break;
      case 1:
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => PesananHome(getPhone))).then(onGoBack);
        break;
      case 2:
        Navigator.pop(context);
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                TransaksiHistoryNew(getPhone)));
        break;
      case 3:
        Navigator.pop(context);
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => NotifNew(getPhone)));
        break;
      case 4:
        Navigator.pop(context);
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => UserProfile(getPhone)));
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }
  List<Container> myList = new List();
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
            builder: (context) => Container(
                child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: myList,
                    ))));
    }
  }


}