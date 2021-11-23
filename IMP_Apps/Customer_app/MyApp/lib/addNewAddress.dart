import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MyApp/address.dart';
import 'package:MyApp/localDB_one.dart';
import 'package:shimmer/shimmer.dart';

class addNewAddress extends StatefulWidget {
  @override
  _addNewAddressState createState() => _addNewAddressState();
}

class _addNewAddressState extends State<addNewAddress> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final contactNoController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final flatController = TextEditingController();
  final streetController = TextEditingController();
  final landmarkController = TextEditingController();
  var fullNameControllerData,
      contactNoControllerData,
      pincodeControllerData,
      cityControllerData,
      stateControllerData,
      flatControllerData,
      streetControllerData,
      landmarkControllerData;

  @override
  void dispose() {
    fullNameController.dispose();
    contactNoController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    flatController.dispose();
    streetController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

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

      print(log);
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  _addressSaved() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String address =
        '{"name":"${fullNameControllerData}","contactNo":"${contactNoControllerData}","pincode":"${pincodeControllerData}","city":"${cityControllerData}","state":"${stateControllerData}","flatNo":"${flatControllerData}","street":"${streetControllerData}","landmark":"${landmarkControllerData}","loggedName":"${log}"}';
    http.Response response = await http.post("http://127.0.0.1:8080/addAddress",
        headers: headers, body: address);

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New shipping address",
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
          Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Enter a shipping address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                          ),
                          validator: (val) =>
                              val.length < 3 ? "Enter valid name" : null),
                      TextFormField(
                          controller: contactNoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Contact Number",
                          ),
                          validator: (val) =>
                              val.length != 10 ? "Enter valid number" : null),
                      TextFormField(
                          controller: pincodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Pincode",
                          ),
                          validator: (val) =>
                              val.length != 6 ? "Enter valid pincode" : null),
                      TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                            hintText: "City",
                          ),
                          validator: (val) =>
                              val.length < 3 ? "Enter valid City" : null),
                      TextFormField(
                          controller: stateController,
                          decoration: InputDecoration(
                            hintText: "State",
                          ),
                          validator: (val) =>
                              val.length < 3 ? "Enter valid State" : null),
                      TextFormField(
                          controller: flatController,
                          decoration: InputDecoration(
                            hintText: "Flat no., Building, Apartment",
                          ),
                          validator: (val) =>
                              val.length < 4 ? "Enter valid Address" : null),
                      TextFormField(
                          controller: streetController,
                          decoration: InputDecoration(
                            hintText: "Street name",
                          ),
                          validator: (val) =>
                              val.length < 4 ? "Enter valid name" : null),
                      TextFormField(
                          controller: landmarkController,
                          decoration: InputDecoration(
                            hintText: "Landmark e.g. near conrad hotel",
                          ),
                          validator: (val) =>
                              val.length < 4 ? "Enter valid landmark" : null),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          color: Color(0xffD34A3C),
                          child: Text("Add Address",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              fullNameControllerData = fullNameController.text;
                              contactNoControllerData =
                                  contactNoController.text;
                              pincodeControllerData = pincodeController.text;
                              cityControllerData = cityController.text;
                              stateControllerData = stateController.text;
                              flatControllerData = flatController.text;
                              streetControllerData = streetController.text;
                              landmarkControllerData = landmarkController.text;

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddressList()));
                              _addressSaved();
                            }
                            // _addressSaved();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
