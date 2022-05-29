import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'home_screen.dart';
import 'package:my_attendance_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double screenHeight = 0;
  double screenWidth = 0;
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final Color kPrimary = const Color(0xFFD61C4E);

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    SharedPreferences sharedPreferences;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible ? SizedBox(height: screenHeight/16,) :
          Container(
            height: screenHeight / 3,
            width: screenWidth,
            decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(70),
                )),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: screenWidth / 5,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: screenHeight / 15,
              bottom: screenHeight / 20,
            ),
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: screenWidth / 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth / 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldTitle(
                    title: 'Employee ID',
                    screenWidth: screenWidth,
                    screenHeight: screenHeight),
                customField(
                  screenWidth: screenWidth,
                  kPrimary: kPrimary,
                  screenHeight: screenHeight,
                  hintText: 'Enter your employee ID',
                  controller: idController,
                  obscure: false,
                ),
                fieldTitle(
                    title: 'Password',
                    screenWidth: screenWidth,
                    screenHeight: screenHeight),
                customField(
                  screenWidth: screenWidth,
                  kPrimary: kPrimary,
                  screenHeight: screenHeight,
                  hintText: 'Enter your Password',
                  controller: passController,
                  obscure: true,
                ),
                GestureDetector(
                  onTap: () async {
                    String id = idController.text.trim();
                    String password = passController.text.trim();

                    if (id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Employee ID Empty'),
                      ));
                    } else if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Password Empty'),
                      ));
                    } else {
                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection("Employee")
                          .where('id', isEqualTo: id)
                          .get();
                      try {
                        if (password == snap.docs[0]['password']) {
                          sharedPreferences = await SharedPreferences.getInstance();
                          sharedPreferences.setString('employeeID', id).then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          });
                        }
                        else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Wrong Password!'),
                          ));
                        }
                      } catch (e) {
                        String error = " ";
                        if (e.toString() ==
                            'RangeError (index) : Invalid value : Valid value') {
                          setState(() {
                            error = 'Invalid User ID';
                          });
                        } else {
                          setState(() {
                            error = "Some Error Occurred!";
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(error),
                        ));
                      }
                    }
                  },
                  child: Container(
                    height: 60,
                    width: screenWidth,
                    margin: EdgeInsets.only(top: screenHeight / 40),
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: screenWidth / 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
