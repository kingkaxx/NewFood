import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:second_app/address.dart';
import 'bottomnav.dart';
import 'package:shimmer/shimmer.dart';
import 'address.dart';
import 'package:second_app/localDB_one.dart';

class AddCart extends StatefulWidget {
  final cart_fooditemName;
  final cart_fooditemImg;
  final cart_fooditemPrice;
  final cart_foodqty;
  final loggedUser;
  var itemcount;
  var total;
  final addressSelectedname,
      addressSelectedcontactNo,
      addressSelectedpincode,
      addressSelectedcity,
      addressSelectedstate,
      addressSelectedflat,
      addressSelectedstreet,
      addressSelectedlandmark;

  AddCart(
      {this.cart_fooditemName,
      this.cart_fooditemImg,
      this.cart_fooditemPrice,
      this.cart_foodqty,
      this.loggedUser,
      this.itemcount,
      this.total,
      this.addressSelectedname,
      this.addressSelectedcity,
      this.addressSelectedcontactNo,
      this.addressSelectedflat,
      this.addressSelectedlandmark,
      this.addressSelectedpincode,
      this.addressSelectedstate,
      this.addressSelectedstreet});
  @override
  _AddCartState createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  var data, data2;
  int toto = 0;
  var finalTotal, taxTotal, change;

  _updateCart() async {
    Map<String, String> headers = {"Content-type": "application/json"};

    String jsson = '{"fooditemName":"${change}","loggedName":"${log}"}';
    print(jsson);
    http.Response response = await http.post("http://127.0.0.1:8080/updateCart",
        headers: headers, body: jsson);
    print(response.body);
    data2 = json.decode(response.body);

    print(data2);
  }

  _updateNegativeCart() async {
    String Json = '{"fooditemName":"${change}","loggedName":"${log}"}';
    Map<String, String> headers = {"Content-type": "application/json"};

    http.Response response = await http.post(
        "http://127.0.0.1:8080/updateNegativeCart",
        headers: headers,
        body: Json);
    print(response.body);
    data2 = json.decode(response.body);

    print(data2);
  }

  var delete;
  _deleteItem() async {
    String Json = '{"fooditemName":"${delete}","loggedName":"${log}"}';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(
        "http://127.0.0.1:8080/deleteCartItem",
        headers: headers,
        body: Json);
    print(response.body);
    data2 = json.decode(response.body);

    print(data2);
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

      _getCart();
      _emptyCart();
      print(log);
    });
  }

//-----------this is very imp-------------
  _emptyCart() async {
    String loggedUser = '{"loggedName":"${log}"}';
    print(loggedUser);
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post("http://127.0.0.1:8080/emptyCart",
        headers: headers, body: loggedUser);
  }

  _getCart() async {
    String loggedUser = '{"loggedName":"${log}"}';
    print(loggedUser);
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post("http://127.0.0.1:8080/getCart",
        headers: headers, body: loggedUser);
    data = json.decode(response.body);
    setState(() {
      data;
    });
    tt = 0;
    if (data == null || data.length == null)
      return null;
    else
      for (var i = 0; i < data.length; i++)
        tt = tt +
            data[i]['CartItem']["foodPrice"] * data[i]['CartItem']["itemCount"];
    return tt;
    print("ye data..");

    print(data);
    print("ye response.body");
    print(response.body);
    print("data length hai ");
    print(data.length);
  }

  int tt = 0;
