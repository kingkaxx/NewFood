import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:MyApp/displayShopByCategory.dart';

import 'package:MyApp/myprofile.dart';
import 'package:MyApp/search.dart';
import 'displayShopbyCity.dart';
import 'horizontalListView.dart';
import 'fooditems.dart';
import 'package:flutter/cupertino.dart';

import 'horizontallistviewcity.dart';
import 'shopbyCategory.dart';

class userAccountPage extends StatefulWidget {
  static String tag = 'useraccountpage';
  @override
  _userAccountPageState createState() => _userAccountPageState();
}

class _userAccountPageState extends State<userAccountPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        height: MediaQuery.of(context).size.height * 0.25,
        child: Carousel(
          boxFit: BoxFit.cover,
          images: [
            AssetImage('images/food 1.png'),
            AssetImage('images/food 2.png'),
            AssetImage('images/food 3.png'),
            AssetImage('images/food 4.png'),
            AssetImage('images/food 5.png'),
            AssetImage('images/food 6.png'),
            AssetImage('images/food 7.png'),
          ],
          autoplay: true,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(seconds: 2),
          indicatorBgPadding: 0.0,
          dotSize: 6.0,
          dotColor: Color(0xffD34A3C),
          dotBgColor: Colors.transparent,
        ));

    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            image_carousel,
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new DisplayShopByCategory())),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Text(
                          'Catergories',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 20,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 50),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new DisplayShopByCategory())),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                )),
            HorizontalList(),
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new DisplayShopByCity())),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Text(
                          'Shop by City',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 20,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 50),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new DisplayShopByCity())),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                )),
            HorizontalListCity(),
            Row(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 50),
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: Text(
                      'Popular Items',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 20,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            //for grid view

            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: FoodItems(),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "SnacLord",
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
      //   currentIndex: index,
      //   onTap: (int index) {
      //     setState(() {
      //       this.index = index;
      //     });
      //   },
      //   backgroundColor: Colors.white,
      //   type: BottomNavigationBarType.fixed,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //           child: Icon(Icons.home, color: Colors.black),
      //           onTap: () => Navigator.of(context).push(new MaterialPageRoute(
      //               builder: (context) => userAccountPage()))),
      //       title: Text('Home', style: TextStyle(color: Colors.black)),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //         child: Icon(Icons.search, color: Colors.black),
      //         onTap: () => Navigator.of(context).push(
      //             new MaterialPageRoute(builder: (context) => new Search())),
      //       ),
      //       title: Text('Search', style: TextStyle(color: Colors.black)),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart, color: Colors.black),
      //       title: Text('Cart', style: TextStyle(color: Colors.black)),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //         child: Icon(Icons.person, color: Colors.black),
      //         onTap: () => Navigator.of(context).push(
      //             new MaterialPageRoute(builder: (context) => new MyProfile())),
      //       ),
      //       title: Text('Profile', style: TextStyle(color: Colors.black)),
      //     ),
      //   ],
      // ),
      // drawer: new Drawer(
      //   child: ListView(
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         accountName: Text(
      //           "Hello, Kaustubh",
      //           style: TextStyle(fontSize: 24),
      //         ),
      //         accountEmail: Text("kaustubh@snaclord.com"),
      //         currentAccountPicture: CircleAvatar(
      //           backgroundColor: Colors.white,
      //           child: Text(
      //             "K",
      //             style: TextStyle(fontSize: 40),
      //           ),
      //         ),
      //       ),
      //       // ListTile(
      //       //     title: Text("Home"),
      //       //     trailing: Icon(Icons.home),
      //       //     onTap: () => Navigator.of(context).pop()),
      //       ListTile(
      //         title: Text("Offers"),
      //         trailing: Icon(Icons.swap_horizontal_circle),
      //       ),
      //       ListTile(
      //         title: Text("Shop by City"),
      //         trailing: Icon(Icons.location_city),
      //       ),
      //       ListTile(
      //         title: Text("Shop by Category"),
      //         trailing: Icon(Icons.category),
      //       ),
      //       ListTile(
      //         title: Text("My orders"),
      //         trailing: Icon(Icons.shopping_basket),
      //       ),
      //       ListTile(
      //         title: Text("Wallet"),
      //         trailing: Icon(Icons.account_balance_wallet),
      //       ),

      //       Divider(),
      //       Divider(),
      //       ListTile(
      //         title: Text("Settings"),
      //         trailing: Icon(Icons.settings),
      //       ),
      //       ListTile(
      //         title: Text("Customer Service"),
      //         trailing: Icon(Icons.call_to_action),
      //       ),
      //       ListTile(
      //         title: Text("FAQs"),
      //         trailing: Icon(Icons.question_answer),
      //       ),
      //       ListTile(
      //         title: Text("About Us"),
      //         trailing: Icon(Icons.people_outline),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
