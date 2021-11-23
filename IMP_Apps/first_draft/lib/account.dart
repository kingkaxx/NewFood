
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  static String tag = 'Account';
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(appBar: AppBar(title: Text('Katsubo'),),
    body: Center(child: Text("Successfully LoggedIn!!",style: TextStyle(color: Colors.black)),));
  }
}