

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:steps/steps.dart';
import 'package:steps_indicator/steps_indicator.dart';


class DetailAppointment extends StatefulWidget {
  final String idAppointment;
  const DetailAppointment(this.idAppointment);
  @override
  _DetailAppointmentState createState() => new _DetailAppointmentState();
}



class _DetailAppointmentState extends State<DetailAppointment> {
  Widget _createEventControlBuilder(BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

        ]
    );
  }

  int _currentstep = 0;
  StepState _getState(int i) {
    if (_currentstep >= i)
      return StepState.complete;
    else
      return StepState.indexed;
  }

  StepState _getState2(int i) {
    return StepState.complete;
  }

  bool getIsActive(int currentIndex){
    return true;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        backgroundColor: Hexcolor("#075e55"),
        title: Text(
          "Detail Appointment",
          style: TextStyle(
              color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
        ),
        leading: Builder(
          builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => {
                Navigator.pop(context)
              }),
        ),
      ),
      body:
      ResponsiveContainer(
        widthPercent: 100,
    heightPercent: 100,
    child : SingleChildScrollView(
    child :
      Column(
        children: [
          ResponsiveContainer(
            heightPercent: 9,
            widthPercent: 100,
            child:
            Theme(
                data: ThemeData(
                    primaryColor: Colors.green,
                  textSelectionColor: Colors.red
                ),
            child :
            Stepper(
              type: StepperType.horizontal,
              controlsBuilder: _createEventControlBuilder,
              steps: [
                Step(
                    isActive: true,
                    title: Text(""),
                    content: Text(""),
                    state: _getState(0)
                ),
                Step(
                    isActive: false,
                    title: Text(""),
                    content: Text(""),
                    state: _getState(1)
                ),
                Step(
                    isActive: false,
                    title: Text(""),
                    content: Text(""),
                    state: _getState(2)
                ),
              ],
            )),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Container(
              color:  Hexcolor("#DDDDDD"),
              width: double.infinity,
              height: 10,
            ),
          ),
          ResponsiveContainer(
            widthPercent: 100,
            heightPercent: 80,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child:
            Steps(
              direction: Axis.vertical,
              size: 10.0,
              path: {'color': Hexcolor("#DDDDDD"), 'width': 1.0},
              steps: [
                {
                  'background': Colors.green,
                  'label': '',
                  'content':
                  Padding(
                    padding : const EdgeInsets.only(top: 0),
                  child :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding (
                      padding : const EdgeInsets.only(bottom: 10),
                      child :
                      Text(
                        'Waiting Approval',
                        style: TextStyle(
                            fontSize: 16,
                            color: Hexcolor("#516067"),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'VarelaRound'),
                      )),
                      Text(
                        'Status appointment anda sekarang adalah masih menunggu approval dari dokter',
                          style: TextStyle(
                              fontSize: 12,
                              color: Hexcolor("#516067"),
                              fontFamily: 'VarelaRound')
                      ),
                    ],
                    )
                  ),
                },

                {
                  'background': Colors.green,
                  'label': '',
                  'content':
                  Padding(
                      padding : const EdgeInsets.only(top: 0),
                      child :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding (
                              padding : const EdgeInsets.only(bottom: 10),
                              child :
                              Text(
                                'Appointment Approved',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Hexcolor("#516067"),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'VarelaRound'),
                              )),
                          Text(
                              'Status appointment anda sekarang adalah masih menunggu approval dari dokter',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor("#516067"),
                                  fontFamily: 'VarelaRound')
                          ),
                        ],
                      )
                  ),
                },
                {
                  'background': Colors.green,
                  'label': '',
                  'content':
                  Padding(
                      padding : const EdgeInsets.only(top: 0),
                      child :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding (
                              padding : const EdgeInsets.only(bottom: 10),
                              child :
                              Text(
                                'Menunggu Pembayaran',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Hexcolor("#516067"),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'VarelaRound'),
                              )),
                          Text(
                              'Status appointment anda adalah Menunggu Pembayaran , '
                                  'silahkan melakukan pembayaran ke rekening sesuai tagihan yang kami kirimkan. Jika sudah melakukan pembayaran silahkan melakukan konfirmasi dibawah ini',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor("#516067"),
                                  fontFamily: 'VarelaRound')
                          ),
                          RaisedButton(
                            child: Text("Konfirmasi"),
                          )
                        ],
                      )
                  ),
                },


                {
                  'background': Colors.green,
                  'label': '',
                  'content':
                  Padding(
                      padding : const EdgeInsets.only(top: 0),
                      child :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding (
                              padding : const EdgeInsets.only(bottom: 10),
                              child :
                              Text(
                                'Pembayaran Terverifikasi',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Hexcolor("#516067"),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'VarelaRound'),
                              )),
                          Text(
                              'Terima Kasih telah melakukan pembayaran, anda dapat langsung melakukan konsultasi dengan dokter',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor("#516067"),
                                  fontFamily: 'VarelaRound')
                          ),
                        ],
                      )
                  ),
                },


                {
                  'background': Colors.green,
                  'label': '',
                  'content':
                  Padding(
                      padding : const EdgeInsets.only(top: 0),
                      child :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding (
                              padding : const EdgeInsets.only(bottom: 10),
                              child :
                              Text(
                                'Konsultasi Berjalan',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Hexcolor("#516067"),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'VarelaRound'),
                              )),
                          Text(
                              'Anda bisa masuk ke room konsultasi dengan klik button yang ada dibawah ini .',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor("#516067"),
                                  fontFamily: 'VarelaRound')
                          ),
                            RaisedButton(
                                child: Text("Konsultasi"),
                            )
                        ],
                      )
                  ),
                },

                {
                  'background': Colors.green,
                  'label': '',
                  'content':
                  Padding(
                      padding : const EdgeInsets.only(top: 0),
                      child :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding (
                              padding : const EdgeInsets.only(bottom: 10),
                              child :
                              Text(
                                'Selesai',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Hexcolor("#516067"),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'VarelaRound'),
                              )),
                          Text(
                              'Terima Kasih telah menggunakan layanan konsultasi online Miracle.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Hexcolor("#516067"),
                                  fontFamily: 'VarelaRound')
                          ),
                        ],
                      )
                  ),
                },

              ],
            ),
          )


            ],
          )
        )
      )
    );
  }
}