//-----------------------------------------
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
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
      body: ListView(
        children: <Widget>[
          if (data == null || data.length == 0)
            if (data == null)
              Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child:
                      Center(child: SpinKitCircle(size: 80, color: Colors.red)))
            else
              Container(
                  color: Colors.white,
                  child: Center(
                      child: Container(
                    color: Colors.white,
                    height: 1000.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: Image.asset('images/noItem.png'),
                        ),
                        Text(
                          "Nothing in Cart",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: OutlineButton(
                              child: Text(
                                'Add some food items',
                                style: TextStyle(color: Color(0xffD34A3C)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BottomNav()));
                              },
                              borderSide: BorderSide(
                                color: Colors.red,
                                style: BorderStyle.solid,
                                width: 1,
                              )),
                        )
                      ],
                    ),
                  )))
          else
            Column(children: <Widget>[
              //--------using future builder--------
              // Container(
              //     height: 40,
              //     child: FutureBuilder(
              //         future: _getCart(),
              //         builder:
              //             (BuildContext context, AsyncSnapshot snapshot) {
              //           print(snapshot);
              //           if (snapshot.data == null) {
              //             return Container(child: Text("Loading..."));
              //           } else {
              //             return Container(
              //                 child: Text(snapshot.data.fooditemName));
              //           }
              //         })),
              //--------------------------------------

              Container(
                  color: Colors.white,
                  height: 300.0,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (data == null)
                        return shimmerContainer();
                      else
                        return Container(
                            child: Container(
                                child: Material(
                                    child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          height: 115.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 80),

                              Expanded(
                                child: Container(
                                    height: 90.0,
                                    width: 125.0,
                                    child: Image.network(
                                      'https://picsum.photos/250?image=9',
                                    )),
                              ),

                              //make changes to this add img url to avoid errs

                              // Expanded(
                              //   child: Container(
                              //     height: 90.0,
                              //     width: 125.0,
                              //     decoration: BoxDecoration(
                              //         image: DecorationImage(
                              //             image: AssetImage(
                              //                 widget.cart_fooditemImg),
                              //             fit: BoxFit.contain)),
                              //   ),
                              // ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 50),

                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 16, 0, 0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FittedBox(
                                          fit: BoxFit.none,
                                          child: Text(
                                            '${data[index]['CartItem']["fooditemName"]}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                      height: 4,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.none,
                                      child: Text(
                                        'Qty: ' +
                                            '${data[index]['CartItem']["foodQty"]}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                      height: 25,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        FittedBox(
                                          fit: BoxFit.none,
                                          child: InkWell(
                                              child: Text(
                                                "Save for Later",
                                                style: TextStyle(
                                                    color: Colors.blue[700]),
                                              ),
                                              onTap: () {}),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "|",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        SizedBox(width: 4),
                                        FittedBox(
                                            fit: BoxFit.none,
                                            child: InkWell(
                                              child: Text(
                                                "Remove",
                                                style: TextStyle(
                                                    color: Colors.blue[700]),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  delete =
                                                      "${data[index]['CartItem']["fooditemName"]}";
                                                  _deleteItem();
                                                  _getCart();
                                                });
                                              },
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 50),
                              Padding(
                                padding: EdgeInsets.only(top: 17),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                        "\Rs. ${data[index]['CartItem']["foodPrice"]}",
                                        style: TextStyle(fontSize: 17)),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        if (data[index]['CartItem']
                                                ["itemCount"] ==
                                            1)
                                          InkWell(
                                            child: Icon(Icons.delete),
                                            onTap: () {
                                              setState(() {
                                                delete =
                                                    "${data[index]['CartItem']["fooditemName"]}";
                                                _deleteItem();
                                                _getCart();
                                              });
                                            },
                                          )
                                        else
                                          InkWell(
                                              child: Icon(Icons.cancel),
                                              onTap: () {
                                                if (data == null) {
                                                  return null;
                                                } else
                                                  setState(() {
                                                    if (data[index]['CartItem']
                                                            ["itemCount"] >
                                                        1) {
                                                      change =
                                                          "${data[index]['CartItem']["fooditemName"]}";
                                                      data[index]['CartItem']
                                                          ["itemCount"]--;
                                                    } else {
                                                      (data[index]['CartItem']
                                                              ["itemCount"] ==
                                                          1);
                                                    }
                                                    _updateNegativeCart();
                                                  });
                                                tt = 0;
                                                for (var index = 0;
                                                    index < data.length;
                                                    index++)
                                                  tt += data[index]['CartItem']
                                                          ["foodPrice"] *
                                                      data[index]['CartItem']
                                                          ["itemCount"];
                                              }
                                              //decrementCounter,
                                              ),
                                        SizedBox(width: 10),
                                        Text(
                                            '${data[index]['CartItem']["itemCount"]}'),
                                        SizedBox(width: 10),
                                        InkWell(
                                            child: Icon(Icons.add),
                                            onTap: () {
                                              if (data == null) {
                                                return null;
                                              } else
                                                setState(() {
                                                  data[index]['CartItem']
                                                      ["itemCount"]++;
                                                  change = data[index]
                                                          ['CartItem']
                                                      ["fooditemName"];
                                                  _updateCart();

                                                  change =
                                                      "${data[index]['CartItem']["fooditemName"]}";
                                                });
                                              tt = 0;
                                              for (var index = 0;
                                                  index < data.length;
                                                  index++)
                                                tt += data[index]['CartItem']
                                                        ["foodPrice"] *
                                                    data[index]['CartItem']
                                                        ["itemCount"];
                                            }
                                            //incrementCounter,
                                            ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))));
                    },
                  )),

              Divider(),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: OutlineButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BottomNav()));
                      },
                      borderSide: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      child: Text("Add more products",
                          style: TextStyle(color: Colors.red)))),
              Divider(),
              Container(
                color: Colors.white,
                child: ListTile(
                  leading: Text("Apply Coupons",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.041,
                      )),
                  trailing: Icon(Icons.local_offer),
                ),
              ),
              Divider(),

              ListTile(
                  leading: Text(
                "Bill Details",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.041),
              )),

              ListTile(
                leading: Text("Item Total"),
                trailing: Text('${tt}'),
                // '\Rs.  ${tt += data[i]["foodPrice"] * data[i]["itemCount"]}'),
              ),

              ListTile(
                leading: Text("Taxes"),
                trailing: Text("Rs. 50"),
              ),

              ListTile(
                leading: Text(
                  "To Pay",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '\Rs. ${tt + 50}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              Divider(),
              SizedBox(height: 10),

              if (widget.addressSelectedname == null)
                Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ListTile(
                        title: Text(
                          "Deliver to",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Please select an address"),
                        trailing: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddressList()));
                          },
                          child: Text(
                            "Change",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffD34A3C)),
                          ),
                        ),
                      ),
                    ))
              else
                Container(
                    height: 140,
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        "Deliver to",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.039,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(widget.addressSelectedname +
                          "\n" +
                          widget.addressSelectedflat +
                          "\n" +
                          widget.addressSelectedstreet +
                          " " +
                          widget.addressSelectedlandmark +
                          "\n" +
                          widget.addressSelectedcity +
                          " " +
                          widget.addressSelectedstate +
                          " " +
                          widget.addressSelectedpincode +
                          "\n" +
                          "Contact no. " +
                          widget.addressSelectedcontactNo),
                      trailing: FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddressList()));
                        },
                        child: Text(
                          "Change",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffD34A3C)),
                        ),
                      ),
                    )),
              Divider(),

              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text("Total"),
                      subtitle: Text("\Rs. ${tt + 50}"),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        child: Text(
                          "Make Payment",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (widget.addressSelectedname != null) ;
                        },
                        color: Color(0xffD34A3C),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0))),
                  ))
                ],
              ),
            ])
        ],
      ),
    );
  }
}

Widget cartItem(imgPath, itemName, itemQty, itemPrice, itemCount) {
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
          child: Container(
            height: 90.0,
            width: 125.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imgPath), fit: BoxFit.contain)),
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
                    child: Text(
                      itemName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
                height: 10,
              ),
              FittedBox(
                fit: BoxFit.none,
                child: Text(
                  'Qty: ' + itemQty,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 90),
        Padding(
          padding: EdgeInsets.only(top: 17),
          child: Column(
            children: <Widget>[
              Text("\Rs. $itemPrice", style: TextStyle(fontSize: 17)),
              SizedBox(height: 3),
              Row(
                children: <Widget>[
                  InkWell(
                    child: Icon(Icons.cancel),
                    //onTap: decrementCounter,
                  ),
                  SizedBox(width: 10),
                  Text('$itemCount'),
                  SizedBox(width: 10),
                  InkWell(
                    child: Icon(Icons.add),
                    //onTap: incrementCounter,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  )));
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
