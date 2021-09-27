


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mico/helper/PageRoute.dart';
import 'package:mico/page_loginstart.dart';

class IntroductionPage extends StatefulWidget{

  @override
  _IntroductionPage createState() => _IntroductionPage();
}


class _IntroductionPage extends State<IntroductionPage> {



  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontFamily: "VarelaRound",fontSize: 16);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",fontSize: 20),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: IntroductionScreen(
            globalBackgroundColor: Colors.white,
            done: Text("Login/Register"),
            onDone: (){
              Navigator.push(context, ExitPage(page: LoginStart()));
            },
            pages: [
              PageViewModel(
                  image: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      "assets/intro-1.jpg",
                    ),
                  ),
                  title: "Hi, Miraculous People",
                  body: "Selamat Datang di aplikasi telemedicine miracle",
                  footer: Text("@miracle_clinic", style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
              ),
              PageViewModel(
                  image: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      "assets/intro-4.jpg",
                    ),
                  ),
                  title: "Chat dengan dokter",
                  body: "Chat dengan dokter miracle langsung dari handphone kamu",
                  footer: Text("@miracle_clinic", style: GoogleFonts.varelaRound(),),
                  decoration: pageDecoration
              ),
              PageViewModel(
                  image: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      "assets/intro-3.jpg",
                    ),
                  ),
                  title: "Konsultasi Tatap Muka Online",
                  body: "Konsultasi tatap muka langsung dengan dokter miracle tanpa ribet dan mudah",
                  footer: Text("@miracle_clinic", style: GoogleFonts.varelaRound(),),
                  decoration: pageDecoration
              ),
            ],
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            skip: const Text('Skip'),
            next: const Icon(Icons.arrow_forward),
            curve: Curves.fastLinearToSlowEaseIn,
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
      );
  }
}