import 'package:flutter/material.dart';

class customField extends StatelessWidget {
  const customField({
    Key? key,
    required this.screenWidth,
    required this.kPrimary,
    required this.screenHeight,
    required this.hintText,
    required this.controller,
    required this.obscure,
  }) : super(key: key);

  final double screenWidth;
  final Color kPrimary;
  final double screenHeight;
  final String hintText;
  final TextEditingController controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: screenHeight/40),
        width: screenWidth,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2))
            ]),
        child: Row(
          children: [
            Container(
              width: screenWidth / 8,
              child: Icon(
                Icons.person,
                color: kPrimary,
                size: screenWidth / 15,
              ),
            ),
            Expanded(
              child: TextFormField(
                enableSuggestions: false,
                autocorrect: false,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hintText,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            )
          ],
        ));
  }
}


