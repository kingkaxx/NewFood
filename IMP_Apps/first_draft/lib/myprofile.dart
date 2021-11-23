import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:second_app/address.dart';
import 'package:second_app/favorite.dart';
import 'package:second_app/loginpage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'localDB_one.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _formKey = GlobalKey<FormState>();

  Timer _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        for (_start = 0; _start < 2; _start++)
          if (_start == 1) {
            _userInfo();
            timer.cancel();
          }
      }),
    );
  }

  var log;
  _check() async {
    LocalDB.readFromFile().then((context) {
      setState(() {
        log = context;
      });

      print(log);
    });
  }

  _logout() {
    LocalDB.deleteFromFile();
  }

  _nested() async {
    String loggedUser = '{"loggedName":"${log}"}';
    print(loggedUser);
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post("http://127.0.0.1:8080/nested",
        headers: headers, body: loggedUser);
  }

  var userInfo;
  _userInfo() async {
    String loggedUser = '{"loggedName":"${log}"}';
    print(loggedUser);
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post("http://127.0.0.1:8080/userInfo",
        headers: headers, body: loggedUser);
    setState(() {
      userInfo;
    });
    userInfo = json.decode(response.body);
    print(userInfo);
  }

  @override
  void initState() {
    super.initState();
    _check();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
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
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.white,
      //   type: BottomNavigationBarType.fixed,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //           child: Icon(Icons.home, color: Colors.black),
      //           onTap: () => Navigator.of(context).push(new MaterialPageRoute(
      //               builder: (context) => new userAccountPage()))),
      //       title: Text('Home', style: TextStyle(color: Colors.black)),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search, color: Colors.black),
      //       title: Text('Search', style: TextStyle(color: Colors.black)),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart, color: Colors.black),
      //       title: Text('Cart', style: TextStyle(color: Colors.black)),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //         child: Icon(Icons.person, color: Color(0xffD34A3C)),
      //         onTap: () => Navigator.of(context).push(
      //             new MaterialPageRoute(builder: (context) => new MyProfile())),
      //       ),
      //       title: Text('Profile', style: TextStyle(color: Colors.black)),
      //     ),
      //   ],
      // ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    if (log == null || userInfo == null)
                      Material(
                        child: Shimmer.fromColors(
                            child: Container(
                              color: Colors.white,
                              height: 90,
                              width: MediaQuery.of(context).size.width,
                            ),
                            baseColor: Colors.grey[200],
                            highlightColor: Colors.white),
                      )
                    else
                      ListTile(
                        title: FittedBox(
                          fit: BoxFit.cover,
                          child: Text("Hello, ${log}"),
                        ),
                        subtitle: Text("${userInfo[0]['User']['mobile']}"),
                        trailing: FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
                                      content: Form(
                                        key: _formKey,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.33,
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                title: Text(
                                                  "Edit Info.",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              ListTile(
                                                  title: TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Name.'),
                                                autofocus: false,
                                                cursorColor: Color(0xffD34A3C),
                                              )),
                                              ListTile(
                                                  title: TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Mobile No.'),
                                                autofocus: false,
                                                cursorColor: Color(0xffD34A3C),
                                                maxLength: 10,
                                              )),
                                              Divider(),
                                              FlatButton(
                                                onPressed: () {},
                                                child: ListTile(
                                                  leading: Icon(Icons.update,
                                                      color: Colors.white),
                                                  title: Text(
                                                    "Update changes",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                color: Color(0xffD34A3C),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(30.0)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                });
                          },
                          child: FittedBox(
                            child: Text(
                              "EDIT",
                              style: TextStyle(
                                  color: Color(0xffD34A3C),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FavItemList()));
                  },
                  child: ListTile(
                    leading: FittedBox(
                        fit: BoxFit.none,
                        child: Text(
                          "Favorites",
                          style: TextStyle(fontSize: 17),
                        )),
                    trailing: Icon(Icons.favorite),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddressList()));
                  },
                  child: ListTile(
                    leading: FittedBox(
                        fit: BoxFit.none,
                        child:
                            Text("Addresses", style: TextStyle(fontSize: 17))),
                    trailing: Icon(Icons.local_mall),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _nested();
                  },
                  child: ListTile(
                    title: Text("Wallet"),
                    trailing: Icon(Icons.account_balance_wallet),
                  ),
                ),
                ListTile(
                  title: Text("My orders"),
                  trailing: Icon(Icons.shopping_basket),
                ),
                ListTile(
                  title: Text("Offers"),
                  trailing: Icon(Icons.swap_horizontal_circle),
                ),
                Divider(),
                Divider(),
                ListTile(
                  title: Text("Settings"),
                  trailing: Icon(Icons.settings),
                ),
                ListTile(
                  title: Text("Customer Service"),
                  trailing: Icon(Icons.call_to_action),
                ),
                ListTile(
                  title: Text("FAQs"),
                  trailing: Icon(Icons.question_answer),
                ),
                ListTile(
                  title: Text("About Us"),
                  trailing: Icon(Icons.people_outline),
                ),
                InkWell(
                  onTap: () {
                    _logout();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
                  },
                  child: ListTile(
                    title: Text("Logout"),
                    trailing: Icon(Icons.exit_to_app),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
