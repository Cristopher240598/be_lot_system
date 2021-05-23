import 'dart:async';
import 'dart:developer';

import 'package:be_lot_system/src/model/client.dart';
import 'package:be_lot_system/src/ui/admin/edit_client.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'index_admin.dart';

class ShowClients extends StatefulWidget {
  @override
  _ShowClientsState createState() => _ShowClientsState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _ShowClientsState extends State<ShowClients> {
  List<Client> items;
  StreamSubscription<Event> addClients;
  StreamSubscription<Event> changeClients;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    items = new List();
    addClients = clientRef
        .orderByChild('apellidoPaterno')
        .onChildAdded
        .listen(_addClients);
    changeClients = clientRef
        .orderByChild('apellidoPaterno')
        .onChildAdded
        .listen(_changeClients);
  }

  @override
  void dispose() {
    super.dispose();
    addClients.cancel();
    changeClients.cancel();
  }

  void _addClients(Event event) {
    setState(() {
      items.add(new Client.fromSnapShot(event.snapshot));
    });
  }

  void _changeClients(Event event) {
    try {
      var oldClients = items.singleWhere(
          (client) => client.id == event.snapshot.key,
          orElse: () => null);
      setState(() {
        items[items.indexOf(oldClients)] =
            new Client.fromSnapShot(event.snapshot);
      });
    } catch (e) {
      items.removeAt(items.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(children: [
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Center(
                          child: Text('Clientes',
                              style: TextStyle(fontSize: 18.0)),
                        ))
                      ]))),
          Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  padding: EdgeInsets.only(top: 12.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: [
                        Divider(height: 7.0),
                        if (items[position].foto.length == 0)
                          Row(
                            children: [
                              Expanded(
                                  child: ListTile(
                                      title: Text('${items[position].nombre}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        '${items[position].apellidoPaterno} ${items[position].apellidoMaterno}',
                                      ),
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                AssetImage('assets/client.png'),
                                            radius: 28.0,
                                            backgroundColor: Colors.transparent,
                                          )
                                        ],
                                      ),
                                      onTap: () => _editClient(
                                          context, items[position]))),
                              IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () => _deleteClient(
                                      context, items[position], position)),
                              IconButton(
                                  icon: Icon(Icons.preview,
                                      color: Colors.lightBlue),
                                  onPressed: () =>
                                      _viewClient(context, items[position]))
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                  child: ListTile(
                                      title: Text('${items[position].nombre}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        '${items[position].apellidoPaterno} ${items[position].apellidoMaterno}',
                                      ),
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: Colors.purple,
                                              radius: 28.0,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    '${items[position].foto}'),
                                                radius: 27.5,
                                                backgroundColor:
                                                    Colors.transparent,
                                              ))
                                        ],
                                      ),
                                      onTap: () => _editClient(
                                          context, items[position]))),
                              IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () => _deleteClient(
                                      context, items[position], position)),
                              IconButton(
                                  icon: Icon(Icons.preview,
                                      color: Colors.lightBlue),
                                  onPressed: () =>
                                      _viewClient(context, items[position]))
                            ],
                          )
                      ],
                    );
                  }))
        ])));
  }

  void _deleteClient(BuildContext context, Client client, int position) async {
    /*if (client.foto.length != 0) {
      String url = client.foto;
      String filePath = url.replaceAll(
          new RegExp(
              'https://firebasestorage.googleapis.com/v0/b/pa-e1-evaluacion-1.appspot.com/o/'),
          '');
      filePath = filePath.replaceAll(new RegExp('%2F'), '/');
      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
      filePath = filePath.replaceAll(new RegExp('%20'), ' ');
      filePath = filePath.replaceAll(new RegExp('%3A'), ':');
      print('-------------------------------');
      print(filePath);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(filePath);
      UploadTask uploadTask =
          ref.delete().then((_) => print('Imagen eliminada'));
    }


    var app = FirebaseAdmin.instance.initializeApp(AppOptions(
      credential: FirebaseAdmin.instance.certFromPath('service-account.json'),
    ));

    var link = await app.auth().getUserByEmail(client.correoElectronico);

    print(link);


    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => IndexAdmin()),
        (Route<dynamic> route) => false);
    await clientRef.child(client.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });*/
  }

  void _viewClient(BuildContext ctxt, Client client) {
    double doubleLat = double.tryParse(client.latitud) ?? 19.293590;
    double doubleLong = double.tryParse(client.longitud) ?? -99.654380;
    showDialog(
        context: ctxt,
        builder: (ctxt) {
          return SimpleDialog(
              title: Center(
                child: Column(children: [
                  Text(client.nombre),
                  Text(client.apellidoPaterno + ' ' + client.apellidoMaterno)
                ]),
              ),
              children: [
                SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (client.foto.length != 0)
                              Center(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                                      child: CircleAvatar(
                                          radius: 51.0,
                                          backgroundColor: Colors.purple,
                                          child: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(client.foto),
                                            radius: 50.5,
                                            backgroundColor: Colors.transparent,
                                          )))),
                            Text(
                                'Correo electrónico: ' +
                                    client.correoElectronico,
                                style: TextStyle(fontSize: 15.0, height: 1.5)),
                            if (client.telefono.length != 0)
                              Text('Teléfono: ' + client.telefono,
                                  style:
                                      TextStyle(fontSize: 15.0, height: 1.5)),
                            if (client.latitud.length != 0 &&
                                client.longitud.length != 0)
                              Text('Domicilio: ',
                                  style:
                                      TextStyle(fontSize: 15.0, height: 1.5)),
                            if (client.latitud.length != 0 &&
                                client.longitud.length != 0)
                              Container(
                                  width: 300.0,
                                  height: 300.0,
                                  child: Center(
                                      child: GoogleMap(
                                    markers: {
                                      Marker(
                                          markerId: MarkerId('locClient'),
                                          position:
                                              LatLng(doubleLat, doubleLong))
                                    },
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(doubleLat, doubleLong),
                                        zoom: 15),
                                  ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(ctxt);
                                  },
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 13, 0),
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 18),
                                      )),
                                )
                              ],
                            )
                          ],
                        )))
              ]);
        });
  }

  void _editClient(BuildContext context, Client client) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditClient(client)));
  }
}
