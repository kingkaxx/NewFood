import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:second_app/cityListBuilder.dart';
import 'package:shimmer/shimmer.dart';

class ShopbyCity extends StatefulWidget {
  @override
  _ShopbyCityState createState() => _ShopbyCityState();
}

class _ShopbyCityState extends State<ShopbyCity> {
  var cityList = [
    {"imgLocation": 'images/food 1.png', "imgCaption": 'Pune'},
    {"imgLocation": 'images/food 2.png', "imgCaption": 'Nashik'},
    {"imgLocation": 'images/food 3.png', "imgCaption": 'Mumbai'},
    {"imgLocation": 'images/food 4.png', "imgCaption": 'Nagpur'},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: cityList.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        // if (something==null)
        // gridShimmerBuilder();
        // else
        return SingleCatItem(
          catImgLocation: cityList[index]['imgLocation'],
          catImgCaption: cityList[index]['imgCaption'],
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
        //onTap: () => Navigator.of(context).pushNamed(ProductDetails.tag),
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            //this is passing values to product page
            builder: (context) => CityListBuilder(
                  cityName: catImgCaption,
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
