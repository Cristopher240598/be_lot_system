import 'package:be_lot_system/main.dart';
import 'package:be_lot_system/src/ui/client/ConstantsMenu.dart';
import 'package:be_lot_system/src/ui/client/change_location.dart';
import 'package:be_lot_system/src/ui/client/credits.dart';
import 'package:be_lot_system/src/ui/client/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexClient extends StatefulWidget {
  final String correoElectronico;

  IndexClient(this.correoElectronico);

  @override
  _IndexClientState createState() => _IndexClientState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _IndexClientState extends State<IndexClient> {
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String latitud;
  String longitud;
  String telefono;
  String foto;
  String id;

  Future<Null> _logoutUser() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // ignore: deprecated_member_use
    prefs.commit();
  }

  @override
  void initState() {
    List<dynamic> clienteID = [];
    List<dynamic> clienteData = [];
    clientRef
        .orderByChild('correoElectronico')
        .equalTo(widget.correoElectronico)
        .limitToFirst(1)
        .once()
        .then((snapshot) {
      try {
        snapshot.value.forEach((orderID, orderData) {
          clienteID.add(orderID);
          clienteData.add(orderData);
        });
        setState(() {
          nombre = clienteData[0]['nombre'];
          apellidoPaterno = clienteData[0]['apellidoPaterno'];
          apellidoMaterno = clienteData[0]['apellidoMaterno'];
          latitud = clienteData[0]['latitud'];
          longitud = clienteData[0]['longitud'];
          telefono = clienteData[0]['telefono'];
          foto = clienteData[0]['foto'];
          id = clienteID[0];
        });
      } catch (e) {
        print(e);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: nombre != null ? Text(nombre) : Text('Be IoT System'),
            backgroundColor: Colors.purpleAccent,
            actions: <Widget>[
              PopupMenuButton<String>(
                  icon: foto != null
                      ? foto.length != 0
                          ? CircleAvatar(
                              radius: 16.5,
                              backgroundImage: NetworkImage(foto),
                              backgroundColor: Colors.white,
                            )
                          : CircleAvatar(
                              radius: 16.5,
                              backgroundImage: AssetImage('assets/client.png'),
                              backgroundColor: Colors.white,
                            )
                      : CircleAvatar(
                          radius: 16.5,
                          backgroundImage: AssetImage('assets/client.png'),
                          backgroundColor: Colors.white,
                        ),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return ConstantsMenu.choices.map((String choice) {
                      return PopupMenuItem<String>(
                          value: choice, child: Text(choice));
                    }).toList();
                  })
            ]),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Center(
                          child: Text('Estadísticas',
                              style: TextStyle(fontSize: 18.0)),
                        ))
                      ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Energía gastada en el mes:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Gasto inmediato de electricidad:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Agua gastada en el mes:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Gasto inmediato de agua:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Gasto en el mes redujo en:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Fugas de gas encontradas:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Gráfica de gasto en general:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Gastos:',
                              style: TextStyle(fontSize: 15.0))),
                    ),
                  ]))),
        ]))));
  }

  void choiceAction(String choice) async {
    if (choice == ConstantsMenu.editarPerfil) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditProfile(
                  id,
                  nombre,
                  apellidoPaterno,
                  apellidoMaterno,
                  widget.correoElectronico,
                  foto,
                  latitud,
                  longitud,
                  telefono)));
    }
    if (choice == ConstantsMenu.cambiarDomicilio) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeLocation(
                  id,
                  nombre,
                  apellidoPaterno,
                  apellidoMaterno,
                  widget.correoElectronico,
                  foto,
                  latitud,
                  longitud,
                  telefono)));
    }
    if (choice == ConstantsMenu.cerrarSesion) {
      print('Cerrar');
      await FirebaseAuth.instance.signOut();
      _logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    }
    if (choice == ConstantsMenu.creditos) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Credits()));
    }
  }
}
