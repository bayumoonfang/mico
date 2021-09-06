import 'package:flutter/material.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/helper/session_user.dart';
import 'package:mico/mico_doktersearchresult.dart';
import 'package:mico/page_home.dart';
import 'package:mico/mico_homesearchresult.dart';
import 'package:mico/page_login.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class HomeSearch extends StatefulWidget {
  @override
  _HomeSearchPageState createState() =>
      _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearch> {

  List data;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  final TextEditingController _textController = new TextEditingController();
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: Home()));
  }


  String getPhone = "...";
  _session() async {
    getPhone = await Session.getPhone();
    int value = await Session.getValue();
    if (value != 1) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
  }


  @override
  initState() {
    super.initState();
    _session();
  }

  void _addSearchQuery() {
    var url = "https://duakata-dev.com/miracle/api_script.php?do=action_addsearchquery";
    http.post(url,
        body: {
          "iduser": getPhone,
          "searchquery" : _textController.text
        });
  }


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://duakata-dev.com/miracle/api_script.php?do=getdata_searchquery&iduser="+getPhone),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }




  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              title: new TextField(
                controller: _textController,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'VarelaRound',
                    fontSize: 16),
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (String value) async {
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text(value)));
                  if (value == '') {
                    showToast("Pencarian tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                  } else {
                    _addSearchQuery();
                     Navigator.pushReplacement(context, ExitPage(page: HomeSearchResult(value)));
                  }
                },
                decoration: new InputDecoration(
                  //prefixIcon: new Icon(Icons.search,color: Colors.black,),
                  border: InputBorder.none,
                  hintText: 'Cari Dokter...',
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => Navigator.pushReplacement(context, EnterPage(page: Home()))
                ),
              ),
            ),
            body: new ResponsiveContainer(
                heightPercent: 100,
                widthPercent: 100,
                child :
                FutureBuilder<List>(
                  future: getData(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: data == null ? 0 : data.length,
                      padding: const EdgeInsets.only(left:10,right: 15 ,top: 10 ),
                      itemBuilder: (context, i) {
                        return Column(
                          children: [

                            InkWell(
                              child :
                              ListTile(
                                title: Text(data[i]["a"],
                                    style: new TextStyle(
                                        fontFamily: 'VarelaRound', fontSize: 16)),
                                trailing:  Icon(Icons.arrow_forward_ios_outlined,size: 12,),

                              ),
                              onTap: () {
                                Navigator.pushReplacement(context, ExitPage(page: HomeSearchResult(data[i]["a"])));
                              },),
                            Padding(
                              padding: const EdgeInsets.only(top:2),
                              child: Divider(height: 5,),
                            )
                          ],
                        );
                      },
                    );

                  },
                )
            )));
  }
}
