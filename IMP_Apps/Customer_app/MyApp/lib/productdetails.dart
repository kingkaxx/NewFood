import 'dart:async';
import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:MyApp/bottomnav.dart';
import 'package:MyApp/cart.dart';
import 'package:MyApp/search.dart';
import 'fooditems.dart';
import 'package:MyApp/localDB_one.dart';
import 'userAccountPage.dart';
import 'myprofile.dart';

class ProductDetails extends StatefulWidget {
  static String tag = 'Product-Details';
  final product_fooditemName;
  final product_fooditemImg;
  final product_fooditemPrice;

  ProductDetails(
      {this.product_fooditemName,
      this.product_fooditemImg,
      this.product_fooditemPrice});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var quantity = ['250gm', '500gm', '1kg', '2kg'];
  var currentItem = 'Qty';
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _controller;
  bool isFavorite = false;
  bool check = false;
  var cart_foodqty;
  var itemcount;
  List list = ["1", "2", "3", "4"];

  var total;
  int _counter = 0;
  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      } else {
        _counter = 0;
      }
    });
  }

  int itemPrice = 200;
  int price() {
    return itemPrice;
  }

  var log;
  _check() async {
    LocalDB.readFromFile().then((context) {
      setState(() {
        log = context;
      });
    });

    print(log);
  }

  @override
  void initState() {
    super.initState();
    _check();
    startTimer();
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
            _checkFavItem();
            _getCart();
            timer.cancel();
          }
      }),
    );
  }

  Timer _timer2;
  int _start2 = 0;

  void startAgain() {
    const oneSec = const Duration(seconds: 1);
    _timer2 = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        for (_start = 0; _start2 < 2; _start2++)
          if (_start2 == 1) {
            _getCart();
            timer.cancel();
          }
      }),
    );
  }

  String logged = "no data";
  _addToCart() async {
    String url = 'http://127.0.0.1:8080/cart';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"fooditemName":"${widget.product_fooditemName}","foodQty":"${cart_foodqty}","foodPrice":${widget.product_fooditemPrice},"itemCount":$_counter,"loggedName":"${log}"}';
    print(json + "  ye _addCart wala hai");
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      print(response.body);
    } else if (statusCode == 403) {
      print(response.body);
    }
  }

  var data8;
  int dln = 0;
  _getCart() async {
    String loggedUser = '{"loggedName":"${log}"}';
    print(loggedUser);
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post("http://127.0.0.1:8080/getCart",
        headers: headers, body: loggedUser);
    data8 = json.decode(response.body);
    setState(() {
      data8;
    });
    if (data8 == null)
      return dln = dln + _counter;
    else
      dln = data8.length;

    print(data8);
    print("ye response.body");
    print(response.body);
    print("data length hai ");
    print(data8.length);
  }

  var favData;
  _favItem() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String Json =
        '{"foodName":"${widget.product_fooditemName}","foodPrice":"${widget.product_fooditemPrice}","loggedName":"${log}"}';
    http.Response response = await http.post("http://127.0.0.1:8080/favItem",
        headers: headers, body: Json);
    print(response.body);
    favData = json.decode(response.body);

    print(favData);
  }

  var favData2;
  _deleteFavItem() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsson =
        '{"foodName":"${widget.product_fooditemName}","loggedName":"${log}"}';
    http.Response response = await http.post(
        "http://127.0.0.1:8080/deleteFavItem",
        headers: headers,
        body: jsson);
    print(response.body);
    favData2 = json.decode(response.body);

    print(favData2);
  }

  var favData3;
  _checkFavItem() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String jssson =
        '{"foodName":"${widget.product_fooditemName}","loggedName":"${log}"}';
    http.Response response = await http.post(
        "http://127.0.0.1:8080/checkFavItem",
        headers: headers,
        body: jssson);
    setState(() {
      favData3;
    });
    print(response.body);
    favData3 = json.decode(response.body);
    // return favData3;
    print(favData3);
  }

  void cartAddedMsg() {
    final snackbar = new SnackBar(
      content: new Text("Item added to cart!"),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
          title: Text(
            "SnacLord",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 17,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width / 27,
              width: MediaQuery.of(context).size.width * 0.1,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddCart()));
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 14, right: 20),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width / 13,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, bottom: 20),
                      child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text("${dln}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
          backgroundColor: Color(0xffD34A3C)),
      body: Stack(children: <Widget>[
        ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.9, top: 10),
                child: Row(
                  children: <Widget>[
                    if (favData3 != null)
                      if ('${favData3["FavItem"]["foodName"]}' ==
                          widget.product_fooditemName)
                        if (isFavorite == false)
                          InkWell(
                            child: Icon(Icons.favorite, color: Colors.red),
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              _deleteFavItem();
                            },
                          )
                        else
                          InkWell(
                            child:
                                Icon(Icons.favorite, color: Colors.grey[400]),
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              _favItem();
                            },
                          )
                      else
                        Row(
                          children: <Widget>[
                            if (isFavorite == false)
                              InkWell(
                                child: Icon(Icons.favorite,
                                    color: Colors.grey[400]),
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                  _favItem();
                                },
                              )
                            else
                              InkWell(
                                child: Icon(Icons.favorite, color: Colors.red),
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                  _deleteFavItem();
                                },
                              )
                          ],
                        )
                    else
                      Row(
                        children: <Widget>[
                          if (isFavorite == false)
                            InkWell(
                              child:
                                  Icon(Icons.favorite, color: Colors.grey[400]),
                              onTap: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                _favItem();
                              },
                            )
                          else
                            InkWell(
                              child: Icon(Icons.favorite, color: Colors.red),
                              onTap: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                _deleteFavItem();
                              },
                            )
                        ],
                      )
                  ],
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.33,
              child: GridTile(
                child: Container(
                  color: Colors.transparent,
                  child: Carousel(
                    boxFit: BoxFit.contain,
                    images: [
                      Image.asset(widget.product_fooditemImg),
                      AssetImage('images/food 4.png'),
                      AssetImage('images/food 5.png'),
                      AssetImage('images/food 6.png'),
                    ],
                    autoplay: false,
                    indicatorBgPadding: 0.0,
                    dotSize: 6.0,
                    dotColor: Color(0xffD34A3C),
                    dotBgColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Text(widget.product_fooditemName,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 16)),
                    trailing: Text(
                        //"\Rs. ${price()}",
                        "\Rs. ${widget.product_fooditemPrice}",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 16)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.04, 1, 5, 1),
                        child: DropdownButton<String>(
                          items: quantity.map((String dropDownItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownItem,
                              child: Text(dropDownItem),
                            );
                          }).toList(),
                          onChanged: (String newDropDownItem) {
                            setState(() {
                              this.currentItem = newDropDownItem;
                              cart_foodqty = newDropDownItem;
                              if (cart_foodqty == '250gm') {
                                _counter = 1;
                              } else if (cart_foodqty == '500gm') {
                                _counter = 1;
                              } else if (cart_foodqty == '1kg') {
                                _counter = 1;
                              } else if (cart_foodqty == '2kg') {
                                _counter = 1;
                              }
                            });
                          },
                          //value: currentItem,
                          hint: Text(
                            currentItem,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.47),
                          child: InkWell(
                            child: Icon(Icons.cancel),
                            onTap: decrementCounter,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: Text('$_counter'),
                      ),
                      InkWell(
                        child: Icon(Icons.add),
                        onTap: incrementCounter,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.048,
                height: MediaQuery.of(context).size.width * 0.11,
                color: Color(0xffD34A3C),
                child: MaterialButton(
                  elevation: 10.0,
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.048,
                        color: Colors.white),
                  ),
                  minWidth: 100,
                  height: MediaQuery.of(context).size.width * 0.03,
                  onPressed: () {
                    if (cart_foodqty != null && _counter != 0) {
                      _addToCart();
                      cartAddedMsg();
                      startAgain();
                    } else {
                      return null;
                    }
                  },
                )),
            Divider(),
            Container(
                height: MediaQuery.of(context).size.width * 0.11,
                color: Color(0xffD34A3C),
                child: MaterialButton(
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.048,
                        color: Colors.white),
                  ),
                  minWidth: 100,
                  height: MediaQuery.of(context).size.width * 0.03,
                  onPressed: () {
                    _check();
                    if (cart_foodqty != null && _counter != 0) {
                      if (logged == null)
                        return null;
                      else
                        Navigator.of(context).push(new MaterialPageRoute(
                            //this is passing values to product page
                            builder: (context) => new AddCart(
                                cart_fooditemName: widget.product_fooditemName,
                                cart_fooditemImg: widget.product_fooditemImg,
                                cart_fooditemPrice:
                                    widget.product_fooditemPrice,
                                cart_foodqty: cart_foodqty,
                                loggedUser: log,
                                itemcount: _counter,
                                total:
                                    widget.product_fooditemPrice * _counter)));
                    } else {
                      return null;
                    }
                    _addToCart();
                  },
                )),
            Divider(),
            Container(
              color: Colors.white,
              child: GridTile(
                child: Container(
                  color: Colors.white,
                  child: Text(
                      "cvygbuhnijmko vygbuhnijmk,l cvgbhnj ctvybunimo dcftvgybuhnjimk cfvgbuhnjim fvgbuhnijmk tvybunmi vbuhnijm cvtybunio ydctfvygbuhnijmo cvybunimo dcfvgybhunjimko 35rftgyuhnijmk 7ertvybuhnijmk ecrtvybunijmk edfgyuhnijmk 3e4r56t7yh8ujik 5drftgyhui 7excrtvybuhnjmk 7de5rtybuhnijmk ed5rftgyunim rftyu"),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
              child: Text(
                'Similar Items',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 20,
                    color: Colors.black),
              ),
            ),
            Container(
              height: 400.0,
              child: FoodItems(),
            ),
          ],
        ),
      ]),
    );
  }
}
