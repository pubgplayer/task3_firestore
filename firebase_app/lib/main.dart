import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String x;
String msg = 'OUTPUT WILL BE PRINTED HERE';
void main() {
  runApp(MyApp());
}

final databaseReference = FirebaseFirestore.instance;

void createdata(message) async {
  await databaseReference.collection("date").doc('result').set({
    'output': message,
  });
}

void data(cmd) async {
  var command;
  try {
    var url = "http://192.168.1.6/cgi-bin/docker.py?x=${cmd}";
    var res = await http.get(url);
    command = res.body;
  } catch (_) {
    print('Error in data finction');
  }
  createdata(command);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('FIREBASE APP'),
        ),
        body: MyBody(),
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  @override
  MyBodyState createState() => MyBodyState();
}

class MyBodyState extends State<MyBody> {
  // ignore: non_constant_identifier_names
  void Retrive() {
    setState(() {
      msg = "loading...";
    });
    databaseReference.collection("date").snapshots().listen((result) {
      result.docs.forEach((result) {
        print(result.data);

        Future.delayed(const Duration(milliseconds: 5000), () {
          setState(() {
            msg = result.data.toString();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset('assets/images/1rh.jpg'),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset('assets/images/1fb.jpg'),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          onChanged: (value) => {x = value},
          autocorrect: false,
          cursorColor: Colors.black,
          enabled: true,
          decoration: InputDecoration(
            hintText: 'ENTER THE COMMAND HERE',
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          child: FlatButton(
            onPressed: () {
              data(x);

              Retrive();
            },
            child: Text('Submit'),
            color: Colors.green,
          ),
        ),
        Expanded(
            child: Card(
          color: Colors.black,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.blue,
            child: Column(
              children: <Widget>[
                new Expanded(
                    child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    msg,
                    style: new TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ))
              ],
            ),
          ),
        )),
      ],
    );
  }
}
