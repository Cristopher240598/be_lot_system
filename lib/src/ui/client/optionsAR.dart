import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class OptAR extends StatefulWidget {
  @override
  _OptARState createState() => _OptARState();
}

class _OptARState extends State<OptAR> {
  ArCoreController arCoreController;

  _onArCoreViewCreated(ArCoreController _arcoreController) {
    arCoreController = _arcoreController;
    _addSphere(_arcoreController);
    _addSphere1(_arcoreController);
    _addSphere2(_arcoreController);
    _addSphere3(_arcoreController);
    _addSphere4(_arcoreController);
    _addSphere5(_arcoreController);
    _addSphere6(_arcoreController);
    _addSphere7(_arcoreController);
    _addSphere8(_arcoreController);
    _addSphere9(_arcoreController);
    _addSphere10(_arcoreController);
  }

  _addSphere(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.purple);
    final sphere = ArCoreSphere(materials: [material], radius: 0.7);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        -0,
        0,
        -3,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere1(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.pink);
    final sphere = ArCoreSphere(materials: [material], radius: 0.4);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        0.5,
        3,
        -5,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere2(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.pinkAccent);
    final sphere = ArCoreSphere(materials: [material], radius: 1);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        6.5, //izquierda-derecha
        2, //arriba-abajo
        -9, //adelante-atras
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere3(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.lightBlue);
    final sphere = ArCoreSphere(materials: [material], radius: 0.6);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        1.5,
        -0.8,
        -1,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere4(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.amber);
    final sphere = ArCoreSphere(materials: [material], radius: 0.3);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        -0.3,
        -1.8,
        -2,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere5(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.blueAccent);
    final sphere = ArCoreSphere(materials: [material], radius: 0.2);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        -1.2,
        -0.8,
        -3,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere6(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.green);
    final sphere = ArCoreSphere(materials: [material], radius: 0.6);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        -3,
        3,
        -5,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere7(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.teal);
    final sphere = ArCoreSphere(materials: [material], radius: 1.0);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        4.5,
        6,
        -5,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere8(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.black54);
    final sphere = ArCoreSphere(materials: [material], radius: 1.0);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        -1.0,
        6,
        -5,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  /*
  6.5,//izquierda-derecha
        2,//arriba-abajo
        -9,//adelante-atras
   */
  _addSphere9(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.blueGrey);
    final sphere = ArCoreSphere(materials: [material], radius: 0.4);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        -2,
        0,
        -2,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  _addSphere10(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.cyan);
    final sphere = ArCoreSphere(materials: [material], radius: 0.7);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        -2,
        -2.0,
        -1,
      ),
    );
    _arcoreController.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Be IoT System'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: ArCoreView(onArCoreViewCreated: _onArCoreViewCreated));
  }
}
