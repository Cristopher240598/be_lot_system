import 'package:be_lot_system/main.dart';
import 'package:be_lot_system/src/ui/admin/create_client.dart';
import 'package:be_lot_system/src/ui/admin/show_clients.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexAdmin extends StatefulWidget {
  @override
  _IndexAdminState createState() => _IndexAdminState();
}

class _IndexAdminState extends State<IndexAdmin> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[ShowClients(), CreateClient()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          title: Text('Administrador'),
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Crear',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}
