/*
  var namaKlinik = [
    {"nama": "Regional Surabaya"},
    {"nama": "Regional Malang"},
    {"nama": "Regional Denpasar"},
    {"nama": "Regional Balikpapan"},
  ];




  _buatlist() async {
    for (var i = 0; i < namaKlinik.length; i++) {
      final myKlinik = namaKlinik[i];
      //final String gambar = karakternya["gambar"];
      myList.add(new Container(
          color: Colors.white,
          child: new InkWell(
              onTap: () =>

                  Navigator.push(context, EnterPage(page: ListDokter(myKlinik['nama'].substring(9)))),
                  /*Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ListDokter(myKlinik['nama'].substring(9)))),*/
                          //TesPage())),
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

new FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  if (data == null) {
                    return Center(
                        child: Image.asset(
                          "assets/loadingq.gif",
                          width: 225.0,
                        )
                    );
                  } else {
                    return data.isEmpty
                        ? Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Dokter tidak ditemukan",
                              style: new TextStyle(
                                  fontFamily: 'VarelaRound', fontSize: 20),
                            ),
                            new Text(
                              "Silahkan coba beberapa saat lagi..",
                              style: new TextStyle(
                                  fontFamily: 'VarelaRound', fontSize: 16),
                            ),
                          ],
                        ))
                        : new ListView.builder(
                      padding: const EdgeInsets.only(top: 15.0),
                      itemCount: data == null
                          ? 0
                          : data.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            data[i]['g'] == 'Online' ?
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Pembayaran(
                                                data[i]["f"],
                                                widget.namaklinik,
                                                data[i]["b"])));
                              },
                              child: ListTile(
                                  leading: CachedNetworkImage(
                                      imageUrl:
                                      "https://duakata-dev.com/miracle/media/photo/" +
                                          data[i]["e"],
                                      progressIndicatorBuilder: (context,
                                          url, downloadProgress) =>
                                          Image.asset(
                                            "assets/loadingq.gif",
                                            width: 85.0,
                                          ),
                                      imageBuilder: (context, image) =>
                                          GFIconBadge(
                                              child: CircleAvatar(
                                                backgroundImage: image,
                                                radius: 26,
                                              ),
                                              counterChild: GFBadge(
                                                color:
                                                Hexcolor("#2ECC40"),
                                                size: 18,
                                                shape:
                                                GFBadgeShape.circle,
                                              )
                                          )
                                  ),
                                  title: Container(
                                    margin: EdgeInsets.only(
                                      left: 6,
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[i]["b"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'VarelaRound'),
                                        )),
                                  ),
                                  subtitle: Container(
                                      margin: EdgeInsets.only(
                                        left: 6,
                                        top: 0,
                                        right: 0,
                                        bottom: 0,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  2.0)),
                                          Align(
                                            alignment:
                                            Alignment.bottomLeft,
                                            child: Text(
                                                data[i]["c"],
                                                style: TextStyle(
                                                    fontFamily:
                                                    'VarelaRound')),
                                          ),
                                        ],
                                      )),
                              trailing: Text("ONLINE",style: TextStyle(fontSize: 10, fontFamily:
                              'VarelaRound', color: Colors.green, fontWeight: FontWeight.bold),)
                              ),
                            )
                            :
                            data[i]['g'] == 'Offline' ?

                                Opacity(
                        opacity : 0.6,
                        child :
                            InkWell(
                              onTap: () {},
                              child: ListTile(
                                  leading: CachedNetworkImage(
                                      imageUrl:
                                      "https://duakata-dev.com/miracle/media/photo/" +
                                          data[i]["e"],
                                      progressIndicatorBuilder: (context,
                                          url, downloadProgress) =>
                                          Image.asset(
                                            "assets/loadingq.gif",
                                            width: 85.0,
                                          ),
                                      imageBuilder: (context, image) =>
                                          GFIconBadge(
                                              child: CircleAvatar(
                                                backgroundImage: image,
                                                radius: 26,
                                              ),
                                              counterChild: GFBadge(
                                                color:
                                                Colors.red,
                                                size: 18,
                                                shape:
                                                GFBadgeShape.circle,
                                              )
                                          )
                                  ),
                                  title: Container(
                                    margin: EdgeInsets.only(
                                      left: 6,
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[i]["b"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'VarelaRound'),
                                        )),
                                  ),
                                  subtitle: Container(
                                      margin: EdgeInsets.only(
                                        left: 6,
                                        top: 0,
                                        right: 0,
                                        bottom: 0,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  2.0)),
                                          Align(
                                            alignment:
                                            Alignment.bottomLeft,
                                            child: Text(
                                                data[i]["c"],
                                                style: TextStyle(
                                                    fontFamily:
                                                    'VarelaRound')),
                                          ),
                                        ],
                                      )),
                                  trailing: Text("OFFLINE",style: TextStyle(fontSize: 10, fontFamily:
                                  'VarelaRound',color: Colors.red,fontWeight: FontWeight.bold),)
                              ),
                            ))

                            :

                              ListTile(
                                  leading: CachedNetworkImage(
                                      imageUrl:
                                      "https://duakata-dev.com/miracle/media/photo/" +
                                          data[i]["e"],
                                      progressIndicatorBuilder: (context,
                                          url, downloadProgress) =>
                                          Image.asset(
                                            "assets/loadingq.gif",
                                            width: 85.0,
                                          ),
                                      imageBuilder: (context, image) =>
                                          GFIconBadge(
                                              child: CircleAvatar(
                                                backgroundImage: image,
                                                radius: 26,
                                              ),
                                              counterChild: GFBadge(
                                                color:
                                                Colors.transparent,
                                                size: 18,
                                                shape:
                                                GFBadgeShape.circle,
                                              )
                                          )
                                  ),
                                  title: Container(
                                    margin: EdgeInsets.only(
                                      left: 6,
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[i]["b"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'VarelaRound'),
                                        )),
                                  ),
                                  subtitle: Container(
                                      margin: EdgeInsets.only(
                                        left: 6,
                                        top: 0,
                                        right: 0,
                                        bottom: 0,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  2.0)),
                                          Align(
                                            alignment:
                                            Alignment.bottomLeft,
                                            child: Text(
                                                data[i]["c"],
                                                style: TextStyle(
                                                    fontFamily:
                                                    'VarelaRound')),
                                          ),
                                        ],
                                      )),
                                  trailing: Text("RESERVED",style: TextStyle(fontSize: 10, fontFamily:
                                  'VarelaRound',color: Colors.black,fontWeight: FontWeight.bold),)
                              ),


                            Padding(
                                padding: const EdgeInsets.only(
                                   left: 95, right: 15),
                                child: Divider(
                                  height: 3.0,
                                )),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 2, bottom: 5),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
 */