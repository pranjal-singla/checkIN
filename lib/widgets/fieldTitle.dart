import 'package:flutter/cupertino.dart';

class fieldTitle extends StatelessWidget {
  const fieldTitle({
    Key? key,
    required this.title,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  final String title;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
        ),
      ),
    );
  }
}
