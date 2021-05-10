import 'package:firebase_database/firebase_database.dart';

class Client {
  String id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String latitud;
  String longitud;
  String correoElectronico;
  String telefono;
  String foto;

  Client(
      this.id,
      this.nombre,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.latitud,
      this.longitud,
      this.correoElectronico,
      this.telefono,
      this.foto);

  Client.map(dynamic obj) {
    this.nombre = obj['nombre'];
    this.apellidoPaterno = obj['apellidoPaterno'];
    this.apellidoMaterno = obj['apellidoMaterno'];
    this.latitud = obj['latitud'];
    this.longitud = obj['longitud'];
    this.correoElectronico = obj['correoElectronico'];
    this.telefono = obj['telefono'];
    this.foto = obj['foto'];
  }

  String get getId => id;

  String get getNombre => nombre;

  String get getApellidoPaterno => apellidoPaterno;

  String get getApellidoMaterno => apellidoMaterno;

  String get getLatitud => latitud;

  String get getLongitud => longitud;

  String get getCorreoElectronico => correoElectronico;

  String get getTelefono => telefono;

  String get getFoto => foto;

  Client.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    nombre = snapshot.value['nombre'];
    apellidoPaterno = snapshot.value['apellidoPaterno'];
    apellidoMaterno = snapshot.value['apellidoMaterno'];
    latitud = snapshot.value['latitud'];
    longitud = snapshot.value['longitud'];
    correoElectronico = snapshot.value['correoElectronico'];
    telefono = snapshot.value['telefono'];
    foto = snapshot.value['foto'];
  }
}
