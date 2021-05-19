import 'package:be_lot_system/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexClient extends StatefulWidget {
  const IndexClient({Key key}) : super(key: key);

  @override
  _IndexClientState createState() => _IndexClientState();
}

class _IndexClientState extends State<IndexClient> {
  Future<Null> _logoutUser() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // ignore: deprecated_member_use
    prefs.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Be IoT System'),
            backgroundColor: Colors.purpleAccent,
            actions: <Widget>[
              IconButton(
                  icon: new Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    _logoutUser();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
                  })
            ]),
        body: Center(child: Text('Cliente')));
  }
}
