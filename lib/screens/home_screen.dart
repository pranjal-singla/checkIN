import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import 'today_screen.dart';

class HomeScreen extends StatefulWidget {

  double screenHeight = 0;
  double screenWidth = 0;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  final Color kPrimary = const Color(0xFFD61C4E);

  List<IconData> navigationIcons = [
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: IndexedStack(
        index : currentIndex,
        children: [
          TodayScreen(),
          TakePictureScreen(),
        ],
      ),
        bottomNavigationBar: Container(
          height: 70,
          margin: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2,2),
              ),
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i =0; i<navigationIcons.length; i++) ... <Expanded>{
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            currentIndex =i;
                          });
                        },
                        child: Icon(
                          navigationIcons[i],
                          color: i==currentIndex ? kPrimary : Colors.black26,
                          size: i == currentIndex ? 30 : 26,
                        ),
                      ),
                    )
                  }
                ],
              ),
          ),
          )
    );
  }
}
