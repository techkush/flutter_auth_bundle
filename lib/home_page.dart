import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterauthbundle/auth_service/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid, email, photoURL, displayName;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
        this.email = val.email;
        this.photoURL = val.photoUrl;
        this.displayName = val.displayName;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: Container(
              padding: EdgeInsets.all(10),
              child: Text("Your Name?"),
              decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            content: TextFormField(
                controller: customController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'SMS Code'),
                onChanged: (val) {}),
            actions: <Widget>[
              //CircularProgressIndicator(),
              MaterialButton(
                elevation: 5,
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                elevation: 5,
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (photoURL != null)
              ? CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(photoURL),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          (displayName != null)
              ? Text(
                  '$displayName',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Text('User Id $uid'),
          (email != null) ? Text('Email $email') : Container(),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: SizedBox(
                height: 50,
                child: RaisedButton(
                    color: Colors.blue,
                    child: Center(
                        child: Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        AuthService().handleAuth();
                      }).catchError((e) {
                        print(e);
                      });
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
                    child: Center(
                        child: Text(
                      'Alert Dialog',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                    onPressed: () {
                      createAlertDialog(context);
                    }),
              )),
        ],
      ),
    );
  }
}
