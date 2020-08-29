import 'package:flutter/material.dart';
import 'package:test_app/main.dart';
import 'package:test_app/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return   MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: _LoginPage(),
        backgroundColor: Colors.green,
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
      },
    );
  }
}









class _LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  doLogin() {
    var em = email.text;
    var pass = password.text;

    if (isEmail(em)) {
      validateUser(em, pass);
    }else{
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Datos incorrectos debes, debes escribir un email valido!"),
      ));
    }
  }

  validateUser(String email, String password) {
    if ((email == "ricky@gmail.com") && (password == "1234")) {
      saveSesionState(); //Save Sesion
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Datos invalidos"),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              maxLength: 15,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Email Adress',
              ),
              onSaved: (String value) {},
              validator: (String value) {
                //Validators!!
                return value.contains('@') ? 'Do not use the @ char.' : null;
              },
              controller: email,
            ),
            TextFormField(
              maxLength: 15,
              decoration: const InputDecoration(
                  labelText: 'Password', icon: Icon(Icons.lock)),
              validator: (val) =>
              val.length <  16 ? 'Password too short.' : null,
              onSaved: (val) => {},
              controller: password,
            ),
            Container(
                padding: EdgeInsets.all(14.0),
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)),
                  onPressed: () => doLogin(),
                  color: Colors.white,
                  textColor: Colors.green,
                  child: Text("Login".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ))
          ],
        ),
      ),
    );
  }

  bool isEmail(String email) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
  }


  saveSesionState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_user_example', "0000.1111.2222");  //Solo para cuestiones practicas
  }




}



//SplashScreean :::::::::::::::::::

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/login': (BuildContext context) => LoginPage(),
      },
    ); // define it once at root level.
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('jwt_user_example') ?? null;
    debugPrint(user);
    if(user != null){
      Navigator.pushReplacementNamed(context, '/home');
    }else{
      debugPrint(user);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text(
          'Splash Screen',
          style: new TextStyle(
              fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}