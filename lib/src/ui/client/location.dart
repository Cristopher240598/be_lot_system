import 'dart:async';

import 'package:be_lot_system/src/ui/client/complete_registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ShowLocation extends StatefulWidget {
  final String correoElectronico;

  ShowLocation(this.correoElectronico);

  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  Location location;
  var lat;
  var long;
  String newLat;
  String newLong;
  CameraPosition _ubicacionInicial;
  CameraPosition _ubicacion;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    try {
      lat = currentLocation.latitude;
      long = currentLocation.longitude;
      marcador();
      _ubicacion = CameraPosition(target: LatLng(lat, long), zoom: 16);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_ubicacion));
    } catch (e) {
      print(e);
    }
  }

  void marcador() async {
    final MarkerId markerId = MarkerId('loc');

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        draggable: true,
        onDragEnd: ((newPosition) {
          newLat = newPosition.latitude.toString();
          newLong = newPosition.longitude.toString();
        }));
    setState(() {
      _markers[markerId] = marker;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_ubicacion));
  }

  @override
  void initState() {
    location = new Location();
    setInitialLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ubicacionInicial =
        CameraPosition(target: LatLng(19.293590, -99.654380), zoom: 5);

    return Scaffold(
        appBar: AppBar(
          title: Text('Be IoT System'),
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
                              child: Text('Localización',
                                  style: TextStyle(fontSize: 18.0)),
                            ))
                          ])))),
          Expanded(
              child: Card(
                  child: Column(children: [
            Expanded(
                child: Container(
                    child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              mapType: MapType.normal,
              initialCameraPosition: _ubicacionInicial,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ))),
            Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.purple[200],
                        child: MaterialButton(
                            padding:
                                EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                            child: Text(
                              'Siguiente',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (newLat != null && newLong != null) {
                                print('+++++++++++');
                                print(newLat);
                                print(newLong);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompleteRegistration(
                                                widget.correoElectronico,
                                                newLat,
                                                newLong)));
                              } else {
                                print('------------');
                                print(lat.toString());
                                print(long.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompleteRegistration(
                                                widget.correoElectronico,
                                                lat.toString(),
                                                long.toString())));
                              }
                            }))))
          ])))
        ]));
  }
}