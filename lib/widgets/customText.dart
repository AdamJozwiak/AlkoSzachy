import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final text;
  final fontSize;
  final fontFamily;
  final color;
  final weight;
  final wordSpacing;
  final letterSpacing;
  final textAlign;
  final backgroundColor;
  const CustomText(
      {Key key,
      this.text,
      this.fontSize,
      this.fontFamily,
      this.color,
      this.weight,
      this.wordSpacing,
      this.letterSpacing,
      this.textAlign,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (backgroundColor != null) {
      return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 13,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: backgroundColor),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize != null ? fontSize : 20.0,
                fontFamily: fontFamily != null ? fontFamily : null,
                color: color != null ? color : Colors.black87,
                fontWeight: weight != null ? weight : FontWeight.normal,
                wordSpacing: wordSpacing != null ? wordSpacing : 5.0,
                letterSpacing: letterSpacing != null ? letterSpacing : 1.0,
              ),
              textAlign: textAlign != null ? textAlign : TextAlign.center,
            ),
          )
        ]),
      );
    } else {
      return Text(
        text,
        style: TextStyle(
            fontSize: fontSize != null ? fontSize : 20.0,
            fontFamily: fontFamily != null ? fontFamily : null,
            color: color != null ? color : Colors.black87,
            fontWeight: weight != null ? weight : FontWeight.normal,
            wordSpacing: wordSpacing != null ? wordSpacing : 5.0,
            letterSpacing: letterSpacing != null ? letterSpacing : 1.0),
        textAlign: textAlign != null ? textAlign : TextAlign.center,
      );
    }
  }
}
