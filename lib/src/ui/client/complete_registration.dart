import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteRegistration extends StatefulWidget {
  final String correoElectronico;

  CompleteRegistration(this.correoElectronico);

  @override
  _CompleteRegistrationState createState() => _CompleteRegistrationState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _CompleteRegistrationState extends State<CompleteRegistration> {
  TextEditingController contraseniaController;
  TextEditingController numeroTelefonoController;

  @override
  void initState() {
    super.initState();
    contraseniaController = new TextEditingController();
    numeroTelefonoController = new TextEditingController();
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
                            child: Theme(
                                data: ThemeData(primaryColor: Colors.purple),
                                child: TextField(
                                  autofocus: true,
                                  controller: null,
                                  style: TextStyle(fontSize: 17.0),
                                  decoration: InputDecoration(
                                    labelText: 'Número de teléfono:',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                )))),
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
                                      controller: null,
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
                                      controller: null,
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
                          child: Text('Domicilio:',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[600]))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Foto de perfil:',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[600]))),
                    ),
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
                                onPressed: () => {})))
                  ])))
        ]))));
  }
}
