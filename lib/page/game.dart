import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Game extends StatefulWidget {
  const Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<int> blackTeamShots = new List(2);
  List<int> whiteTeamShots = new List(2);
  List<bool> playerPlaying = [true, false, false];
  List<double> screenSize = List(2);
  bool isWhite;
  int timeAmount;

  @override
  void initState() {
    super.initState();
    blackTeamShots = [0, 0];
    whiteTeamShots = [0, 0];
    isWhite = true;
    timeAmount = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    Duration countdownDuration = Duration(minutes: timeAmount);
    screenSize[0] = MediaQuery.of(context).size.width;
    screenSize[1] = MediaQuery.of(context).size.height * 0.415;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            Divider(
              height: 10.0,
              thickness: 3.0,
            ),
            pieceButtons(),
            Divider(
              height: 10.0,
              thickness: 3.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget timerButton(int timeAmount, bool isWhite) {
    final stopWatch = StopWatchTimer();
  }

  Widget pieceButtons() {
    final barHeight = 70.0;

    return Container(
      height: barHeight,
      width: MediaQuery.of(context).size.width - 15.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          pieceIcon(
              'pawn.png',
              1,
              playerPlaying[0] == true
                  ? null
                  : playerPlaying[1] == true
                      ? true
                      : playerPlaying[2] == true
                          ? false
                          : null),
          pieceIcon(
              'knight.png',
              3,
              playerPlaying[0] == true
                  ? null
                  : playerPlaying[1] == true
                      ? true
                      : playerPlaying[2] == true
                          ? false
                          : null),
          pieceIcon(
              'bishop.png',
              3,
              playerPlaying[0] == true
                  ? null
                  : playerPlaying[1] == true
                      ? true
                      : playerPlaying[2] == true
                          ? false
                          : null),
          pieceIcon(
              'rook.png',
              5,
              playerPlaying[0] == true
                  ? null
                  : playerPlaying[1] == true
                      ? true
                      : playerPlaying[2] == true
                          ? false
                          : null),
          pieceIcon(
              'queen.png',
              9,
              playerPlaying[0] == true
                  ? null
                  : playerPlaying[1] == true
                      ? true
                      : playerPlaying[2] == true
                          ? false
                          : null),
          pieceIcon(
              'king.png',
              7,
              playerPlaying[0] == true
                  ? null
                  : playerPlaying[1] == true
                      ? true
                      : playerPlaying[2] == true
                          ? false
                          : null,
              30.0),
        ],
      ),
    );
  }

  Widget pieceIcon(String path, int shots, bool isWhite,
      [double imageSize = 50.0]) {
    if (isWhite != null) {
      return IconButton(
          icon: Image.asset(path),
          iconSize: imageSize,
          onPressed: () {
            switch (shots) {
              case 1:
              case 3:
              case 5:
              case 7:
              case 9:
                if (isWhite) {
                  whiteTeamShots[0] = whiteTeamShots[1];
                  whiteTeamShots[1] += shots;
                } else {
                  blackTeamShots[0] = blackTeamShots[1];
                  blackTeamShots[1] += shots;
                }
                break;
              default:
                break;
            }
          });
    } else {
      return Opacity(
        opacity: 0.5,
        child: IconButton(
          icon: Image.asset(path),
          iconSize: imageSize,
          onPressed: null,
        ),
      );
    }
  }
}
