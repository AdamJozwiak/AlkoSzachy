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
    final int timer = ModalRoute.of(context).settings.arguments;
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
            pieceButtons(),
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

  Widget pieceButtons() {
    final barHeight = 70.0;
    final imageSize = 50.0;

    return Container(
      height: barHeight,
      width: MediaQuery.of(context).size.width - 15.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: Image.asset(
                'pawn.png',
              ),
              iconSize: imageSize,
              onPressed: null),
          IconButton(
              icon: Image.asset(
                'knight.png',
              ),
              iconSize: imageSize,
              onPressed: null),
          IconButton(
              icon: Image.asset(
                'bishop.png',
              ),
              iconSize: imageSize,
              onPressed: null),
          IconButton(
              icon: Image.asset(
                'rook.png',
              ),
              iconSize: imageSize,
              onPressed: null),
          IconButton(
              icon: Image.asset(
                'queen.png',
              ),
              iconSize: imageSize,
              onPressed: null),
          IconButton(
              icon: Image.asset(
                'king.png',
              ),
              iconSize: imageSize - 15,
              onPressed: null),
        ],
      ),
    );
  }
}
