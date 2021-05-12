import 'package:be_lot_system/src/ui/admin/index_admin.dart';
import 'package:be_lot_system/src/ui/client/confirm_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Login());
}

bool loggedIn = false;

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: Logged(),
    );
  }
}

class Logged extends StatefulWidget {
  const Logged({Key key}) : super(key: key);

  @override
  _LoggedState createState() => _LoggedState();
}

FirebaseDatabase database = new FirebaseDatabase();

class _LoggedState extends State<Logged> {
  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("mail") != null) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: loggedIn ? IndexAdmin() : Form(),
    );
  }

  @override
  void initState() {
    super.initState();
    this._function();
    loggedIn = false;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }
}

class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  TextEditingController mailController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    mailController = new TextEditingController();
    passwordController = new TextEditingController();
  }

  Future<Null> _ensureLoggedIn(UserCredential user) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    prefs.setString("mail", user.user.email);
    this.setState(() {
      loggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Be IoT System'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 40.0),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          new Image.asset(
                            'assets/logo.png',
                            width: 180,
                          ),
                          Theme(
                              data: ThemeData(primaryColor: Colors.purple),
                              child: TextField(
                                controller: mailController,
                                style: TextStyle(fontSize: 20.0),
                                decoration: InputDecoration(
                                  icon: Icon(Icons.mail_outline),
                                  labelText: 'Correo electrónico:',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              )),
                          Padding(padding: EdgeInsets.only(top: 8.0)),
                          Theme(
                              data: ThemeData(primaryColor: Colors.purple),
                              child: TextField(
                                controller: passwordController,
                                style: TextStyle(fontSize: 20.0),
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.vpn_key_outlined),
                                  labelText: 'Contraseña:',
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.go,
                              )),
                          Padding(padding: EdgeInsets.only(bottom: 30.0)),
                          Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.purple[200],
                              child: MaterialButton(
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 15.0, 30.0, 15.0),
                                  child: Text(
                                    'Iniciar sesión',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    try {
                                      UserCredential userCredential =
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: mailController.text,
                                                  password:
                                                      passwordController.text);

                                      if (userCredential != null) {
                                        _ensureLoggedIn(userCredential);
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        IndexAdmin()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      }
                                    } catch (e) {
                                      if (e.code == 'user-not-found') {
                                        print('No user found for that email.');
                                        showWarning(context);
                                      } else if (e.code == 'wrong-password') {
                                        print(
                                            'Wrong password provided for that user.');
                                        showWarning(context);
                                      } else {
                                        print('ERROR*********************');
                                        showError(context);
                                      }
                                    }
                                  })),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.pink[200],
                                  child: MaterialButton(
                                      padding: EdgeInsets.fromLTRB(
                                          30.0, 15.0, 30.0, 15.0),
                                      child: Text(
                                        'Registrarse',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfirmRegistration()));
                                      })))
                        ]))))));
  }

  void showWarning(BuildContext ctxt) {
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
                          Text('El correo electrónico o la contraseña'),
                          Text('son incorrectos'),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(ctxt);
                                    mailController.clear();
                                    passwordController.clear();
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

  void showError(BuildContext ctxt) {
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
                          Text('Ingrese datos válidos'),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(ctxt);
                                    mailController.clear();
                                    passwordController.clear();
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
