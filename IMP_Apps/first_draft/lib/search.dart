import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:second_app/userAccountPage.dart';

import 'myprofile.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'productdetails.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var searchData;
  //this list is from fooditem.dart
  var foodItemList = [
    {"name": "Sweet", "image": "images/food 1.png", "price": 100},
    {"name": "Sweet", "image": "images/food 2.png", "price": 200},
    {"name": "Sweet", "image": "images/food 3.png", "price": 190},
    {"name": "Sweet", "image": "images/food 5.png", "price": 200},
  ];
  final searchController = TextEditingController();
  var searchItem;

  _searchItem() async {
    String jsonn = '{"fooditemName":"${searchItem}"}';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post("http://127.0.0.1:8080/searchItem",
        headers: headers, body: jsonn);
    searchData = json.decode(response.body);
    setState(() {
      searchData;
    });
    print(searchData);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _searchItem();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
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
      body: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Material(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 2, 2),
                  child: TextField(
                    controller: searchController,
                    cursorColor: Color(0xffD34A3C),
                    decoration: InputDecoration(
                        hintText: "Search your favorite Food or City",
                        suffixIcon: InkWell(
                          child: Icon(Icons.search, color: Colors.black),
                          onTap: () {
                            searchItem = searchController.text;

                            _searchItem();
                          },
                        ),
                        border: InputBorder.none),
                  ),
                ),
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Divider(),
          if (searchData == null)
            Container()
          else
            Container(
              height: 400,
              child: ListView.builder(
                  //add [index] field as searchData[index]["fooditemName"] to display large list
                  itemCount: searchData.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (searchData == null)
                      return shimmerContainer();
                    else
                      return Container(
                          child: Material(
                              child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                    product_fooditemName: searchData[index]
                                        ['fooditemName'],
                                    //change to respective img this fooditem is  for temp. use
                                    product_fooditemImg: foodItemList[index]
                                        ['image'],

                                    product_fooditemPrice: searchData[index]
                                        ['foodPrice'],
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
                                            "${searchData[index]["fooditemName"]}",
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
                                    Text("${searchData[index]["foodPrice"]}",
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
            )
        ],
      ),
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
