import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_app/bottomnav.dart';

import 'loginpage.dart';
import 'package:second_app/localDB_one.dart';
import 'dart:async';

class RegPage extends StatefulWidget {
  static String tag = 'reg-page';
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  var localDBUsername = "no data";
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final mobileController = TextEditingController();
  var fullNameData,
      userNameData,
      userPasswordData,
      userEmailData,
      userMobileData;
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();

  _makePostRequest() async {
    String url = 'http://127.0.0.1:8080/reg';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"fullname":"${fullNameData}","username":"${userNameData}","email":"${userEmailData}","password":"${userPasswordData}","MobileNo":"${userMobileData}"}';
    print(json);
    http.Response response = await http.post(url, headers: headers, body: json);
    print(response.body);
  }

  var collName;
  _checkUser() async {
    String url = 'http://127.0.0.1:8080/checkUser';

    http.Response response = await http.post(url);
    collName = json.decode(response.body);
    setState(() {
      collName;
    });
    print(collName);
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

//<----------------------->

//<----------------------->
  // _log() {
  //   LocalDB.deleteFromFile();
  // }

  var log;
  _check() async {
    LocalDB.readFromFile().then((contex) {
      setState(() {
        log = contex;
      });
      print(log);
      if (log == "" || log == null)
        return null;
      else
        return Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => BottomNav()));
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      usernameController.dispose();
      fullnameController.dispose();
      emailController.dispose();
      passController.dispose();
      mobileController.dispose();
      super.dispose();
    }

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent, radius: 80.0, child: (Images())),
    );
    final fullName = TextFormField(
      validator: (val) => val.length < 3 ? 'Enter Valid Name' : null,
      controller: fullnameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Full name ',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
    final name = TextFormField(
      validator: (val) => val.length < 3 ? 'Enter Valid Name' : null,
      controller: usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'username ',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

    final email = TextFormField(
      validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: 'Enter email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
    final mobile = TextFormField(
      validator: (val) => val.length != 10 ? 'Invalid Mobile no.' : null,
      controller: mobileController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Enter mobile no.',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

    final password = TextFormField(
      validator: (val) => val.length < 6 ? 'Password is too short' : null,
      controller: passController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    void performReg() {
      final snackbar = new SnackBar(
        content: new Text("Succesfully signed up!"),
      );
      scaffoldkey.currentState.showSnackBar(snackbar);
    }

    void regFailed() {
      final snackbar = new SnackBar(
        content: new Text("This username is taken. Try another one"),
      );
      scaffoldkey.currentState.showSnackBar(snackbar);
    }

    final regButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Material(
        color: Color(0xffD34A3C),
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Color(0xffD34A3C),
        elevation: 6.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            if (formkey.currentState.validate()) {
              for (var i = 0; i < collName.length; i++)
                if ("${collName[i]["name"]}" == "${usernameController.text}") {
                  regFailed();
                  break;
                } else {
                  performReg();
                  LocalDB.saveToFile(usernameController.text);
                  fullNameData = fullnameController.text;
                  userNameData = usernameController.text;
                  userEmailData = emailController.text;
                  userPasswordData = passController.text;
                  userMobileData = mobileController.text;
                  _makePostRequest();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => BottomNav()));
                  break;
                }
            }
          },
          color: Color(0xffD34A3C),
          child: Text(
            'Sign up',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );

    final googleButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Color(0xffD34A3C),
        elevation: 6.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            LocalDB.readFromFile().then((context) {
              setState(() {
                localDBUsername = context;
              });
            });
            //_log();
            // _check();
          },
          color: Colors.white,
          splashColor: Color(0xffD34A3C),
          child: Text('Sign up with Google',
              style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ),
    );

    final forgetlabel = FlatButton(
      child: Text('Already a Member? Log in Here',
          style: TextStyle(color: Colors.black, fontSize: 16)),
      onPressed: () {
        Navigator.of(context).pushNamed(LoginPage.tag);
      },
    );

    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Form(
          key: formkey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                // Text("${collName.length}"),
                // Text("${collName[0]["name"]}"),
                logo,
                SizedBox(height: 48.0),
                fullName,
                SizedBox(height: 10.0),
                name,
                SizedBox(height: 10.0),
                email,
                SizedBox(height: 8.0),
                mobile,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 26.0),
                regButton,
                Text(localDBUsername),
                googleButton,
                forgetlabel
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
