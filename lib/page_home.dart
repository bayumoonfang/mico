import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/app_helper.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/konsultasi/page_regional_new.dart';
import 'package:mico/page_detailimagehome.dart';
import 'package:mico/page_favorite.dart';
import 'package:mico/mico_homesearch.dart';
import 'package:mico/archived/page_regional_archive.dart';
import 'package:mico/mico_introduction.dart';
import 'package:mico/mico_transaksihistorynew.dart';
import 'package:mico/page_login.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_loginstart.dart';
import 'package:mico/page_verifikasilogin.dart';
import 'package:mico/konsultasi/page_dokter.dart';
import 'package:mico/services/page_cekrom_new.dart';
import 'package:mico/services/page_cekroom_archived.dart';
import 'package:mico/services/page_chatroom.dart';
import 'package:mico/user/mico_appointment.dart';
import 'package:mico/user/mico_notifnew.dart';
import 'package:mico/user/mico_userprofile.dart';
import 'package:mico/mico_resep.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
final List<String> imgList = [
  'https://duakata-dev.com/miracle/media/promo/b.jpg',
  'https://duakata-dev.com/miracle/media/promo/a.jpg',
  'https://duakata-dev.com/miracle/media/promo/c.jpg',
  'https://duakata-dev.com/miracle/media/promo/d.jpg',
  'https://duakata-dev.com/miracle/media/promo/promo_new1.jpg',
  'https://duakata-dev.com/miracle/media/promo/promo_new2.jpg',
  'https://duakata-dev.com/miracle/media/promo/promo_new3.jpg',
];

