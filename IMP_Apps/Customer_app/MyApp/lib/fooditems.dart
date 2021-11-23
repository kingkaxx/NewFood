import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:MyApp/productdetails.dart';
import 'package:http/http.dart' as http;

class FoodItems extends StatefulWidget {
  @override
  _FoodItemsState createState() => _FoodItemsState();
}

class _FoodItemsState extends State<FoodItems> {
  var foodItemList = [
    {"name": "Sweet", "image": "images/food 1.png", "price": 100},
    {"name": "Sweet", "image": "images/food 2.png", "price": 200},
    {"name": "Sweet", "image": "images/food 3.png", "price": 190},
    {"name": "Sweet", "image": "images/food 5.png", "price": 200},
  ];
  var data;
  _getFamous() async {
    http.Response response = await http.post("http://127.0.0.1:8080/getFamous");
    data = json.decode(response.body);
    setState(() {
      data;
    });
    print("ye fooditem data..");
    print(data);
    print("ye response.body");
    print(response.body);
    print(data.length);
  }

  @override
  void initState() {
    super.initState();
    _getFamous();
  }

  //to prevent box scrolling use only 2 items per list[]
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        if (data == null)
          Text("Loading...")
        else
          Container(
            //height is very imp in this
            height: 300,
            child: GridView.builder(
              itemCount: data.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                if (data == null) {
                  Text("Loading....");
                } else
                  return SingleFoodItem(
                    //change to data[index]
                    fooditemName: data[index]['fooditemName'],
                    fooditemImg: foodItemList[index]['image'],
                    fooditemPrice: data[index]['fooditemPrice'],
                  );
              },
            ),
          ),
      ],
    );
  }
}

class SingleFoodItem extends StatelessWidget {
  final fooditemName;
  final fooditemImg;
  final fooditemPrice;

  SingleFoodItem({this.fooditemName, this.fooditemImg, this.fooditemPrice});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          //onTap: () => Navigator.of(context).pushNamed(ProductDetails.tag),
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              //this is passing values to product page
              builder: (context) => new ProductDetails(
                    product_fooditemName: fooditemName,
                    product_fooditemImg: fooditemImg,
                    product_fooditemPrice: fooditemPrice,
                  ))),

          child: GridTile(
            footer: Container(
              height: MediaQuery.of(context).size.height / 16,
              color: Colors.white,
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(fooditemName,
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ),
                trailing: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("\Rs $fooditemPrice",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ),
              ),
            ),
            child: Image.asset(fooditemImg, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
