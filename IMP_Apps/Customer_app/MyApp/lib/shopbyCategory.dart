import 'package:flutter/material.dart';

import 'categoryListBuilder.dart';
import 'package:shimmer/shimmer.dart';

class ShopByCategory extends StatefulWidget {
  @override
  _ShopByCategoryState createState() => _ShopByCategoryState();
}

class _ShopByCategoryState extends State<ShopByCategory> {
  var catList = [
    {"imgLocation": 'images/food 1.png', "imgCaption": 'Sweet'},
    {"imgLocation": 'images/food 2.png', "imgCaption": 'Sweet One'},
    {"imgLocation": 'images/food 3.png', "imgCaption": 'Another Sweet'},
    {"imgLocation": 'images/food 4.png', "imgCaption": 'Too many sweets'},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: catList.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        // if(something ==null)
        // gridShimmerBuilder();
        // else
        return SingleCatItem(
          catImgLocation: catList[index]['imgLocation'],
          catImgCaption: catList[index]['imgCaption'],
        );
      },
    );
  }
}

class SingleCatItem extends StatelessWidget {
  final catImgLocation;
  final catImgCaption;

  SingleCatItem({this.catImgLocation, this.catImgCaption});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Material(
      child: InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            //this is passing values to product page
            builder: (context) => new CatListBuild(
                  catName: catImgCaption,
                ))),
        child: GridTile(
          footer: Container(
            color: Colors.white,
            child: ListTile(
              leading: Text(catImgCaption,
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
          ),
          child: Image.asset(catImgLocation, fit: BoxFit.cover),
        ),
      ),
    ));
  }
}

Widget gridShimmerBuilder() {
  return Card(
      child: Material(
    child: Shimmer.fromColors(
      child: GridTile(
        footer: Container(
          color: Colors.white,
          child: ListTile(
            leading: Container(height: 20, width: 60),
          ),
        ),
        child: Container(height: 60, width: 60),
      ),
      baseColor: Colors.grey[200],
      highlightColor: Colors.white,
    ),
  ));
}
