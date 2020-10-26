import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/mico_detailimagehome.dart';
import 'package:mico/mico_favorite.dart';
import 'package:mico/mico_homesearch.dart';
import 'package:mico/mico_regional.dart';
import 'package:mico/mico_transaksihistorynew.dart';
import 'package:mico/page_login.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_loginstart.dart';
import 'package:mico/page_verifikasilogin.dart';
import 'package:mico/mico_dokter.dart';
import 'package:mico/services/mico_cekroom.dart';
import 'package:mico/user/mico_appointment.dart';
import 'package:mico/user/mico_historytransaksi.dart';
import 'package:mico/user/mico_notfikasi.dart';
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
  String getEmail, getPhone, getBasedLogin;
  String getName, getName2;
  String countchat = '';
  String countvideo = '';
  String countchatnotread = '';


  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getPhone = await Session.getPhone();
    getBasedLogin = await Session.getBasedLogin();
    if (value != 1) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => LoginStart()));
    }
  }
  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {
        // Internet Present Case
      } else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }


  Future<List> _getCountChat() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countchat&"
            "id="+getPhone);
    setState((){
      data = json.decode(response.body);
    });
  }

  String appKode,
  namaDokters,
  jenisKonsuls, roomKonsul = '';
  _cekAppointment() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=cekappointment&id="+getPhone.toString());
    Map data4 = jsonDecode(response.body);
    setState(() {
      appKode = data4["a"].toString();
      namaDokters = data4["b"].toString();
      jenisKonsuls = data4["c"].toString();
      roomKonsul = data4["d"].toString();
    });
  }

  String countmessage = '0';
  String countapp, countapp2 = "0";

  _getCountMessage() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countmessage&id="+appKode);
    Map data = jsonDecode(response.body);
    setState(() {
      countmessage = data["a"].toString();
    });
  }

  _getCountApp() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countapp&id="+getPhone);
    Map data2 = jsonDecode(response.body);
    setState(() {
      countapp = data2["a"].toString();
    });
  }

  _launchWebsite() async {
    const url = 'https://miracle-clinic.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  _launchSosmed() async {
    const url = 'https://www.instagram.com/miracle_clinic/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  _getCountApp2() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countapp2&id="+getPhone);
    Map data2 = jsonDecode(response.body);
    setState(() {
      countapp2 = data2["a"].toString();
    });
  }


  void _detailcust() async {
    await _session();
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=act_getdetailcust",
        body: {"phone": getPhone.toString(), "email":  getEmail.toString()});
    Map showdata = jsonDecode(response.body);
    setState(() {
      getName = showdata['b'].toString();
    });
  }




  void _loaddata() async {
    await  _connect();
    await _session();
    await _cekAppointment();
    await _detailcust();
    await _getCountMessage();
    await _getCountApp();
    await _getCountApp2();

  }


  @override
  void initState() {
    super.initState();
    _loaddata();
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

  final List<Widget> imageSliders = imgList.map((item) => Container(
    child: new Builder(
        builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => Home()));
                          },
                          child :
                          // Image.network(item, fit: BoxFit.cover,width: 1000,)
                          CachedNetworkImage(
                              imageUrl: item,
                              progressIndicatorBuilder: (context,
                                  url, downloadProgress) =>
                                  Center(
                                      child :
                                      Image.asset(
                                        "assets/loadingq.gif",
                                        width: 85.0,
                                      )),
                              imageBuilder: (context, image) =>
                                  Image.network(item, fit: BoxFit.cover,width: 1000,)
                          ),
                        ),
                      ],
                    )
                ),
              );
        }
    )
  )).toList();




  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Future<bool> _onWillPop() async {}
  int _current = 0;

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
              "Miracle Aesthetic Clinic",
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
                  onPressed: () => Navigator.pushReplacement(context, ExitPage(page: Favorite(getPhone)))
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
              Padding(
                padding: const EdgeInsets.only(top: 1,left: 18,right: 15),
       child :
            ResponsiveContainer(
              widthPercent: 100,
              heightPercent: 18,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child:
              ListView(
                scrollDirection: Axis.horizontal,
                children:
                  List.generate(imgList.length, (index) {
                      return
                        Center(
                      child :
                        Padding (
                          padding: const EdgeInsets.only(left: 0,right: 15),
                          child : InkWell(
                              onTap: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailScreenHome(imgList[index])));
                              },
                              child : ClipRRect(
                                child: ResponsiveContainer(
                                  widthPercent: 90,
                                  heightPercent: 100,
                                  child: CachedNetworkImage(
                                    imageUrl: imgList[index],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              )
                          )
                      ));
                  }),
              )
            )),
                         /* CarouselSlider(
                            items: imageSliders,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                aspectRatio: 2.5,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imgList.map((url) {
                              int index = imgList.indexOf(url);
                              return Container(
                                width:  _current == index
                                    ? 10.0
                                    : 6.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? Hexcolor("#075e55")
                                      : Hexcolor("#DDDDDD"),
                                ),
                              );
                            }).toList(),
                          ),*/

              countapp2 == '1' ?

            Padding(
              padding: const EdgeInsets.only(top : 20,left: 18,right: 15),
              child:
            ResponsiveContainer (
              heightPercent: 10,
              widthPercent: 100,
              child :
              new FutureBuilder(
                future : _getCountChat(),
                builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (context, i) {
                        return
                        GestureDetector(
                        child :
                            Badge(
                                position: BadgePosition.topStart(top: 0),
                                animationDuration: Duration(milliseconds: 300),
                                animationType: BadgeAnimationType.slide,
                                badgeContent: Text(
                                  jenisKonsuls == 'CHAT' ?
                                  data[i]["a"].toString() : "1",
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
                                      builder: (BuildContext context) => CekRoomKonsultasi(appKode, "1")));

                                },

                        );
                      },
                    );
                },
    )))

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
                                                          Navigator.pushReplacement(context, ExitPage(page: Regional()));
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
                                                          Navigator.pushReplacement(context, EnterPage(page: ListDokter("Surabaya")));
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
                                                          Navigator.pushReplacement(context, EnterPage(page: ListDokter("Surabaya")));
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
              Padding(
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
)
              
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
          icon:   countapp == '0' ?
          FaIcon(
            FontAwesomeIcons.calendarCheck,
            size: 22,
          )
              :
          GFIconBadge(
              child:FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 22,
              ),
              counterChild: GFBadge(
                color: Colors.redAccent,
                size: 16,
                shape:
                GFBadgeShape.circle,
              )
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
          countmessage == '0' ?
          FaIcon(
            FontAwesomeIcons.envelopeOpenText,
            size: 22,
          )
    :
    GFIconBadge(
          child:FaIcon(
                FontAwesomeIcons.envelopeOpenText,
                size: 22,
                ),
                 counterChild: GFBadge(
                color:
                Colors.redAccent,
                size: 16,
                shape:
                GFBadgeShape.circle,
          )
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
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => Home()));

        break;
      case 1:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => AppointmentList(getPhone)));
        break;
      case 2:
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                TransaksiHistoryNew(getPhone)));
        break;
      case 3:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => Notifikasi(getPhone)));
        break;
      case 4:
        Navigator.of(context).pushReplacement(
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

