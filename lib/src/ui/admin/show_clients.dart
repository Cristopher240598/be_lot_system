import 'dart:async';

import 'package:be_lot_system/src/model/client.dart';
import 'package:be_lot_system/src/ui/admin/edit_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
                                            backgroundImage:
                                                AssetImage('assets/logo.png'),
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
                      ],
                    );
                  }))
        ])));
  }

  void _deleteClient(BuildContext context, Client client, int position) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => IndexAdmin()),
        (Route<dynamic> route) => false);
    await clientRef.child(client.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _viewClient(BuildContext ctxt, Client client) {
    showDialog(
        context: ctxt,
        builder: (ctxt) {
          return SimpleDialog(
              title: Center(
                child: Text(client.nombre +
                    ' ' +
                    client.apellidoPaterno +
                    ' ' +
                    client.apellidoMaterno),
              ),
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Correo electrónico: ' + client.correoElectronico,
                            style: TextStyle(fontSize: 15.0, height: 1.5)),
                        Text('Teléfono: ' + client.telefono,
                            style: TextStyle(fontSize: 15.0, height: 1.5)),
                        if (client.foto.length == 0)
                          Center(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/client.png'),
                                    radius: 50.0,
                                    backgroundColor: Colors.transparent,
                                  )))
                        else
                          Center(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/logo.png'),
                                    radius: 50.0,
                                    backgroundColor: Colors.transparent,
                                  ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(ctxt);
                              },
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 13, 0),
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
                    ))
              ]);
        });
  }

  void _editClient(BuildContext context, Client client) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditClient(client)));
  }
}
