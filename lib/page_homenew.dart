




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PageHomeNew extends StatefulWidget {

  @override
  _PageHomeNew createState() => _PageHomeNew();
}


class _PageHomeNew extends State<PageHomeNew> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top:10),
          child: Column(
            children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 150,
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 30),child:
                  //Text("Mico",style: GoogleFonts.comfortaa(fontSize: 22,fontWeight: FontWeight.bold),),),)
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Mico",style: GoogleFonts.fredokaOne(fontSize: 30,fontWeight: FontWeight.bold)),
                      Padding(padding: const EdgeInsets.only(right: 10),child: FaIcon(FontAwesomeIcons.cog,size: 24,),)
                    ],
                  )

                    ,),),
                  Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 5),child:
                  Text("Hai, Ragil Bayu Respati,",style: GoogleFonts.nunitoSans(fontSize: 16),),),),
                  Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 5),child:
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.mapMarker,size: 13,),
                      Padding(padding: const EdgeInsets.only(left: 7),child: Text(
                          "Jl. Abdul Muis no3 "
                      ),)
                    ],
                  )
                    ,),),
                ],
              ),
            ),


              Container(
                height: 200,
                width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0)),
                  )
              )
              
              
              
            ],
          ),
      ),
    );
  }
}