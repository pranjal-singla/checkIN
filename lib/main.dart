import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:my_attendance_app/screens/home_screen.dart';
import 'package:my_attendance_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:camera/camera.dart';
import 'package:my_attendance_app/models/user.dart';

List<CameraDescription> cameras = [];


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KeyboardVisibilityProvider(child : LoginPage()),
    );
  }
}
class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {

  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState(){
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async{
    sharedPreferences = await SharedPreferences.getInstance();

    try{
      if(sharedPreferences.getString('employeeID') != null){
        setState(() {
          User.username = sharedPreferences.getString('employeeID')!;
          userAvailable = true;
        });
      }
    }
    catch(e){
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ?  HomeScreen() : LoginPage();
  }
}