final List<String> ListKota = [
  'Surabaya',
  'Malang',
  'Denpasar',
  'Balikpapan',
];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  List<Container> myList = new List();
  final _firebaseMessaging = FirebaseMessaging();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  List data;
  //int value;
  String getEmail, getPhone;
  String countchat = '';
  String countvideo = '';
  String countchatnotread = '';


  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


   String appKode,namaDokters,jenisKonsuls, roomKonsul, getName = '...';
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
     showToast("Koneksi Terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){if(value[0] != 1) {
      Navigator.pushReplacement(context, ExitPage(page: IntroductionPage()));} else{setState(() {
        getEmail = value[1]; getPhone = value[2];});}});
    await AppHelper().cekAppointment(getPhone.toString()).then((value){
      setState(() {
        appKode = value[0];
        namaDokters = value[1];
        jenisKonsuls = value[2];
        roomKonsul = value[3];});});
    await AppHelper().getUserDetail(getPhone.toString(), getEmail.toString()).then((value){
      setState(() {
        getName = value[0];});});

  }

  String countmessagenotif = '0';
  String countapp2 = '0';
  String countmessageq = '0';
  String countchatread = "0";
  _getCountMessageChat() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_countchat&id="+getPhone);
    Map data5 = jsonDecode(response.body);
    setState(() {
      countmessageq = data5["a"].toString();
    });
  }

  _getCountMessageNotif() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_countnotif&id="+getPhone);
    Map data6 = jsonDecode(response.body);
    setState(() {
      countmessagenotif = data6["a"].toString();
    });
  }

  _launchSosmed(String urlSosmed) async {
    String url = urlSosmed;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getCountApp2() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_countapp2&id="+getPhone);
    Map data2 = jsonDecode(response.body);
    setState(() {
      countapp2 = data2["a"].toString();
    });
  }

  _getCountChatRead() async {
    final response = await http.get(
        AppHelper().applink+"do=getdata_countchatread&id="+getPhone);
    Map data3 = jsonDecode(response.body);
    setState(() {
      countchatread = data3["a"].toString();
    });
  }


  void _loaddata() async {
    await _startingVariable();
    await _getCountApp2();
    await _getCountMessageChat();
    await _getCountMessageNotif();
    await _getCountChatRead();
  }


  Timer mytimer;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _getCountApp2();
        _getCountMessageChat();
        _getCountMessageNotif();
        _startingVariable();
        _getCountChatRead();
      });
    });
    _loaddata();
  }

  @override
  void dispose() {
    mytimer.cancel();
    super.dispose();
  }



  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("phone", null);
      preferences.setString("email", null);
      preferences.setInt("idcustomer", null);
      preferences.setInt("accnumber", null);
      preferences.commit();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => LoginStart()));
    });
  }

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




  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Future<bool> _onWillPop() async {}
  int _current = 0;
  final CarouselController _controller = CarouselController();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child : Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            //backgroundColor: HexColor("#075e55"),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.menu),
                color: Colors.black,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: new Text(
              "Miracle Telemedicine",
              style: new TextStyle(
                  fontFamily: 'VarelaRound', fontSize: 16, color: Colors.black),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.search),
                  color: Colors.black,
                  onPressed: () => Navigator.pushReplacement(context, ExitPage(page: HomeSearch()))
                ),
              ),
              Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.favorite_border_outlined),
                  color: Colors.black,
                  onPressed: () =>
                              Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => Favorite(getPhone.toString())))
                ),
              ),

              Builder(
                builder: (context) => IconButton(
                    icon: new FaIcon(FontAwesomeIcons.bell,size: 21,),
                    color: Colors.black,
                    onPressed: () =>
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => Favorite(getPhone.toString())))
                ),
              ),



            ],
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: HexColor("#075e55"),
                  ),
                  accountName: new Text(getName.toString(),
                      style: TextStyle(fontSize: 18)),
                  accountEmail: new Text(getEmail.toString()),
                  currentAccountPicture: new CircleAvatar(
                    radius: 150,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/mira-ico.png"),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                  ),
                  title:
                  Text('Logout', style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18)),
                  onTap: () {
                    signOut();
                  },
                )
              ],
            ),
          ),
          //body:
          body:
              SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child :
                    Column(
                      children: <Widget>[
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
                                    width: 8.0,
                                    height: 8.0,
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

                        countapp2 != '0' ?

                            Padding(
                              padding: const EdgeInsets.only(top : 20,left: 18,right: 15),
                              child:
                            ResponsiveContainer (
                              heightPercent: 10,
                              widthPercent: 100,
                              child :
                              GestureDetector(
                                child :
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
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: HexColor("#DDDDDD"), width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child : ListTile(
                                          title: Text(namaDokters == null ? '...' : namaDokters.toString(),
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
                                    )),
                                onTap: (){
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => Chatroom(appKode.toString(), getPhone.toString())));
                                },
                              )

                            ))

                          :
                              Text(""),
                                Padding(
                                  padding: const EdgeInsets.only(top : 30.0, left: 25.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Miracle hadir dengan warna beda ? ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18,
                                    fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                  )
                                ),

                                Padding(
                                    padding: const EdgeInsets.only(top : 2.0, left: 25.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Pilih layanan sesuai kebutuhanmu ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14,),textAlign: TextAlign.left,),
                                    )
                                ),
                                          Center(
                                            child :
                                          Wrap(
                                            spacing: 40,
                                            children: <Widget>[
                                              Padding(
                                                  padding : const EdgeInsets.only(top:40, ),
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
                                                            backgroundColor: Colors.white,
                                                            backgroundImage: AssetImage("assets/konsul.png"),
                                                            radius: 25,
                                                          ),
                                                        ),
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
                                                  padding : const EdgeInsets.only(top:40, ),
                                                  child :
                                                  Column(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pushReplacement(context, ExitPage(page: MicoResep(getPhone)));
                                                        },
                                                        child :
                                                            Container(
                                                              child: CircleAvatar(
                                                                backgroundColor: Colors.white,
                                                                backgroundImage: AssetImage("assets/resep.png"),
                                                                radius: 25,
                                                              ),
                                                            )
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
                                                  padding : const EdgeInsets.only(top:40, ),
                                                  child :
                                                  Column(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          //Navigator.pushReplacement(context, EnterPage(page: ListDokter("Surabaya")));
                                                        },
                                                        child : Container(
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.white,
                                                            backgroundImage: AssetImage("assets/mira-ico.png"),
                                                            radius: 25,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets.only(top : 10),
                                                          child : Text("Live Event", style: TextStyle(fontFamily: 'VarelaRound',
                                                              fontSize: 13),)
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
                                                          //Navigator.pushReplacement(context, EnterPage(page: ListDokter("Surabaya")));
                                                        },
                                                        child : Container(
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.white,
                                                            backgroundImage: AssetImage("assets/mira-ico.png"),
                                                            radius: 25,
                                                          ),
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
                                          ),


                                 /* Padding(
                                      padding: const EdgeInsets.only(top : 80.0, left: 25.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Connect With Us ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18,
                                            fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                      )
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.only(top : 2.0, left: 25.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Temukan informasi terbaru lain ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14,),textAlign: TextAlign.left,),
                                      )
                                  ),


                                  Padding(
                                    padding: const EdgeInsets.only(top : 10),
                                    child: Column(
                                      children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5,left: 21,right: 15),
                                      child:    InkWell(
                                        onTap: () {
                                          _launchWebsite();
                                        },
                                        child :Container(
                                        width: double.infinity,
                                        height: 100,
                                        child : Image(image: AssetImage("assets/web2.png"),fit: BoxFit.fitWidth,)
                                        )),
                                    ),

                                   Padding(
                                     padding: const EdgeInsets.only(left: 19,top :10),
                                     child:    Align(
                                       alignment: Alignment.centerLeft,
                                       child: Opacity(
                                         opacity: 0.7,
                                         child: Text("Website Miracle",
                                             style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14,fontWeight: FontWeight.bold)
                                         ),
                                       )
                                     ),
                                   ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 25,left: 21,right: 15),
                                      child:
                                      InkWell(
                                        onTap: () {
                                          _launchSosmed();
                                        },
                                        child :
                                      Container(
                                          width: double.infinity,
                                          height: 100,
                                          child : Image(image: AssetImage("assets/web3.png"),fit: BoxFit.fitWidth,)
                                      )),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 19,top :10,bottom: 25),
                                      child:    Align(
                                          alignment: Alignment.centerLeft,
                                          child: Opacity(
                                            opacity: 0.7,
                                            child: Text("Social Media Miracle",
                                                style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14,fontWeight: FontWeight.bold)
                                            ),
                                          )
                                      ),
                                    )
                                ],
                              ),
                            )*/
              
                                  ],
                                )),

          //Navigator(key: _navigatorKey, onGenerateRoute: generateRoute),
          // _home(),
          bottomNavigationBar: _bottomNavigationBar(),
        ));
  }

  int _currentTabIndex = 0;
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.home,
              size: 22,
            ),
            title: Text("Home",
                style: TextStyle(
                  fontFamily: 'VarelaRound',
                ))),

                    BottomNavigationBarItem(
                    icon:   countapp2 == '0' ?
                          FaIcon(
                            FontAwesomeIcons.calendarCheck,
                            size: 22,
                          )
                      :
                      Badge(
                      badgeContent: Text("",
                          style: TextStyle(color: Colors.white,fontSize: 12),),
                          child: FaIcon(FontAwesomeIcons.calendarAlt, size: 22,),
                      ),
                      title: Text("Activity",
                          style: TextStyle(
                            fontFamily: 'VarelaRound',
                          )),
                    ),

                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.fileAlt,
                      size: 22,
                    ),
                    title: Text("History",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                        )),
                    ),

                  BottomNavigationBarItem(
                    icon:
                    countmessagenotif == '0' ?
                            FaIcon(
                              FontAwesomeIcons.envelopeOpenText,
                              size: 22,
                            )
                          :
                            Badge(
                              badgeContent: Text("",
                                style: TextStyle(color: Colors.white,fontSize: 12),),
                              child: FaIcon(FontAwesomeIcons.envelopeOpenText, size: 22,),
                            ),
                    title: Text("Message",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                        )),
                  ),

                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.userCircle,
                      size: 22,
                    ),
                    title: Text("Account",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                        )),
                  )

      ],
      onTap: _onTap,
      currentIndex: _currentTabIndex,
      selectedItemColor: HexColor("#628b2c"),
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
       // _navigatorKey.currentState.pushReplacementNamed("Home");
        Navigator.pop(context);
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => Home()));

        break;
      case 1:
        Navigator.pop(context);
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => AppointmentList(getPhone)));
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

