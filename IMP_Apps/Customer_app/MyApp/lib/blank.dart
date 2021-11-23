import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:MyApp/search.dart';
import 'bottomnav.dart';
import 'userAccountPage.dart';
import 'myprofile.dart';
import 'package:shimmer/shimmer.dart';

class blankAddCart extends StatefulWidget {
  @override
  _blankAddCartState createState() => _blankAddCartState();
}

class _blankAddCartState extends State<blankAddCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cart",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            new IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          ],
          backgroundColor: Color(0xffD34A3C),
        ),
        body: Stack(children: <Widget>[
          ListView(children: <Widget>[
            Column(children: <Widget>[
              Container(
                  color: Colors.white,
                  child: Center(
                      child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.92,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.2),
                          child: Image.asset('images/noItem.png'),
                        ),
                        Text(
                          "Nothing in Cart",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.2),
                          child: OutlineButton(
                              child: Text(
                                'Add some food items',
                                style: TextStyle(color: Color(0xffD34A3C)),
                              ),
                              onPressed: () {
                                BottomNav();
                              },
                              borderSide: BorderSide(
                                color: Colors.red,
                                style: BorderStyle.solid,
                                width: 1,
                              )),
                        )
                      ],
                    ),
                  ))),
            ])
          ])
        ]));
  }
}
