import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:MyApp/regpage.dart';
import 'package:MyApp/splashscreen.dart';
import 'package:MyApp/userAccountPage.dart';
import 'bottomnav.dart';
import 'loginpage.dart';
import 'account.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    Account.tag: (context) => Account(),
    RegPage.tag: (context) => RegPage()
  };
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'SnackLord',
      home: RegPage(),
      routes: routes,
    );
  }
}
