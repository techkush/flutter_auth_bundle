import 'package:flutter/material.dart';
import 'package:flutterauthbundle/email_auth/register.dart';
import 'package:flutterauthbundle/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterauthbundle/auth_service/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;

  loginEmailPassword() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      Navigator.of(context).pop();
      AuthService().handleAuth();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login - Email & Password'),
        centerTitle: true,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email Address'),
                onChanged: (val) {
                  setState(() {
                    this.email = val;
                  });
                },
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextFormField(
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (val) {
                  setState(() {
                    this.password = val;
                  });
                },
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: SizedBox(
                height: 50,
                child: RaisedButton(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onPressed: () {
                      loginEmailPassword();
                    }),
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: SizedBox(
                height: 50,
                child: RaisedButton(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Get Registered',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onPressed: () {
                      //Navigator.of(context).pushReplacementNamed('/email_register');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    }),
              )),
        ],
      ),
    );
  }
}
