import 'package:flutter/material.dart';

class Credits extends StatefulWidget {
  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  @override
  Widget build(BuildContext context) {
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
                              child: Text('Créditos',
                                  style: TextStyle(fontSize: 18.0)),
                            ))
                          ])))),
          Expanded(
              child: Card(
                  child: Center(
                      child: Container(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
            new Image.asset(
              'assets/ITTol.png',
              width: 180,
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(children: [
                  Text('Instituto Tecnológico de Toluca',
                      style: TextStyle(fontSize: 23.0, color: Colors.black)),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('Desarrollado por:',
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.black))),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('Cristopher Enrique Díaz Robles',
                          style:
                          TextStyle(fontSize: 20.0, color: Colors.black))),
                  Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('y',
                          style:
                          TextStyle(fontSize: 15.0, color: Colors.black))),
                  Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('José Trinidad Quezada Chedid',
                          style:
                          TextStyle(fontSize: 20.0, color: Colors.black)))
                ]))
          ])))))
        ])

        /*SingleChildScrollView(
            child: Center(
                child: Column(children: [


        ])))*/
        );
  }
}
