/*TextField(
                           focusNode: _focus,
                                 decoration: InputDecoration(
                                     floatingLabelBehavior: FloatingLabelBehavior.never,
                                     contentPadding: const EdgeInsets.only(top : 5,left: 10),
                                     prefixIcon: Icon(Icons.search,size: 16,),
                                     prefixStyle: TextStyle(fontSize: 12),
                                     filled: true,
                                     fillColor: HexColor("#f9f7f7"),
                                     enabledBorder: OutlineInputBorder(
                                         borderSide: BorderSide(
                                             color: Colors.white,
                                             width: 1.0
                                         ),
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(5.0)
                                         )
                                     ),
                                     hintText: "Cari Dokter...",
                                     hintStyle: TextStyle(
                                         fontFamily: 'VarelaRound',
                                         fontSize: 14)
                                 ),
                               )*/




/* Container(
                            margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10),
                            height: 30.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        //side: BorderSide(color: Colors.red)
                                    ),
                                      child : Text("Semua", style: TextStyle(
                                          fontFamily: 'VarelaRound')),
                                    onPressed: ()  async {
                                      getFilter = '';
                                      data.clear();
                                     await _datafield();
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      //side: BorderSide(color: Colors.red)
                                    ),
                                    child : Text("Online", style: TextStyle(
                                        fontFamily: 'VarelaRound')),
                                    onPressed: ()  async {
                                      getFilter = 'Online';
                                      data.clear();
                                      const TIMEOUT = const Duration(seconds: 50);
                                      Future.delayed(TIMEOUT,() => getData());
                                    }
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      //side: BorderSide(color: Colors.red)
                                    ),
                                    child : Text("Offline", style: TextStyle(
                                        fontFamily: 'VarelaRound')),
                                    onPressed: ()  async {
                                      getFilter = 'Offline';
                                      data.clear();
                                      await _datafield();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      //side: BorderSide(color: Colors.red)
                                    ),
                                    child : Text("Reserved", style: TextStyle(
                                        fontFamily: 'VarelaRound')),
                                    onPressed: ()  async {
                                      getFilter = 'Reserved';
                                      data.clear();
                                       await _datafield();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),*/
