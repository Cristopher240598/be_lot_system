import 'dart:io';

import 'package:be_lot_system/src/ui/client/index_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correoElectronico;
  final String foto;
  final String latitud;
  final String longitud;
  final String telefono;

  EditProfile(
      this.id,
      this.nombre,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.correoElectronico,
      this.foto,
      this.latitud,
      this.longitud,
      this.telefono);

  @override
  _EditProfileState createState() => _EditProfileState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _EditProfileState extends State<EditProfile> {
  TextEditingController numeroTelefonoController;
  File _image;
  String _uploadedFileURL;
  String url;

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

  void deleteOldImage() {
    String filePath = url.replaceAll(
        new RegExp(
            'https://firebasestorage.googleapis.com/v0/b/be-iot-system.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp('%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    filePath = filePath.replaceAll(new RegExp('%20'), ' ');
    filePath = filePath.replaceAll(new RegExp('%3A'), ':');
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(filePath);
    ref.delete().then((_) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => IndexClient(widget.correoElectronico)),
        (Route<dynamic> route) => false));
  }

  @override
  void initState() {
    super.initState();
    numeroTelefonoController = new TextEditingController(text: widget.telefono);
    _uploadedFileURL = widget.foto;
    url = widget.foto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.nombre),
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
                          child: Text('Editar perfil',
                              style: TextStyle(fontSize: 18.0)),
                        ))
                      ]))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10),
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
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Nombre(s):',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey[600]))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(widget.nombre,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black)))
                        ])),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Text('Apellido paterno:',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[600]))),
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(widget.apellidoPaterno,
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.black)))
                                    ],
                                  )),
                            ])),
                            Expanded(
                                child: Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Text('Apellido materno:',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[600]))),
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(widget.apellidoMaterno,
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.black)))
                                    ],
                                  )),
                            ]))
                          ]),
                    ),
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
                      padding: EdgeInsets.only(top: 15),
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
                      SizedBox(
                        height: 300,
                        child: Image.file(_image),
                      ),
                    if (_image == null)
                      if (widget.foto.length != 0)
                        SizedBox(
                            height: 300, child: Image.network(widget.foto)),
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
                                  'Guardar cambios',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (_image != null) {
                                    FirebaseStorage storage =
                                        FirebaseStorage.instance;
                                    Reference ref = storage
                                        .ref()
                                        .child('usuarios/')
                                        .child(DateTime.now().toString());
                                    UploadTask uploadTask = ref.putFile(_image);
                                    uploadTask.whenComplete(() async {
                                      try {
                                        _uploadedFileURL =
                                            await ref.getDownloadURL();
                                      } catch (e) {
                                        print(e);
                                      }
                                      actualizar(_uploadedFileURL);
                                      if (url.length == 0)
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    IndexClient(widget
                                                        .correoElectronico)),
                                            (Route<dynamic> route) => false);
                                      else
                                        deleteOldImage();
                                    });
                                  } else {
                                    actualizar(_uploadedFileURL);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => IndexClient(
                                                widget.correoElectronico)),
                                        (Route<dynamic> route) => false);
                                  }
                                })))
                  ])))
        ]))));
  }

  void actualizar(String foto) {
    clientRef.child(widget.id).set({
      'nombre': widget.nombre,
      'apellidoPaterno': widget.apellidoPaterno,
      'apellidoMaterno': widget.apellidoMaterno,
      'latitud': widget.latitud,
      'longitud': widget.longitud,
      'correoElectronico': widget.correoElectronico,
      'telefono': numeroTelefonoController.text,
      'foto': foto,
    });
    Fluttertoast.showToast(
        msg: "Cambios guardados",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }
}
