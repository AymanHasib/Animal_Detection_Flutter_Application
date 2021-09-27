import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {this.color = Colors.black,
      this.title = 'Sizan',
      required this.onPressed});

  final Color color;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 20.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: GradientText(
            title,
            style: TextStyle(fontSize: 20.0),
            colors: [Colors.cyanAccent, Colors.yellowAccent],
          ),
        ),
      ),
    );
  }
}
