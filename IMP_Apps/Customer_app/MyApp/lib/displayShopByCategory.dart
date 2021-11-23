import 'package:flutter/material.dart';
import 'package:MyApp/shopbyCategory.dart';
import 'package:MyApp/userAccountPage.dart';

import 'myprofile.dart';

class DisplayShopByCategory extends StatefulWidget {
  @override
  _DisplayShopByCategoryState createState() => _DisplayShopByCategoryState();
}

class _DisplayShopByCategoryState extends State<DisplayShopByCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.notifications,
              color: Color(0xffD34A3C),
            ),
            onPressed: null,
          ),
        ],
        backgroundColor: Color(0xffD34A3C),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: InkWell(
                child: Icon(Icons.home, color: Colors.black),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new userAccountPage()))),
            title: Text('Home', style: TextStyle(color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              child: Icon(Icons.search, color: Colors.black),
              // onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              //     //this will redirect serach page
              //     builder: (context) => new MyProfile())),
            ),
            title: Text('Search', style: TextStyle(color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            title: Text('Cart', style: TextStyle(color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              child: Icon(Icons.person, color: Colors.black),
              onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => new MyProfile())),
            ),
            title: Text('Profile', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 500,
              child: ShopByCategory(),
            )
          ],
        ),
      ),
    );
  }
}
