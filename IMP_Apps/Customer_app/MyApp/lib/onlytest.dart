import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  @override
  void initState() {
    super.initState();
    //_makeGetRequest();
    _dta();
  }

  var data2;
  _dta() async {
    http.Response response = await http.post("http://127.0.0.1:8080/getNested");
    data2 = json.decode(response.body);
    setState(() {
      data2;
    });
    print(data2);
  }

  Future _makePostRequest() async {
    // set up POST request arguments
    String url = 'http://127.0.0.1:8080/imgUpload';

    Map<String, String> headers = {"Content-type": "application/json"};
    //String json = '{"username": "kaustubh","password": "Hey@1234"}';
    // make post request
    Response response = await post(url, headers: headers);

    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    if (statusCode == 200) {
      print(response.body);
      // Navigator.of(context).pushNamed(LoginPage.tag);
    } else if (statusCode == 403) {
      print(response.body);
    }
  }

  List imgsss;
  Map data;
  _makeGetRequest() async {
    // set up POST request arguments
    String url = 'http://127.0.0.1:8080/download';
    http.Response response = await http.post(url);
    data = json.decode(response.body);
    setState(() {
      imgsss = [data];
    });
    print(imgsss);
    print(imgsss.length);
    print("ye response.body for img..");
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      body: ListView(children: <Widget>[
        Container(
          height: 400,
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Text("${data2[index]['First']['name']}");
              }),
        ),
        Column(
          children: <Widget>[
            Text("Test2"),
            FlatButton(
                onPressed: () {
                  _makePostRequest();
                },
                child: Text("upload")),
            FlatButton(
                onPressed: () {
                  _makeGetRequest();
                },
                child: Text("Download")),
            //Container(child: Text("${imgsss[0]["fileName"]}"))
          ],
        ),
      ]),
    );
  }
}
