import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/page_login.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_verifikasilogin.dart';
import 'package:mico/mico_dokter.dart';
import 'package:mico/user/mico_historytransaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
class HomeFix extends StatefulWidget {
  @override
  _HomeFixState createState() => new _HomeFixState();
}

class _HomeFixState extends State<HomeFix> {
  List<Container> myList = new List();
  final _firebaseMessaging = FirebaseMessaging();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  //int value;
  String getEmail, getPhone;
  String getName, getName2;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }



  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getPhone = await Session.getPhone();
    if (value != 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
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
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    });
  }



  @override
  void initState() {
    super.initState();
    //startSplashScreen();
    _addchat();
    _buatlist();
  }


  void _addchat() async {
    await _session();
    final response = await http.post(
        "https://duakata-dev.com/miracle/api_script.php?do=act_getdetailcust",
        body: {"phone": getPhone.toString(), "email":  getEmail.toString()});
    Map showdata = jsonDecode(response.body);
    setState(() {
      getName = showdata['b'].toString();
    });
    //myFocusNode.requestFocus();
  }


  var namaKlinik = [
    {"nama": "Regional Surabaya"},
    {"nama": "Regional Malang"},
    {"nama": "Regional Denpasar"},
    {"nama": "Regional Balikpapan"},
  ];

  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  _buatlist() async {
    for (var i = 0; i < namaKlinik.length; i++) {
      final myKlinik = namaKlinik[i];
      //final String gambar = karakternya["gambar"];
      myList.add(new Container(
          color: Colors.white,
          child: new InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => ListDokter(
                  myKlinik['nama'].substring(9),
                  //gambar: gambar,
                ),
              )),
              child: new Card(
                  elevation: 0,
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.all(10.0),
                      ),
                      new Hero(
                        tag: myKlinik['nama'],
                        child: new Material(
                          child: new CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage("assets/mira-ico.png")),
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(10.0),
                      ),
                      new Text(
                        myKlinik['nama'],
                        style: new TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 14),
                      )
                    ],
                  )))));
    }
  }



  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Future<bool> _onWillPop() async {}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child : Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.menu),
                color: Colors.black,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: new Text(
              "Miracle aesthetic Clinic",
              style: new TextStyle(
                  fontFamily: 'VarelaRound', fontSize: 16, color: Colors.black),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Hexcolor("#628b2c"),
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
                  Text('Logout', style: TextStyle(fontFamily: 'VarelaRound')),
                  onTap: () {
                    signOut();
                  },
                )
              ],
            ),
          ),
          //body:
          body: Navigator(key: _navigatorKey, onGenerateRoute: generateRoute),
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
              size: 25,
            ),
            title: Text("Home",
                style: TextStyle(
                  fontFamily: 'VarelaRound',
                ))),


        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.clipboardList,
            size: 25,
          ),
          title: Text("Activity",
              style: TextStyle(
                fontFamily: 'VarelaRound',
              )),
        ),




        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.bell,
            size: 25,
          ),
          title: Text("Notification",
              style: TextStyle(
                fontFamily: 'VarelaRound',
              )),
        ),

        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.userCircle,
            size: 25,
          ),
          title: Text("Account",
              style: TextStyle(
                fontFamily: 'VarelaRound',
              )),
        )

      ],
      onTap: _onTap,
      currentIndex: _currentTabIndex,
      selectedItemColor: Hexcolor("#628b2c"),
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _navigatorKey.currentState.pushReplacementNamed("Profile");
        break;
      case 1:
        _navigatorKey.currentState.pushReplacementNamed("Home");
        break;
      case 2:
        _navigatorKey.currentState.pushReplacementNamed("Settings");
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Settings":
        return MaterialPageRoute(
            builder: (context) => Container(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Lainnya",
                              style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 20,
                              )),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text("Bantuan"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Divider(
                          height: 1.0,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Pengaturan Aplikasi"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Divider(
                          height: 1.0,
                        )),
                  ],
                )));

      case "Profile":
        return MaterialPageRoute(
            builder: (context) => Container(
              // color: Hexcolor("#f5f5f5"),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0),
                      child: Card(
                        elevation: 2,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                  AssetImage("assets/mira-ico.png")),
                              title: Text(getName.toString(),
                                  style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                  )),
                              subtitle: Text(getPhone.toString(),
                                  style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                  )),
                            )),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0),
                      child:
                      new InkWell(
                          onTap: ()  =>
                              _navigatorKey.currentState.pushReplacement(
                                  MaterialPageRoute(builder: (BuildContext context) => HistoryTransaksi(getPhone))),


                          child :
                          Card(
                            elevation: 2,
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: ListTile(
                                  leading: Icon(Icons.restore),
                                  title: Text("Riwayat Transaksi",
                                      style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                      )),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                )),
                          )))
                ],
              ),
            ));
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
}*/

