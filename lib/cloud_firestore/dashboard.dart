import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterauthbundle/home_page.dart';

import 'crud_config.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String carModel;
  String carColor;

  QuerySnapshot cars;

  crudMethods crudObj = new crudMethods();

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add Data',
              style: TextStyle(fontSize: 15),
            ),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car Name'),
                  onChanged: (value) {
                    this.carModel = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car color'),
                  onChanged: (value) {
                    this.carColor = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  Map<String, dynamic> carData = {
                    'carName': this.carModel,
                    'color': this.carColor
                  };
                  crudObj.addData(carData).then((result) {
                    dialogTrigger(context);
                    initState();
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Job Done',
              style: TextStyle(fontSize: 15),
            ),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  // ignore: must_call_super
  void initState() {
    crudObj.getData().then((result) {
      setState(() {
        cars = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addDialog(context);
            },
          )
        ],
      ),
      body: _carList(),
    );
  }

  Widget _carList() {
    if (cars != null) {
      return ListView.builder(
          itemCount: cars.documents.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, i) {
            return new ListTile(
              title: Text(cars.documents[i].data['carName']),
              subtitle: Text(cars.documents[i].data['color']),
            );
          });
    } else {
      return Text('Loading, Please wait..');
    }
  }
}
