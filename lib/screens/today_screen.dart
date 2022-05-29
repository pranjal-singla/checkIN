import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_attendance_app/models/user.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayScreen extends StatefulWidget {
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

@override


class _TodayScreenState extends State<TodayScreen> {
  final Color kPrimary = const Color(0xFFD61C4E);
  double screenHeight = 0;
  double screenWidth = 0;
  String checkIn = "--/--";
  String checkOut = "--/--";

  @override
  void initState()  {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Employee')
          .where('id', isEqualTo: 'Pranjal')
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
      print(checkOut);
    }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    SharedPreferences sharedPreferences;

    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 32),
            child: Text(
              'Welcome',
              style: TextStyle(
                fontSize: screenWidth / 24,
              ),
            )),
        Container(
            alignment: Alignment.centerLeft,
            //margin : EdgeInsets.only(top : 32),
            child: Text(
              'Employee' + User.username,
              style: TextStyle(
                fontSize: screenWidth / 18,
                fontWeight: FontWeight.bold,
              ),
            )),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 32),
            child: Text(
              'Todays Schedule',
              style: TextStyle(
                fontSize: screenWidth / 18,
                fontWeight: FontWeight.w900,
              ),
            )),
        Container(
          margin: EdgeInsets.only(top: 12, bottom: 30),
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2)),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Check In',
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      checkIn,
                      style: TextStyle(
                        fontSize: screenWidth / 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
                text: DateTime.now().day.toString(),
                style: TextStyle(
                  color: kPrimary,
                  fontSize: screenWidth / 18,
                ),
                children: [
                  TextSpan(
                      text: DateFormat('MMMM yyyy').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth / 24,
                        fontWeight: FontWeight.w700,
                      ))
                ]),
          ),
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat('hh:mm:ss').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: screenWidth / 20,
                    color: Colors.black54,
                  ),
                ),
              );
            }),
        checkOut == "--/--" ? Container(
          margin: EdgeInsets.only(top: 24),
          child: Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> key = GlobalKey();
              return SlideAction(
                text: checkIn == "--/--" ? 'Slide to Check In' : 'Slide to CheckOut',
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth / 20,
                ),
                outerColor: Colors.white,
                innerColor: kPrimary,
                key: key,
                onSubmit: () async {
                  key.currentState!.reset();
                  QuerySnapshot snap = await FirebaseFirestore.instance
                      .collection('Employee')
                      .where('id', isEqualTo: 'Pranjal')
                      .get();

                  DocumentSnapshot snap2 = await FirebaseFirestore.instance
                      .collection("Employee")
                      .doc(snap.docs[0].id)
                      .collection("Record")
                      .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                      .get();

                  try {
                    String checkIns = snap2['checkIn'];
                    await FirebaseFirestore.instance
                        .collection("Employee")
                        .doc(snap.docs[0].id)
                        .collection("Record")
                        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now())).update({
                      'checkIn' : checkIns,
                      'chekOut' : DateFormat('hh:mm').format(DateTime.now()),
                    });
                  } catch(e){
                    await FirebaseFirestore.instance
                        .collection("Employee")
                        .doc(snap.docs[0].id)
                        .collection("Record")
                        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now())).set({
                      'checkIn' : DateFormat('hh:mm').format(DateTime.now()),
                    });
                  }



                },
              );
            },
          ),
        ) : Container(child : Text('Done for the day'))
      ]),
    ));
  }
}
