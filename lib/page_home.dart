import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/check_connection.dart';
import 'package:mico/page_login.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/page_loginstart.dart';
import 'package:mico/page_tes.dart';
import 'package:mico/page_verifikasilogin.dart';
import 'package:mico/pagelist_dokter.dart';
import 'package:mico/services/page_chatroom.dart';
import 'package:mico/services/page_chatroomhome.dart';
import 'package:mico/services/page_videoroomhome.dart';
import 'package:mico/user/page_notfikasi.dart';
import 'package:mico/user/page_userprofile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:mico/user/page_historytransaksi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
final List<String> imgList = [
  'https://duakata-dev.com/miracle/media/promo/b.jpg',
  'https://duakata-dev.com/miracle/media/promo/a.jpg',
  'https://duakata-dev.com/miracle/media/promo/c.jpg',
  'https://duakata-dev.com/miracle/media/promo/d.jpg',
];
class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  List<Container> myList = new List();
  final _firebaseMessaging = FirebaseMessaging();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
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

  String countmessage = '0';
  void _getCountMessage() async {
    await _session();
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countmessage&id="+getPhone);
    Map data = jsonDecode(response.body);
    setState(() {
      countmessage = data["a"].toString();
    });
  }



  List data2, data3;
  Future<List> _getCountChat() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countchat&"
            "id="+getPhone);
    setState((){
      data2 = json.decode(response.body);
    });
  }

  Future<List> _getCountVideo() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countvideo&"
            "id="+getPhone);
    setState((){
      data3 = json.decode(response.body);
    });
  }


/*
  void _getCountVideo() async {
    await _session();
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countvideo&id="+getPhone);
    Map data = jsonDecode(response.body);
    setState(() {
      countvideo = data["countme"].toString();
    });
  }*/


  @override
  void initState() {
    super.initState();
    //startSplashScreen();
    _connect();
    _getCountMessage();
    _detailcust();
    _getCountChat();
    _getCountVideo();
    //_getCountChatNotRead();
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
    //myFocusNode.requestFocus();
  }





  final List<Widget> imageSliders = imgList.map((item) => Container(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,

      ),
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              InkWell(
                  onTap: (){},
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
    ),
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
            backgroundColor: Hexcolor("#075e55"),
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.menu),
                color: Colors.white,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: new Text(
              "Miracle Aesthetic Clinic",
              style: new TextStyle(
                  fontFamily: 'VarelaRound', fontSize: 16, color: Colors.white),
            ),
            actions: [
          /*  Container(
              margin: const EdgeInsets.only(right: 10),
            height: 55,
            width: 45,
              child :
              new FutureBuilder(
              future: _getCountChat(),
              builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: data2 == null ? 0 : data2.length ,
                  itemBuilder: (context, i) {
                            return    data2[i]["a"] == 0 ?
                            Builder(
                              builder: (context) =>
                                  Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child :
                                    Opacity(
                                      opacity: 0.7,
                                      child :
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.comments),
                                        iconSize: 21,
                                        color: Colors.white,
                                        onPressed: ()
                                        {//Navigator.push(context, EnterPage(page: Chatroomhome(getPhone)));
                                        },
                                      )
                                     )
                                  ),
                            )
                                :

                            Builder(
                              builder: (context) =>
                                  Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child :
                                      IconButton(
                                        icon: new Badge(
                                          toAnimate: false,
                                          badgeContent: Text(
                                            "1",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                          child:
                                          FaIcon(FontAwesomeIcons.comments),
                                          ),
                                        iconSize: 21,
                                        color: Colors.white,
                                        onPressed: ()
                                        {
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext context) => Chatroomhome(getPhone,'2')));
                                          //Navigator.push(context, EnterPage(page: Chatroomhome(getPhone)));
                                        },
                                      )
                                  ),
                            );

                  });
                }
              )
            ),
              Container(
                  height: 55,
                  width: 45,
                  margin: const EdgeInsets.only(right:15, top: 4),
                  child :
                  new FutureBuilder(
                      future: _getCountVideo(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            itemCount: data3 == null ? 0 : data3.length ,
                            itemBuilder: (context, i) {
                              return    data3[i]["a"] == 0 ?
                              Builder(
                                builder: (context) =>
                                    Padding(
                                        padding: const EdgeInsets.only(top:0),
                                        child :
                                            Opacity(
                                              opacity: 0.7,
                                              child :
                                        IconButton(
                                          icon: FaIcon(FontAwesomeIcons.video),
                                          iconSize: 21,
                                          color: Colors.white,
                                          onPressed: ()
                                          {
                                            //Navigator.push(context, EnterPage(page: Chatroomhome(getPhone)));
                                          },
                                        )
                                    )),
                              )
                                  :
                              Builder(
                                builder: (context) =>
                                    Padding(
                                        padding: const EdgeInsets.only(top:0),
                                        child :
                                        IconButton(
                                          icon: new Badge(
                                            toAnimate: false,
                                            badgeContent: Text(
                                              "1",
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                            child: FaIcon(FontAwesomeIcons.video),
                                          ),
                                          iconSize: 21,
                                          color: Colors.white,
                                          onPressed: ()
                                          {
                                            Navigator.of(context).push(
                                                new MaterialPageRoute(
                                                    builder: (BuildContext context) => Chatroomhome(getPhone,'2')));
                                            //Navigator.push(context, EnterPage(page: Chatroomhome(getPhone)));
                                          },
                                        )
                                    ),
                              );

                            });
                      }
                  )
              ),
*/
            ],
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
                padding: const EdgeInsets.only(top: 10),
              ),
                          CarouselSlider(
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
                          ),
                                Padding(
                                  padding: const EdgeInsets.only(top : 30.0, left: 25.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Mulai Konsultasi Chatting atau Video Call ? ", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18,
                                    fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                  )
                                ),

                                Padding(
                                    padding: const EdgeInsets.only(top : 2.0, left: 25.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Silahkan pilih regional anda", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14,),textAlign: TextAlign.left,),
                                    )
                                ),
                                          Center(
                                            child :
                                          Wrap(
                                            spacing: 50,
                                            children: <Widget>[
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
                                                                    radius: 30,
                                                                  ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top : 10),
                                                        child : Text("Surabaya", style: TextStyle(fontFamily: 'VarelaRound',
                                                            fontSize: 15),)
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
                                                          Navigator.pushReplacement(context, EnterPage(page: ListDokter("Malang")));
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
                                                              fontSize: 15),)
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
                                                          Navigator.pushReplacement(context, EnterPage(page: ListDokter("Denpasar")));
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
                                                              fontSize: 15),)
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
                                                          Navigator.pushReplacement(context, EnterPage(page: ListDokter("Balikpapan")));
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
                                                              fontSize: 15),)
                                                      )
                                                    ],
                                                  )
                                              ),

                                            ],
                                          )
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
      selectedItemColor: Hexcolor("#628b2c"),
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
                builder: (BuildContext context) => HistoryTransaksi(getPhone)));
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => Notifikasi(getPhone)));
        break;
      case 3:
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

