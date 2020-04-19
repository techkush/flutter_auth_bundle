import 'package:flutter/material.dart';
import 'package:flutterauthbundle/auth_service/auth_service.dart';
import 'package:flutterauthbundle/email_auth/login_page.dart';
import 'dart:async';

import 'package:flutterauthbundle/email_auth/register.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthService().handleAuth(),
        routes: <String, WidgetBuilder>{
          '/email_register': (BuildContext context) => new Register(),
          '/email_login': (BuildContext context) => new LoginPage(),
        },
    );
  }
}