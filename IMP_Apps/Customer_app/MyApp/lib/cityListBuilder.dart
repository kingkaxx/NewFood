import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'productdetails.dart';

class CityListBuilder extends StatefulWidget {
  final cityName;
  final cityitemName;

  CityListBuilder({this.cityitemName, this.cityName});

  @override
  _CityListBuilderState createState() => _CityListBuilderState();
}

class _CityListBuilderState extends State<CityListBuilder> {
  var cityData;
  _getCityList() async {
    String cityName = '{"cityName":"${widget.cityName}"}';
    Map<String, String> headers = {"Content-type": "application/json"};

    http.Response response = await http.post(
        'http://127.0.0.1:8080/getCityList',
        headers: headers,
        body: cityName);
    cityData = json.decode(response.body);
    setState(() {
      cityData;
    });
    print(cityData);
  }

  void initState() {
    super.initState();
    _getCityList();
  }

  //this list is from fooditem.dart
  var foodItemList = [
    {"name": "Sweet", "image": "images/food 1.png", "price": 100},
    {"name": "Sweet", "image": "images/food 2.png", "price": 200},
    {"name": "Sweet", "image": "images/food 3.png", "price": 190},
    {"name": "Sweet", "image": "images/food 5.png", "price": 200},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "SnackLord",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 17,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xffD34A3C)),
      body: ListView(children: <Widget>[
        if (cityData == null)
          Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return shimmerContainer();
                  }))
        else
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: cityData.length,
                itemBuilder: (BuildContext context, int index) {
                  if (cityData == null)
                    return shimmerContainer();
                  else
                    //only 2 cats were assigned to db

                    return Container(
                        child: Material(
                            child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => ProductDetails(
                                  product_fooditemName: cityData[index]["name"],
                                  //change to respective img this fooditem is  for temp. use
                                  product_fooditemImg: foodItemList[index]
                                      ['image'],

                                  product_fooditemPrice: cityData[index]
                                      ["price"],
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
                                          "${cityData[index]["name"]}",
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
                                  Text("${cityData[index]["price"]}",
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
          ),
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
