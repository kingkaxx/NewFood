import 'dart:async';

import 'package:flutter/material.dart';
import 'package:MyApp/cart.dart';
import 'package:MyApp/myprofile.dart';
import 'package:MyApp/search.dart';
import 'package:MyApp/userAccountPage.dart';
import 'package:http/http.dart' as http;
import 'blank.dart';
import 'package:connectivity/connectivity.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // var _connectionStatus = "none";
  // var res;
  // Connectivity connectivity;
  // StreamSubscription<ConnectivityResult> subscription;
  // @override
  // void initState() {
  //   super.initState();
  //   connectivity = new Connectivity();
  //   subscription =
  //       connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
  //     _connectionStatus = result.toString();
  //     if (result == ConnectivityResult.mobile ||
  //         result == ConnectivityResult.wifi) {
  //       res = "true";
  //       print("Connected");
  //     }
  //   });
  // }

  @override
  void dispose() {
    // subscription.cancel();
    super.dispose();
  }

  int _currentIndex = 0;
  final tabs = [
    Center(child: userAccountPage()),
    Center(child: Search()),
    Center(child: Container(child: AddCart())),
    Center(child: MyProfile()),
    Center(child: Container(child: blankAddCart()))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        // if (res == "true")
        tabs[_currentIndex]
        // else
        // Container(
        //   child: Center(child: Text("Please connect to internet")),
        // )
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xffD34A3C),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
