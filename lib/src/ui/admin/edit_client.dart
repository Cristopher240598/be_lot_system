import 'package:be_lot_system/src/model/client.dart';
import 'package:be_lot_system/src/ui/admin/index_admin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditClient extends StatefulWidget {
  final Client client;

  EditClient(this.client);

  @override
  _EditClientState createState() => _EditClientState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _EditClientState extends State<EditClient> {
  TextEditingController nombreController;
  TextEditingController apellidoPaternoController;
  TextEditingController apellidoMaternoController;

  @override
  void initState() {
    super.initState();
    nombreController = new TextEditingController(text: widget.client.nombre);
    apellidoPaternoController =
        new TextEditingController(text: widget.client.apellidoPaterno);
    apellidoMaternoController =
        new TextEditingController(text: widget.client.apellidoMaterno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Editar cliente'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(children: [
            Card(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Theme(
                          data: ThemeData(primaryColor: Colors.purple),
                          child: TextField(
                            controller: nombreController,
                            style: TextStyle(fontSize: 17.0),
                            decoration: InputDecoration(
                              labelText: 'Nombre(s):',
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Theme(
                                      data: ThemeData(
                                          primaryColor: Colors.purple),
                                      child: TextField(
                                        controller: apellidoPaternoController,
                                        style: TextStyle(fontSize: 17.0),
                                        decoration: InputDecoration(
                                          labelText: 'Apellido paterno:',
                                        ),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                      ))),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Theme(
                                      data: ThemeData(
                                          primaryColor: Colors.purple),
                                      child: TextField(
                                        controller: apellidoMaternoController,
                                        style: TextStyle(fontSize: 17.0),
                                        decoration: InputDecoration(
                                          labelText: 'Apellido Materno:',
                                        ),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                      ))),
                            ],
                          ))
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
                          child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.purple[200],
                              child: MaterialButton(
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 15.0, 30.0, 15.0),
                                  child: Text(
                                    'Guardar cambios',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    if (nombreController.text.trim().length ==
                                            0 ||
                                        apellidoPaternoController.text
                                                .trim()
                                                .length ==
                                            0 ||
                                        apellidoMaternoController.text
                                                .trim()
                                                .length ==
                                            0) {
                                      showError(
                                          context, 'Faltan datos por ingresar');
                                    } else {
                                      clientRef.child(widget.client.id).set({
                                        'nombre': nombreController.text,
                                        'apellidoPaterno':
                                            apellidoPaternoController.text,
                                        'apellidoMaterno':
                                            apellidoMaternoController.text,
                                        'latitud': widget.client.latitud,
                                        'longitud': widget.client.longitud,
                                        'correoElectronico':
                                            widget.client.correoElectronico,
                                        'telefono': widget.client.telefono,
                                        'foto': widget.client.foto,
                                      });
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndexAdmin()),
                                          (Route<dynamic> route) => false);
                                    }
                                  })))
                    ])))
          ])),
        ));
  }

  void showError(BuildContext ctxt, String message) {
    showDialog(
        context: ctxt,
        builder: (ctxt) {
          return SimpleDialog(
              title: Center(
                  child: new Image.asset(
                'assets/error.png',
                width: 50,
              )),
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(message),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(ctxt);
                                  },
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 13, 0),
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 18),
                                      )),
                                )
                              ])
                        ]))
              ]);
        });
  }

  void showWarning(BuildContext ctxt, String message) {
    showDialog(
        context: ctxt,
        builder: (ctxt) {
          return SimpleDialog(
              title: Center(
                  child: new Image.asset(
                'assets/warning.png',
                width: 50,
              )),
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(message),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(ctxt);
                                  },
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 13, 0),
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 18),
                                      )),
                                )
                              ])
                        ]))
              ]);
        });
  }
}
