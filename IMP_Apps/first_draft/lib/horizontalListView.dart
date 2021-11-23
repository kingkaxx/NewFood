import 'package:flutter/material.dart';

import 'categoryListBuilder.dart';

import 'package:shimmer/shimmer.dart';

class HorizontalList extends StatefulWidget {
  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  @override
  Widget build(BuildContext context) {
    // if (something==null)
    // horizontalListShimmer();
    // else
    return Container(
      height: 115.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(imgLocation: 'images/food 1.png', imgCaption: 'Sweet'),
          Category(imgLocation: 'images/food 2.png', imgCaption: 'Sweet One'),
          Category(
              imgLocation: 'images/food 3.png', imgCaption: 'Another Sweet'),
          Category(
              imgLocation: 'images/food 4.png', imgCaption: 'Too many sweets')
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String imgLocation;
  final String imgCaption;

  Category({this.imgLocation, this.imgCaption});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CatListBuild(
                      catName: imgCaption,
                    )));
          },
          child: Container(
            width: 170.0,
            child: ListTile(
              title: Image.asset(
                imgLocation,
                width: 160.0,
                height: 80.0,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  imgCaption,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ));
  }
}

Widget horizontalListShimmer() {
  return Container(
    child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
      Container(
        width: 170.0,
        child: ListTile(
          title: Shimmer.fromColors(
            child: Container(
              width: 160.0,
              height: 80.0,
            ),
            baseColor: Colors.grey[200],
            highlightColor: Colors.white,
          ),
          subtitle: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Shimmer.fromColors(
                  child: Container(height: 20, width: 60),
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.white)),
        ),
      ),
    ]),
  );
}
