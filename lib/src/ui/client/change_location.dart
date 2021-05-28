import 'package:be_lot_system/src/ui/client/index_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChangeLocation extends StatefulWidget {
  final String id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correoElectronico;
  final String foto;
  final String latitud;
  final String longitud;
  final String telefono;

  ChangeLocation(
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
  _ChangeLocationState createState() => _ChangeLocationState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _ChangeLocationState extends State<ChangeLocation> {
  String newLat;
  String newLong;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.nombre),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Column(children: [
          Container(
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Center(
                              child: Text('Cambiar domicilio',
                                  style: TextStyle(fontSize: 18.0)),
                            ))
                          ])))),
          Expanded(
              child: Card(
                  child: Column(children: [
            Expanded(
                child: Container(
              child: GoogleMap(
                markers: {
                  Marker(
                      markerId: MarkerId('locClient'),
                      position: LatLng(
                          double.tryParse(widget.latitud) ?? 19.293590,
                          double.tryParse(widget.longitud) ?? 19.293590),
                      draggable: true,
                      onDragEnd: ((newPosition) {
                        newLat = newPosition.latitude.toString();
                        newLong = newPosition.longitude.toString();
                      }))
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(double.tryParse(widget.latitud) ?? 19.293590,
                        double.tryParse(widget.longitud) ?? 19.293590),
                    zoom: 15),
              ),
            ))
          ]))),
          Container(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.purple[200],
                      child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                          child: Text(
                            'Guardar cambios',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (newLat != null && newLong != null) {
                              clientRef.child(widget.id).set({
                                'nombre': widget.nombre,
                                'apellidoPaterno': widget.apellidoPaterno,
                                'apellidoMaterno': widget.apellidoMaterno,
                                'latitud': newLat,
                                'longitud': newLong,
                                'correoElectronico': widget.correoElectronico,
                                'telefono': widget.telefono,
                                'foto': widget.foto,
                              });
                              Fluttertoast.showToast(
                                  msg: "Cambios guardados",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => IndexClient(
                                          widget.correoElectronico)),
                                  (Route<dynamic> route) => false);
                            } else {
                              showWarning(context, 'La ubicación es la misma');
                            }
                          }))))
        ]));
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
