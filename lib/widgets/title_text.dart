import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TitleText extends StatelessWidget {
  final String pageTitle;

  const TitleText({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        pageTitle,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1.0)),
      ),
    );
  }
}
