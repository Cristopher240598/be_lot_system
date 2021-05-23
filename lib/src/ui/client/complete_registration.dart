import 'dart:async';
import 'dart:io';

import 'package:be_lot_system/src/ui/client/index_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteRegistration extends StatefulWidget {
  final String correoElectronico;
  final String latitud;
  final String longitud;

  CompleteRegistration(this.correoElectronico, this.latitud, this.longitud);

  @override
  _CompleteRegistrationState createState() => _CompleteRegistrationState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _CompleteRegistrationState extends State<CompleteRegistration> {
  TextEditingController contraseniaController;
  TextEditingController confirmarContraseniaController;
  TextEditingController numeroTelefonoController;

  File _image;
  String _uploadedFileURL;

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    if (gallery) {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    contraseniaController = new TextEditingController();
    numeroTelefonoController = new TextEditingController();
    confirmarContraseniaController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Be IoT System'),
          backgroundColor: Colors.purpleAccent,
        ),
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
                          child: Text('Completar registro',
                              style: TextStyle(fontSize: 18.0)),
                        ))
                      ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 130.0,
                                child: Theme(
                                    data:
                                        ThemeData(primaryColor: Colors.purple),
                                    child: TextField(
                                      autofocus: true,
                                      controller: numeroTelefonoController,
                                      style: TextStyle(fontSize: 17.0),
                                      decoration: InputDecoration(
                                        labelText: 'Número de teléfono:',
                                      ),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                    ))))),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Correo electrónico:',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey[600]))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(widget.correoElectronico,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black))),
                        ])),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Column(children: [
                            Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Theme(
                                    data:
                                        ThemeData(primaryColor: Colors.purple),
                                    child: TextField(
                                      autofocus: true,
                                      controller: contraseniaController,
                                      style: TextStyle(fontSize: 17.0),
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña:',
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.next,
                                    )))
                          ])),
                          Expanded(
                              child: Column(children: [
                            Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Theme(
                                    data:
                                        ThemeData(primaryColor: Colors.purple),
                                    child: TextField(
                                      autofocus: true,
                                      controller:
                                          confirmarContraseniaController,
                                      style: TextStyle(fontSize: 17.0),
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Confirmar:',
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.next,
                                    )))
                          ]))
                        ]),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Foto de perfil:',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[600]))),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(children: [
                          Expanded(
                              child: Center(
                                  child: Material(
                                      color: Colors.white,
                                      child: Center(
                                          child: Ink(
                                              decoration: const ShapeDecoration(
                                                  shape: CircleBorder(),
                                                  color: Colors.purpleAccent),
                                              child: IconButton(
                                                icon: const Icon(Icons
                                                    .add_photo_alternate_outlined),
                                                color: Colors.white,
                                                padding: EdgeInsets.all(10.0),
                                                iconSize: 40.0,
                                                onPressed: () {
                                                  getImage(true);
                                                },
                                              )))))),
                          Expanded(
                              child: Center(
                                  child: Material(
                                      color: Colors.white,
                                      child: Center(
                                          child: Ink(
                                              decoration: const ShapeDecoration(
                                                  shape: CircleBorder(),
                                                  color: Colors.purpleAccent),
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.add_a_photo_outlined),
                                                color: Colors.white,
                                                padding: EdgeInsets.all(10.0),
                                                iconSize: 40.0,
                                                onPressed: () {
                                                  getImage(false);
                                                },
                                              ))))))
                        ])),
                    if (_image != null)
                      SizedBox(height: 300, child: Image.file(_image)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.purple[200],
                            child: MaterialButton(
                                padding:
                                    EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                                child: Text(
                                  'Registrar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (numeroTelefonoController.text
                                              .trim()
                                              .length ==
                                          0 ||
                                      contraseniaController.text
                                              .trim()
                                              .length ==
                                          0 ||
                                      confirmarContraseniaController.text
                                              .trim()
                                              .length ==
                                          0) {
                                    showError(context,
                                        'Faltan datos por ingresar', '');
                                  } else {
                                    if (contraseniaController.text ==
                                        confirmarContraseniaController.text) {
                                      try {
                                        UserCredential userCredential =
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                    email: widget
                                                        .correoElectronico,
                                                    password:
                                                        contraseniaController
                                                            .text);
                                        if (userCredential != null) {
                                          if (_image != null) {
                                            FirebaseStorage storage =
                                                FirebaseStorage.instance;
                                            Reference ref = storage
                                                .ref()
                                                .child('usuarios/')
                                                .child(
                                                    DateTime.now().toString());
                                            UploadTask uploadTask =
                                                ref.putFile(_image);
                                            uploadTask.whenComplete(() async {
                                              try {
                                                _uploadedFileURL =
                                                    await ref.getDownloadURL();
                                              } catch (e) {
                                                print(e);
                                              }
                                              registrar(_uploadedFileURL);
                                            });
                                          } else {
                                            registrar('');
                                          }
                                          SharedPreferences prefs;
                                          prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.setString(
                                              "mail", widget.correoElectronico);
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IndexClient(widget
                                                          .correoElectronico)),
                                              (Route<dynamic> route) => false);
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                          print(
                                              'The password provided is too weak.');
                                          showWarning(context,
                                              'La contraseña no es segura');
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          print(
                                              'The account already exists for that email.');
                                          showError(
                                              context,
                                              'Este correo electrónico ya',
                                              'fue registrado');
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    } else {
                                      contraseniaController.clear();
                                      confirmarContraseniaController.clear();
                                      showWarning(context,
                                          'Ingrese otra vez la contraseña');
                                    }
                                  }
                                })))
                  ])))
        ]))));
  }

  void registrar(String foto) {
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
        clientRef.child(clienteID[0]).set({
          'nombre': clienteData[0]['nombre'],
          'apellidoPaterno': clienteData[0]['apellidoPaterno'],
          'apellidoMaterno': clienteData[0]['apellidoMaterno'],
          'latitud': widget.latitud,
          'longitud': widget.longitud,
          'correoElectronico': widget.correoElectronico,
          'telefono': numeroTelefonoController.text,
          'foto': foto,
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void showError(BuildContext ctxt, String message1, String message2) {
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
                          Text(message1),
                          Text(message2),
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
