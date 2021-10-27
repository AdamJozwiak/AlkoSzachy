import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alkochin/widgets/stop_watch_timer.dart';

class Game extends StatefulWidget {
  const Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<int> blackTeamShots = new List<int>(2);
  List<int> whiteTeamShots = new List<int>(2);
  List<bool> playerPlaying = [true, false, false];
  List<double> screenSize = new List<double>(2);
  bool isWhite;
  final StopWatchTimer _whiteTimer = new StopWatchTimer();
  final StopWatchTimer _blackTimer = new StopWatchTimer();

  @override
  void initState() {
    super.initState();
    blackTeamShots = [0, 0];
    whiteTeamShots = [0, 0];
    isWhite = true;
    _whiteTimer.onExecute.add(StopWatchExecute.start);
    _blackTimer.onExecute.add(StopWatchExecute.stop);
  }

  @override
  void dispose() async {
    super.dispose();
    await _whiteTimer.dispose();
    await _blackTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize[0] = MediaQuery.of(context).size.width;
    screenSize[1] = MediaQuery.of(context).size.height * 0.415;
    _whiteTimer.setPresetMinuteTime(ModalRoute.of(context).settings.arguments);
    _blackTimer.setPresetMinuteTime(ModalRoute.of(context).settings.arguments);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            playerButton(!isWhite),
            Divider(
              height: 10.0,
              thickness: 3.0,
            ),
            pieceButtons(),
            Divider(
              height: 10.0,
              thickness: 3.0,
            ),
            playerButton(isWhite),
          ],
        ),
      ),
    );
  }

  Widget playerButton(bool isWhite) {
    return Container(
        width: screenSize[0],
        height: screenSize[1],
        child: RotatedBox(
          quarterTurns: isWhite ? 0 : 2,
          child: Expanded(
            child: TextButton(
                onPressed: () {
                  if (isWhite && _whiteTimer.isRunning) {
                    _whiteTimer.onExecute.add(StopWatchExecute.stop);
                    _blackTimer.onExecute.add(StopWatchExecute.start);
                  } else if (!isWhite && _blackTimer.isRunning) {
                    _whiteTimer.onExecute.add(StopWatchExecute.start);
                    _blackTimer.onExecute.add(StopWatchExecute.stop);
                  }
                },
                child: StreamBuilder<int>(
                  stream: isWhite
                      ? _whiteTimer.rawTime.cast<int>()
                      : _blackTimer.rawTime.cast<int>(),
                  initialData: isWhite
                      ? _whiteTimer.rawTime.value
                      : _blackTimer.rawTime.value,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: false);
                    return Text(
                      displayTime,
                      style: TextStyle(fontSize: 60.0, color: Colors.black),
                    );
                  },
                )),
          ),
        ));
  }

  Widget pieceButtons() {
    final barHeight = 70.0;
    return Container(
      height: barHeight,
      width: screenSize[0] - 15.0,
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
