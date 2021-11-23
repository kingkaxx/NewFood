import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:MyApp/localDB_one.dart';
import 'package:MyApp/productdetails.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class FavItemList extends StatefulWidget {
  @override
  _FavItemListState createState() => _FavItemListState();
}

class _FavItemListState extends State<FavItemList> {
  Timer _timer;
  int _start = 0;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        for (_start = 0; _start < 2; _start++)
          if (_start == 1) {
            _check();
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
      _getfavItem();
      print(log);
    });
  }

  var favData;
  _getfavItem() async {
    String loggedUser = '{"loggedName":"${log}"}';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post("http://127.0.0.1:8080/getfavItem",
        headers: headers, body: loggedUser);
    print(response.body);
    favData = json.decode(response.body);
    setState(() {
      favData;
    });
    print(favData);
    return favData;
  }

  var favData2, delete;
  _deleteFavItem() async {
    Map<String, String> headers = {"Content-type": "application/json"};

    String jsson = '{"foodName":"${delete}","loggedName":"${log}"}';
    print(jsson);
    http.Response response = await http.post(
        "http://127.0.0.1:8080/deleteFavItem",
        headers: headers,
        body: jsson);
    print(response.body);
    favData2 = json.decode(response.body);

    print(favData2);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _getfavItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Favorite",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 17,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xffD34A3C)),
      body: ListView(children: <Widget>[
        if (favData == null || favData.length == 0)
          if (favData == null)
            Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child:
                    Center(child: SpinKitCircle(size: 80, color: Colors.red)))
          else
            Container(
              height: 700,
              child: Center(child: Text("No favorite items yet")),
            )
        else
          ListView.builder(
              itemCount: favData.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: Material(
                        child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetails(
                              product_fooditemName: favData[index]['FavItem']
                                  ['foodName'],
                              product_fooditemPrice: favData[index]['FavItem']
                                  ['foodPrice'],
                              //product_fooditemImg: ,
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 90.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Icon(Icons.delete),
                          onTap: () {
                            setState(() {
                              delete = favData[index]['FavItem']['foodName'];
                            });
                            _deleteFavItem();
                          },
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Container(
                              height: 90.0,
                              width: 125.0,
                              child: Image.network(
                                'https://i.ytimg.com/vi/tS4Un2l_Wy8/maxresdefault.jpg',
                              )),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 16, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  FittedBox(
                                    fit: BoxFit.none,
                                    child: Text(
                                      "${favData[index]['FavItem']['foodName']}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 90),
                        Padding(
                          padding: EdgeInsets.only(top: 17),
                          child: Column(
                            children: <Widget>[
                              Text("${favData[index]['FavItem']['foodPrice']}",
                                  style: TextStyle(fontSize: 17)),
                              SizedBox(height: 3),
                              Row(
                                children: <Widget>[],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )));
              }),
      ]),
    );
  }
}

Widget shimmerContainer() {
  return Container(
      child: Material(
          child: Container(
    padding: EdgeInsets.only(left: 10.0, right: 10.0),
    height: 90.0,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    child: Row(
      children: <Widget>[
        SizedBox(width: 10.0),
        Expanded(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Shimmer.fromColors(
                child: Container(
                  height: 110.0,
                  width: 145.0,
                  color: Colors.white,
                ),
                baseColor: Colors.grey[200],
                highlightColor: Colors.white),
          ),
        ),
        SizedBox(width: 10),
        Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 0, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  FittedBox(
                      fit: BoxFit.none,
                      child: Shimmer.fromColors(
                          child: Container(
                            width: 80,
                            height: 15,
                            color: Colors.white,
                          ),
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.white)),
                ],
              ),
              SizedBox(
                width: 20,
                height: 10,
              ),
              FittedBox(
                fit: BoxFit.none,
                child: Shimmer.fromColors(
                    child: Container(
                      width: 80,
                      height: 15,
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(width: 90),
        Padding(
          padding: EdgeInsets.only(top: 17),
          child: Column(
            children: <Widget>[
              Shimmer.fromColors(
                  child: Container(
                    width: 60,
                    height: 15,
                    color: Colors.white,
                  ),
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.white),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Shimmer.fromColors(
                      child: Container(
                        width: 80,
                        height: 15,
                        color: Colors.white,
                      ),
                      baseColor: Colors.grey[200],
                      highlightColor: Colors.white),
                ],
              )
            ],
          ),
        )
      ],
    ),
  )));
}
