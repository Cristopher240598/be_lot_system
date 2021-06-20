import 'package:be_lot_system/main.dart';
import 'package:be_lot_system/src/ui/client/ConstantsMenu.dart';
import 'package:be_lot_system/src/ui/client/change_location.dart';
import 'package:be_lot_system/src/ui/client/credits.dart';
import 'package:be_lot_system/src/ui/client/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
Map<String, dynamic> map ;
Future<datosMes> datosMesget() async {
  final response =
  await http.get('http://besoftware.com.mx/iot/datosmovil');

  if (response.statusCode == 200) {
    // Si la llamada al servidor fue exitosa, analiza el JSON
    map=json.decode(response.body);
    return datosMes.fromJson(json.decode(response.body));
  } else {
    // Si la llamada no fue exitosa, lanza un error.
    throw Exception('Failed to load post');
  }
}

Future<List> tablaGastos() async {
  final response = await http.get("http://besoftware.com.mx/iot/tablagastos");
  return json.decode(response.body);
}




class datosMes {

  final String wattsmes;
  final String litrosmes;
  final String fgas;
  final String aguainm;
  final String eli;


  datosMes({this.wattsmes, this.litrosmes,this.fgas,this.aguainm,this.eli});

  factory datosMes.fromJson(Map<String, dynamic> json) {
    return datosMes(
      wattsmes: json['wattsmes'],
      litrosmes: json['litrosmes'],
      fgas: json['fgas'],
      aguainm: json['aguainm'],
      eli: json['eli'],
    );
  }
}


class IndexClient extends StatefulWidget {
  final String correoElectronico;

  IndexClient(this.correoElectronico);

  @override
  _IndexClientState createState() => _IndexClientState();
}

final clientRef = FirebaseDatabase.instance.reference().child('clientes');

class _IndexClientState extends State<IndexClient> {
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String latitud;
  String longitud;
  String telefono;
  String foto;
  String id;



  Future<Null> _logoutUser() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // ignore: deprecated_member_use
    prefs.commit();
  }
  Future<datosMes> data;
  double a;
  double b;
  String errores;
  @override
  void initState() {
    data=datosMesget();
    String elimes = "50.0";
    String litmes="50.0";
     FutureBuilder<datosMes>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            litmes=snapshot.data.litrosmes;
            return Text(snapshot.data.litrosmes);
          } else if (snapshot.hasError) {
            litmes="50.0";
            return Text("50.0");
          }
        }).createElement();

    FutureBuilder<datosMes>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            elimes = snapshot.data.wattsmes;
            return Text(snapshot.data.wattsmes);
          } else if (snapshot.hasError) {
            elimes = "50.0";
            return Text("50.0");
          }
        });
