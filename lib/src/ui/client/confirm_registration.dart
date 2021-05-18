import 'package:be_lot_system/src/ui/client/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ConfirmRegistration extends StatefulWidget {
  const ConfirmRegistration({Key key}) : super(key: key);

  @override
  _ConfirmRegistrationState createState() => _ConfirmRegistrationState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _ConfirmRegistrationState extends State<ConfirmRegistration> {
  TextEditingController correoElectronicoController;
  TextEditingController nombreController;
  TextEditingController apellidoPaternoController;
  TextEditingController apellidoMaternoController;

  @override
  void initState() {
    super.initState();
    correoElectronicoController = new TextEditingController();
    nombreController = new TextEditingController();
    apellidoPaternoController = new TextEditingController();
    apellidoMaternoController = new TextEditingController();
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
                            child: Text('Confirmar registro',
                                style: TextStyle(fontSize: 18.0)),
                          ))
                        ]))),
            Card(
                child: Padding(
                    padding: EdgeInsets.all(10),
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
                                child: Column(children: [
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
                                      )))
                            ])),
                            Expanded(
                                child: Column(children: [
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
                            ]))
                          ]),
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
                                    'Siguiente',
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
                                            0 ||
                                        correoElectronicoController.text
                                                .trim()
                                                .length ==
                                            0) {
                                      showError(context,
                                          'Faltan datos por ingresar', '');
                                    } else {
                                      bool emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(
                                              correoElectronicoController.text);
                                      if (emailValid) {
                                        //Check email
                                        clientRef
                                            .orderByChild("correoElectronico")
                                            .equalTo(correoElectronicoController
                                                .text
                                                .trim())
                                            .limitToFirst(1)
                                            .once()
                                            .then((snapshot) {
                                          try {
                                            List<dynamic> curretList = [];
                                            snapshot.value
                                                .forEach((orderId, orderData) {
                                              curretList.add(orderData);
                                            });
                                            //Check name
                                            clientRef
                                                .orderByChild("nombre")
                                                .equalTo(nombreController.text
                                                    .trim())
                                                .limitToFirst(1)
                                                .once()
                                                .then((snapshot) {
                                              try {
                                                List<dynamic> curretList = [];
                                                snapshot.value.forEach(
                                                    (orderId, orderData) {
                                                  curretList.add(orderData);
                                                });
                                                //Check father's last name
                                                clientRef
                                                    .orderByChild(
                                                        "apellidoPaterno")
                                                    .equalTo(
                                                        apellidoPaternoController
                                                            .text
                                                            .trim())
                                                    .limitToFirst(1)
                                                    .once()
                                                    .then((snapshot) {
                                                  try {
                                                    List<dynamic> curretList =
                                                        [];
                                                    snapshot.value.forEach(
                                                        (orderId, orderData) {
                                                      curretList.add(orderData);
                                                    });
                                                    //Check father's last name
                                                    clientRef
                                                        .orderByChild(
                                                            "apellidoMaterno")
                                                        .equalTo(
                                                            apellidoMaternoController
                                                                .text
                                                                .trim())
                                                        .limitToFirst(1)
                                                        .once()
                                                        .then((snapshot) {
                                                      try {
                                                        List<dynamic>
                                                            curretList = [];
                                                        snapshot.value.forEach(
                                                            (orderId,
                                                                orderData) {
                                                          curretList
                                                              .add(orderData);
                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ShowLocation(
                                                                        correoElectronicoController
                                                                            .text)));
                                                      } catch (e) {
                                                        showError(
                                                            context,
                                                            'No existe ningún registro con los datos',
                                                            'ingresados');
                                                      }
                                                    });
                                                  } catch (e) {
                                                    showError(
                                                        context,
                                                        'No existe ningún registro con los datos',
                                                        'ingresados');
                                                  }
                                                });
                                              } catch (e) {
                                                showError(
                                                    context,
                                                    'No existe ningún registro con los datos',
                                                    'ingresados');
                                              }
                                            });
                                          } catch (e) {
                                            showError(
                                                context,
                                                'No existe ningún registro con los datos ingresados',
                                                '');
                                          }
                                        });
                                      } else {
                                        showError(
                                            context,
                                            'Ingrese un correo electrónico válido',
                                            '');
                                      }
                                    }
                                  })))
                    ])))
          ]),
        )));
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
