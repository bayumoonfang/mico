import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:autostart/autostart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String token = '';
  static Future onBackgroundMessage(Map message) {
    print('onBackgroundMessage: $message');
    return null;
  }

  /*
  void checkAutoStartManager(BuildContext context) async {
    bool isAutoStartPermissionAvailable =
        await Autostart.isAutoStartPermissionAvailable;
    if (isAutoStartPermissionAvailable) {
      print('test available ok');
      Autostart.getAutoStartPermission();
    } else {
      print('test available fail');
    }
  }*/

  @override
  void initState() {
    firebaseMessaging.configure(
      onMessage: (Map message) async {
        print('onMessage: $message');
      },
      onBackgroundMessage: onBackgroundMessage,
      onResume: (Map message) async {
        print('onResume: $message');
      },
      onLaunch: (Map message) async {
        print('onLaunch: $message');
      },
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true),
    );
    firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      debugPrint('Settings registered: $settings');
    });
    firebaseMessaging.getToken().then((token) => setState(() {
          this.token = token;
          print("TOKEN : " + token);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              token,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // checkAutoStartManager(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
