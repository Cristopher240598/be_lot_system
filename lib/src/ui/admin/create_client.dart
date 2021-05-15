import 'package:be_lot_system/src/ui/admin/index_admin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class CreateClient extends StatefulWidget {
  @override
  _CreateClientState createState() => _CreateClientState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _CreateClientState extends State<CreateClient> {
  TextEditingController correoElectronicoController;
  TextEditingController nombreController;
  TextEditingController apellidoPaternoController;
  TextEditingController apellidoMaternoController;
  LocalAuthentication _localAuthentication;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    correoElectronicoController = new TextEditingController();
    nombreController = new TextEditingController();
    apellidoPaternoController = new TextEditingController();
    apellidoMaternoController = new TextEditingController();
    _localAuthentication = LocalAuthentication();
    _localAuthentication.canCheckBiometrics.then((b) {
      setState(() {
        _isBiometricAvailable = b;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
                            child: Text('Crear cliente',
                                style: TextStyle(fontSize: 18.0)),
                          ))
                        ]))),
            Card(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Theme(
                          data: ThemeData(primaryColor: Colors.purple),
                          child: TextField(
                            autofocus: true,
                            controller: correoElectronicoController,
                            style: TextStyle(fontSize: 17.0),
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico:',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          )),
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
                                  padding: EdgeInsets.only(right: 8),
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
                                  padding: EdgeInsets.only(left: 8),
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
                                  padding:
                                      EdgeInsets.fromLTRB(30.0, 7.0, 30.0, 7.0),
                                  child: Container(
                                      width: 70.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Crear',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.fingerprint,
                                                  color: Colors.white))
                                        ],
                                      )),
                                  onPressed: () async {
                                    if (_isBiometricAvailable) {
                                      bool didAuthenticate =
                                          await _localAuthentication
                                              .authenticateWithBiometrics(
                                                  localizedReason:
                                                      'Identifíquese');
                                      if (didAuthenticate) {
                                        RegisterClient();
                                      } else {
                                        showError(context, 'Identifíquese');
                                      }
                                    } else {
                                      showError(context, 'Identifíquese');
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

  // ignore: non_constant_identifier_names
  void RegisterClient() {
    if (nombreController.text.trim().length == 0 ||
        apellidoPaternoController.text.trim().length == 0 ||
        apellidoMaternoController.text.trim().length == 0 ||
        correoElectronicoController.text.trim().length == 0) {
      showError(context, 'Faltan datos por ingresar');
    } else {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(correoElectronicoController.text);
      if (emailValid) {
        clientRef
            .orderByChild("correoElectronico")
            .equalTo(correoElectronicoController.text)
            .limitToFirst(1)
            .once()
            .then((snapshot) {
          try {
            List<dynamic> curretList = [];
            snapshot.value.forEach((orderId, orderData) {
              curretList.add(orderData);
            });
            showWarning(context, 'El correo electrónico ya existe');
          } catch (e) {
            clientRef.push().set({
              'nombre': nombreController.text,
              'apellidoPaterno': apellidoPaternoController.text,
              'apellidoMaterno': apellidoMaternoController.text,
              'latitud': '',
              'longitud': '',
              'correoElectronico': correoElectronicoController.text,
              'telefono': '',
              'foto': '',
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => IndexAdmin()),
                (Route<dynamic> route) => false);
          }
        });
      } else {
        showError(context, 'Ingrese un correo electrónico válido');
      }
    }
  }
}
