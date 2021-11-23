import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:second_app/addNewAddress.dart';
import 'package:second_app/cart.dart';
import 'package:second_app/editAddress.dart';
import 'package:shimmer/shimmer.dart';

import 'localDB_one.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  Timer _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        for (_start = 0; _start < 2; _start++)
          if (_start == 1) {
            _addressRetrieve();
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

//edit api is remaining
  var addList;
  _addressRetrieve() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String logged = '{"loggedName":"${log}"}';
    http.Response response = await http.post(
        "http://127.0.0.1:8080/addressList",
        headers: headers,
        body: logged);
    addList = json.decode(response.body);
    setState(() {
      addList;
    });
  }

  var delete;
  _deleteAddress() async {
    String name = '{"name":"${delete}","loggedName":"${log}"}';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(
        "http://127.0.0.1:8080/deleteAddress",
        headers: headers,
        body: name);
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
        title: Text(
          "Select a shipping address",
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
      body: ListView(
        children: <Widget>[
          if (addList == null)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 55,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                addNewAddress()));
                      },
                      child: ListTile(
                          leading: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          title: Text(
                            "          Add new address",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.039,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                      color: Color(0xffD34A3C),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(child: Text("Loading...")),
                  )
                ],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                addNewAddress()));
                      },
                      child: ListTile(
                          leading: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          title: Text(
                            "          Add new address",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.039,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                      color: Color(0xffD34A3C),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (addList == null || addList.length == 0)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.76,
                      child: Center(child: Text("Nothing in saved address")),
                    )
                  else
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: addList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddCart(
                                          addressSelectedname: addList[index]
                                              ['Address']["name"],
                                          addressSelectedcontactNo:
                                              addList[index]['Address']
                                                  ["contactNo"],
                                          addressSelectedcity: addList[index]
                                              ['Address']["city"],
                                          addressSelectedstate: addList[index]
                                              ['Address']["state"],
                                          addressSelectedflat: addList[index]
                                              ['Address']["flatNo"],
                                          addressSelectedpincode: addList[index]
                                              ['Address']["pincode"],
                                          addressSelectedlandmark:
                                              addList[index]['Address']
                                                  ["landmark"],
                                          addressSelectedstreet: addList[index]
                                              ['Address']["street"],
                                        )));
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                          "${addList[index]['Address']["name"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        "${addList[index]['Address']["flatNo"]}" +
                                            " " +
                                            "\n${addList[index]['Address']["street"]}" +
                                            " " +
                                            "${addList[index]['Address']["landmark"]}" +
                                            "\n${addList[index]['Address']["city"]}" +
                                            ", " +
                                            "${addList[index]['Address']["state"]}" +
                                            " " +
                                            "${addList[index]['Address']["pincode"]}" +
                                            "\nIndia" +
                                            "\nContact number: ${addList[index]['Address']["contactNo"]}",
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: OutlineButton(
                                            borderSide: BorderSide(
                                                color: Color(0xffD34A3C)),
                                            splashColor: Color(0xffD34A3C),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          editAddress(
                                                              name: addList[
                                                                          index]
                                                                      [
                                                                      'Address']
                                                                  ["name"])));
                                            },
                                            child: Text("Edit",
                                                style: TextStyle(
                                                    color: Color(0xffD34A3C))),
                                            color: Color(0xffD34A3C),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                delete =
                                                    "${addList[index]['Address']["name"]}";
                                                _deleteAddress();
                                              });
                                              _addressRetrieve();
                                              Center(
                                                  child: SpinKitWave(
                                                      color: Colors.red,
                                                      type: SpinKitWaveType
                                                          .start));
                                            },
                                            child: Text("Remove",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            color: Color(0xffD34A3C),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 28)
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
