import 'package:flutter/material.dart';
import 'package:mico/pagelist_doktersearchresult.dart';
import 'package:toast/toast.dart';
import 'package:mico/pagelist_dokter.dart';

class DokterSearch extends StatefulWidget {
  final String namaKlinik;
  const DokterSearch(this.namaKlinik);
  @override
  _DokterSearchPageState createState() =>
      _DokterSearchPageState(getKlinik: this.namaKlinik);
}

class _DokterSearchPageState extends State<DokterSearch> {
  String getKlinik;
  _DokterSearchPageState({this.getKlinik});
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
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
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SearchResultDokter(getKlinik, value)));
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            body: Center()));
  }
}
