// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';

class TimerButton extends StatefulWidget {
  final double time;
  TimerButton({this.time});

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  List<double> screenSize = List(2);
  Timer time;
  double timer;
  String timerAsString;
  int decimalPart;

  void startGame() {
    if (time != null) {
      time.cancel();
    }
    time = Timer.periodic(
        Duration(minutes: widget.time.toInt().floor(), seconds: decimalPart),
        (value) {
      setState(() {
        if (timer > 0.0) {}
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timer = widget.time;
    timerAsString = timer.toStringAsFixed(2);
    int indexOfDecimal = timerAsString.indexOf('.');
    decimalPart = int.tryParse(timerAsString.substring(indexOfDecimal)) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    screenSize[0] = MediaQuery.of(context).size.width;
    screenSize[1] = MediaQuery.of(context).size.height * 0.43;

    //TODO: Zrotatowac dla odpowiedniej strony

    return Container(
      width: screenSize[0],
      height: screenSize[1],
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timer.floor().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 60.0, letterSpacing: 2.0),
            ),
            Text(
              '.',
              style: TextStyle(fontSize: 60.0),
            ),
            Text(decimalPart.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 60.0, letterSpacing: 2.0))
          ],
        ),
        onPressed: () {},
      ),
    );
  }
}
