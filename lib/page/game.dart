import 'package:alkochin/widgets/timer_button.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    final double timer = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            TimerButton(time: timer),
            Divider(
              height: 10.0,
              thickness: 3.0,
            ),
            Container(
              height: 51.0,
            ),
            Divider(
              height: 10.0,
              thickness: 3.0,
            ),
            TimerButton(time: timer)
          ],
        ),
      ),
    );
  }
}
