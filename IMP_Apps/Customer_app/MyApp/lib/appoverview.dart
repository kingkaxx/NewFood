import 'package:flutter/material.dart';
import 'package:MyApp/userAccountPage.dart';

import 'bottomnav.dart';

class AppOverView extends StatefulWidget {
  static String tag = 'appover-view';

  @override
  _AppOverViewState createState() => _AppOverViewState();
}

class _AppOverViewState extends State<AppOverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildPageView(),
    );
  }

  Widget _buildPage({String img, Color color}) {
    return Container(
        alignment: AlignmentDirectional.center,
        color: color,
        width: 100.0,
        height: 100.0,
        child: Material(
          child: Container(
            child: Image.asset('$img'),
            //We can edit the image in photoshop add txt in it and then use #MoreEfficient
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.88,
          ),
          elevation: 20.0,
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.white60,
        ));
  }

  Widget _buildPageView() {
    return PageView(
      children: [
        _buildPage(img: "images/city.png", color: Colors.white),
        _buildPage(img: "images/food.png", color: Colors.white),
        _lastPageView(img: "images/del.png", color: Colors.white),
      ],
    );
  }

  Widget _lastPageView({String img, Color color}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
              0, MediaQuery.of(context).size.height * 0.21, 0, 0),
          child: Container(
              alignment: AlignmentDirectional.center,
              color: color,
              child: Material(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset('$img'),
                      //We can edit the image in photoshop add txt in it and then use #MoreEfficient
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.88,
                    ),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.yellow,
                        color: Color(0xffD34A3C),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                //this is passing values to product page
                                builder: (context) => new BottomNav()));
                          },
                          child: Text("Get Started",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ))
                  ],
                ),
                elevation: 20.0,
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.white60,
              )),
        ),
      ],
    );
  }
}
