

/*
class HistoryTransaksiBackup extends StatefulWidget {
  final String getPhone;
  const HistoryTransaksiBackup(this.getPhone);
  @override
  _HistoryTransaksiBackupState createState() => new _HistoryTransaksiBackupState(getPhoneState: this.getPhone);

}


class _HistoryTransaksiBackupState extends State<HistoryTransaksiBackup> with SingleTickerProviderStateMixin {
  TabController controller;
  String getAcc, getPhoneState;
  _HistoryTransaksiBackupState({this.getPhoneState});

String countapp = '...';
  _getCountApp() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countapp&id="+widget.getPhone);
    Map data2 = jsonDecode(response.body);
    setState(() {
      countapp = data2["a"].toString();
    });
  }



  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    _getCountMessage();//LENGTH = TOTAL TAB YANG AKAN DIBUAT
    _getCountApp();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {

  }
  String countmessage = '0';
  void _getCountMessage() async {
    final response = await http.get(
        "https://duakata-dev.com/miracle/api_script.php?do=getdata_countmessage&id="+getPhoneState);
    Map data = jsonDecode(response.body);
    setState(() {
      countmessage = data["a"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child:  Scaffold(
          backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Hexcolor("#075e55"),
                leading: Icon(Icons.clear,color: Hexcolor("#075e55"),),
                title: new Text("History Transaksi",style: TextStyle(color : Colors.white,fontFamily: 'VarelaRound',fontSize: 18),),
                elevation: 0.0,
                centerTitle: true,
                bottom: TabBar(
                  controller: controller,
                unselectedLabelColor: Hexcolor("#c0c0c0"),
                labelColor: Colors.white,
                indicatorWeight: 2,
                indicatorColor: Colors.white,
                  tabs: <Tab>[
                        Tab(text: "Chat"),
                        Tab(text: "Video",)                     
                  ],
                ),
              ),
          body:
          TabBarView(
            controller: controller,
            children: <Widget>[
              ChatHistory(getPhoneState),
              VideoHistory(getPhoneState)
            ],
          ),
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
          title: Text("Appointment",
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
          icon: countmessage == '0' ?
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
      currentIndex: 1,
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
                builder: (BuildContext context) => AppointmentList(widget.getPhone)));
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => HistoryTransaksiBackup(widget.getPhone)));
        break;
      case 3:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => Notifikasi(widget.getPhone)));
        break;
      case 4:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => UserProfile(widget.getPhone)));
        break;

    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }
*/
//}