try{
    elimes = map["wattsmes"];
    litmes = map["litrosmes"];}catch(e){

}
    double x,y;

    x = double.parse(elimes);
    y = double.parse(litmes);
    double inter = x+y+0;
    a= (x*100)/inter;
    b= (y*100)/inter;
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
        setState(() {
          nombre = clienteData[0]['nombre'];
          apellidoPaterno = clienteData[0]['apellidoPaterno'];
          apellidoMaterno = clienteData[0]['apellidoMaterno'];
          latitud = clienteData[0]['latitud'];
          longitud = clienteData[0]['longitud'];
          telefono = clienteData[0]['telefono'];
          foto = clienteData[0]['foto'];
          id = clienteID[0];
        });
      } catch (e) {
        print(e);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<PieChartSectionData> sectionsChart = [
      PieChartSectionData(
        value: b,
        title: "Agua",
        showTitle: true,
        color: Colors.orange,
        radius: 100,
      ),
      PieChartSectionData(
        value: a,
        title: "Electricidad",
        showTitle: true,
        color: Colors.red,
        radius: 100,
      ),
    ];
    return Scaffold(
        appBar: AppBar(
            title: nombre != null ? Text(nombre) : Text('Be IoT System'),
            backgroundColor: Colors.purpleAccent,
            actions: <Widget>[
              PopupMenuButton<String>(
                  icon: foto != null
                      ? foto.length != 0
                      ? CircleAvatar(
                    radius: 16.5,
                    backgroundImage: NetworkImage(foto),
                    backgroundColor: Colors.white,
                  )
                      : CircleAvatar(
                    radius: 16.5,
                    backgroundImage: AssetImage('assets/client.png'),
                    backgroundColor: Colors.white,
                  )
                      : CircleAvatar(
                    radius: 16.5,
                    backgroundImage: AssetImage('assets/client.png'),
                    backgroundColor: Colors.white,
                  ),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return ConstantsMenu.choices.map((String choice) {
                      return PopupMenuItem<String>(
                          value: choice, child: Text(choice));
                    }).toList();
                  })
            ]),
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
                                      child: Text('Estadísticas',
                                          style: TextStyle(fontSize: 18.0)),
                                    ))
                              ]))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: FutureBuilder<datosMes>(
                                    future: data,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text("Gatos inmediato de electricidad: " + snapshot.data.eli + "W/hr");
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }

                                      // Por defecto, muestra un loading spinner
                                      return CircularProgressIndicator();
                                    },
                                  ),
                              ),

                            ),
                          ]))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child:  FutureBuilder<datosMes>(
                                    future: data,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text("Gatos mensual de electricidad: " + snapshot.data.wattsmes + "W");
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }

                                      // Por defecto, muestra un loading spinner
                                      return CircularProgressIndicator();
                                    },
                                  ),
                              ),
                            ),
                          ]))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child:  FutureBuilder<datosMes>(
                                    future: data,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text("Gatos mensual de agua: " + snapshot.data.litrosmes + "L");
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }

                                      // Por defecto, muestra un loading spinner
                                      return CircularProgressIndicator();
                                    },
                                  ),
                              ),
                            ),
                          ]))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child:  FutureBuilder<datosMes>(
                                    future: data,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text("Gatos inmediato de agua: " + snapshot.data.aguainm + "L/hr");
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }

                                      // Por defecto, muestra un loading spinner
                                      return CircularProgressIndicator();
                                    },
                                  ),
                              ),
                            ),
                          ]))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Cambios en gastos del mes: 38 %',
                                      style: TextStyle(fontSize: 15.0))),
                            ),
                          ]))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child:  FutureBuilder<datosMes>(
                                    future: data,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text("Fugas de gas el día de hoy: " + snapshot.data.fgas );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }

                                      // Por defecto, muestra un loading spinner
                                      return CircularProgressIndicator();
                                    },
                                  ),
                              ),
                            ),
                          ]))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Gráfica de gasto en general:',
                                      style: TextStyle(fontSize: 15.0))),
                            ),
                          ]))),

                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: PieChart(
                        PieChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: sectionsChart),
                      )),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Gastos:',
                                      style: TextStyle(fontSize: 15.0))),
                            ),
                          ]))),
                  DataTable(
                    sortColumnIndex: 2,
                    sortAscending: false,
                    columns: [
                      DataColumn(label: Text("id")),
                      DataColumn(label: Text("Año")),
                      DataColumn(label: Text("Bimestre"), numeric: true),
                      DataColumn(label: Text("Electricidad")),
                      DataColumn(label: Text("Agua")),
                      DataColumn(label: Text("Gas")),
                      DataColumn(label: Text("Cliente")),
                    ],
                    rows: [
                      DataRow(selected: true, cells: [
                        DataCell(Text("1")),
                        DataCell(Text("2021")),
                        DataCell(Text("3")),
                        DataCell(Text("250")),
                        DataCell(Text("120")),
                        DataCell(Text("0")),
                        DataCell(Text("1"))
                      ]),
                    ],
                  ),
                ]))));
  }

  void choiceAction(String choice) async {
    if (choice == ConstantsMenu.editarPerfil) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditProfile(
                  id,
                  nombre,
                  apellidoPaterno,
                  apellidoMaterno,
                  widget.correoElectronico,
                  foto,
                  latitud,
                  longitud,
                  telefono)));
    }
    if (choice == ConstantsMenu.cambiarDomicilio) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeLocation(
                  id,
                  nombre,
                  apellidoPaterno,
                  apellidoMaterno,
                  widget.correoElectronico,
                  foto,
                  latitud,
                  longitud,
                  telefono)));
    }
    if (choice == ConstantsMenu.cerrarSesion) {
      print('Cerrar');
      await FirebaseAuth.instance.signOut();
      _logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false);
    }
    if (choice == ConstantsMenu.creditos) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Credits()));
    }
  }
}
