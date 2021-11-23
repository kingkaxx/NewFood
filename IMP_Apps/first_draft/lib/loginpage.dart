import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:second_app/bottomnav.dart';
import 'package:second_app/localDB_one.dart';

import 'regpage.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class Images extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage img = AssetImage('images/logo.png');
    Image image = Image(
      image: img,
    );
    return Container(
      child: image,
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();
  bool _loading = false;
  final myController = TextEditingController();
  final passController = TextEditingController();
  var userNameData, userPasswordData;
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

  var loginInfo;
  _makePostRequest() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonn =
        '{"username":"${userNameData}","password":"${userPasswordData}"}';
    print(jsonn);
    http.Response response = await http.post('http://127.0.0.1:8080/login',
        headers: headers, body: jsonn);
    setState(() {
      loginInfo;
    });
    loginInfo = json.decode(response.body);
    print(loginInfo);
    if (loginInfo != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => BottomNav()));
      LocalDB.saveToFile(myController.text);
    } else
      return null;
    // if (loginInfo[0]["User"]["password"] == "${userPasswordData}")
    //   return Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => BottomNav()));
    // else
    //   return null;
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

  @override
  void initState() {
    super.initState();
    _checkUser();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent, radius: 80.0, child: (Images())),
    );

    @override
    void dispose() {
      myController.dispose();
      passController.dispose();
      super.dispose();
    }

    final username = TextFormField(
      controller: myController,
      keyboardType: TextInputType.text,
      validator: (val) => val.length < 3 ? 'Invalid username' : null,
      decoration: InputDecoration(
          hintText: 'Enter username',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

    final password = TextFormField(
      controller: passController,
      validator: (val) => val.length < 4 ? 'Invalid Password' : null,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
    void loginFailed() {
      final snackbar = new SnackBar(
        content: new Text("Please enter valid Credentials"),
      );
      scaffoldkey.currentState.showSnackBar(snackbar);
    }

    void loginDone() {
      final snackbar = new SnackBar(
        content: new Text("Logged in"),
      );
      scaffoldkey.currentState.showSnackBar(snackbar);
    }

    void loginWait() {
      final snackbar = new SnackBar(
        content: new Text("Please Wait...."),
      );
      scaffoldkey.currentState.showSnackBar(snackbar);
    }

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Color(0xffD34A3C),
        color: Color(0xffD34A3C),
        elevation: 6.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            if (formkey.currentState.validate()) {
              Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                      child: SpinKitCircle(size: 80, color: Colors.red)));
              userNameData = myController.text;
              userPasswordData = passController.text;
              _makePostRequest();
            }
            loginWait();
            for (var i = 0; i < collName.length; i++)
              if ("${collName[i]['name']}" == "${myController.text}") {
                if (loginInfo != null) {
                  LocalDB.saveToFile(myController.text);
                  break;
                }
              }
            loginFailed();
          },
          color: Color(0xffD34A3C),
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );

    final forgetlabel = FlatButton(
      child: Text('Forget Password?', style: TextStyle(color: Colors.black)),
      onPressed: () {},
    );

    final signuplabel = FlatButton(
      child: Text("Don't have an account yet? Sign up here",
          style: TextStyle(color: Colors.black)),
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => RegPage()));
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
                logo,
                SizedBox(height: 48.0),
                username,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 26.0),
                loginButton,
                forgetlabel,
                signuplabel
              ],
            ),
          ),
        ),
        // (_loading)
        //     ? Center(child: SpinKitCircle(size: 80, color: Colors.red))
        //     : Center()
      ]),
    );
  }
}
