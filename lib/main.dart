import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/DbHelper/DbHelper.dart';
import 'package:test_app/DetailUser.dart';
import 'package:test_app/Login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:test_app/models/User.dart';
import 'package:test_app/DbHelper/DbHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:math';


void main() =>  runApp(
  MaterialApp(
    home: MyApp()
  )
) ;


class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("LIsta Doctores"),
          backgroundColor: Colors.green,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => {logOut()},
                  child: Icon(
                    Icons.exit_to_app,
                    size: 26.0,
                  ),
                )
            )
          ],
        ),
        body: UserList(),
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) =>  LoginPage(),
      },
    );
  }

  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt_user_example');
    Navigator.pushReplacementNamed(context, '/login');
  }
}

class UserList extends StatefulWidget{
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  Map data;
  List<UserModel> users = [];
  bool loading = false;
  bool failAuthFinger = false;



  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    isAvailable = await _localAuthentication.canCheckBiometrics;
    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');
    return isAvailable;
  }


  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
        "Ponga su huella para authenticar!",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (isAuthenticated) {
      loading = true;
      fetchUsers();
    }


  }


  verifyUsers(){
    DatabaseHelper.instance.fetchLocalUsers().then((data) {   // Fail error
     if(data.length == 0) {
       debugPrint("ONLINE DATA");
       fetchUsers();
     }else{
       debugPrint("SQLITE data");
       loading = false;
       users = data;
       print(data.length);
     }
   } );
  }


  @override
  void initState()  {
   if(_isBiometricAvailable() != null){
     _authenticateUser();
   }else{
     loading = true;
     fetchUsers();

   }
    super.initState();
  }

  fetchLocalUsers() async{
    List<UserModel> users ;
    users =  await DatabaseHelper.instance.fetchLocalUsers();
    debugPrint(users.toString());
  }

  void fetchUsers() async {
    http.Response response =
    await http.get("https://randomuser.me/api/?results=5");
    data = json.decode(response.body);

    List<UserModel> _users = [];

    debugPrint(response.body);

    for (var userJson in data['results']) {
      //DatabaseHelper.instance.insertUser(UserModel.fromJson(userJson));
      _users.add(UserModel.fromJson(userJson));
    }

    setState(() {
      users = _users;
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
      if(loading){
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return  ListView.builder(
        itemCount: users == null ? 0 : users.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Row(
                children: [
                  Text(users[index].fullname),
                  Icon( Icons.star, color: Colors.yellow, size: 24.0 ),
                  Text("4.5")
                ],
              ),
              subtitle: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(users[index].email, style: TextStyle(color: Colors.grey),)),

                  Row(
                    children: [
                      Icon(  Icons.location_on, color: Colors.grey,size: 24.0),
                      Text(users[index].street),
                    ],
                  )
                ],
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(users[index].picture),
              ),

              onTap: () => onTapped(users[index]),

            ),
          );

        },
      );



  }

  void onTapped(UserModel user) {
    debugPrint(user.uuid +" " +user.lat + " "+ user.lng + user.postal_code + user.phone_number);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailUser(user: user)
    ));
  }

  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt_user_example');
    Navigator.pushReplacementNamed(context, '/home');
  }








}
