import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final text;
  final fontSize;
  final color;
  final weight;
  final wordSpacing;
  final letterSpacing;
  final textAlign;
  const CustomText(
      {Key key,
      this.text,
      this.fontSize,
      this.color,
      this.weight,
      this.wordSpacing,
      this.letterSpacing,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize != null ? fontSize : 20.0,
          color: color != null ? color : Colors.black87,
          fontWeight: weight != null ? weight : FontWeight.normal,
          wordSpacing: wordSpacing != null ? wordSpacing : 5.0,
          letterSpacing: letterSpacing != null ? letterSpacing : 1.0),
      textAlign: textAlign != null ? textAlign : TextAlign.center,
    );
  }
}
