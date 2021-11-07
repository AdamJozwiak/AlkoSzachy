import 'dart:math';

import 'package:alkochin/models/gameStartInfo.dart';
import 'package:alkochin/models/player.dart';
import 'package:flutter/material.dart';
import 'package:alkochin/widgets/stop_watch_timer.dart';

class Game extends StatefulWidget {
  const Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Player> blackTeam = new List<Player>();
  List<Player> whiteTeam = new List<Player>();
  List<int> blackTeamShots = new List<int>(2);
  List<int> whiteTeamShots = new List<int>(2);
  List<double> screenSize = new List<double>(2);
  bool isWhite;
  bool gameStarted = false;
  bool firstStart = true;
  final StopWatchTimer _whiteTimer = new StopWatchTimer();
  final StopWatchTimer _blackTimer = new StopWatchTimer();

  @override
  void initState() {
    super.initState();
    blackTeamShots = [0, 0];
    whiteTeamShots = [0, 0];
    isWhite = true;
    pauseGame();
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
    if (!gameStarted) {
      return mainScreen(0.2);
    } else {
      if (firstStart) {
        GameInfo gameInfo = ModalRoute.of(context).settings.arguments;
        _whiteTimer.setPresetMinuteTime(gameInfo.timer);
        _blackTimer.setPresetMinuteTime(gameInfo.timer);
        whiteTeam = gameInfo.whitePlayers;
        blackTeam = gameInfo.blackPlayers;
        gameInfo = null;

        _whiteTimer.onExecute.add(StopWatchExecute.start);
        setState(() {
          firstStart = false;
        });
      }
      return mainScreen(1.0);
    }
  }

  // ----------------------------- WIDGETY ---------------------------------- //

  Scaffold mainScreen(double opacity) {
    if (opacity < 1.0) {
      return Scaffold(
          backgroundColor: Colors.grey[300],
          body: SafeArea(
              child: Stack(
            children: [
              Column(
                children: [
                  Opacity(opacity: opacity, child: playerButton(false)),
                  Divider(
                    height: 10.0,
                    thickness: 3.0,
                  ),
                  pieceButtons(),
                  Divider(
                    height: 10.0,
                    thickness: 3.0,
                  ),
                  Opacity(opacity: opacity, child: playerButton(true)),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Gotowi do chlania?',
                      style: TextStyle(fontSize: 50.0),
                    ),
                    Center(
                      child: Container(
                        height: 50.0,
                        width: 100.0,
                        child: RaisedButton(
                            elevation: 4.0,
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                gameStarted = true;
                              });
                              return;
                            },
                            child: Text(
                              'OK!',
                              style: TextStyle(fontSize: 30.0),
                            )),
                      ),
                    )
                  ]),
            ],
          )));
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Column(
            children: [
              playerButton(false),
              Divider(
                height: 10.0,
                thickness: 3.0,
              ),
              pieceButtons(),
              Divider(
                height: 10.0,
                thickness: 3.0,
              ),
              playerButton(true),
            ],
          ),
        ),
      );
    }
  }

  Widget playerButton(bool whitePlayer) {
    return Container(
        width: screenSize[0],
        height: screenSize[1],
        child: RotatedBox(
          quarterTurns: whitePlayer ? 0 : 2,
          child: TextButton(
              onPressed: () => switchPlayer(),
              child: StreamBuilder<int>(
                stream: whitePlayer
                    ? _whiteTimer.rawTime.cast<int>()
                    : _blackTimer.rawTime.cast<int>(),
                initialData: whitePlayer
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
          pieceIcon('pawn.png', 1),
          pieceIcon('knight.png', 3),
          pieceIcon('bishop.png', 3),
          pieceIcon('rook.png', 5),
          pieceIcon('queen.png', 9),
          pieceIcon('king.png', 7, 30.0),
        ],
      ),
    );
  }

  Widget pieceIcon(String path, int shots, [double imageSize = 50.0]) {
    if (gameStarted) {
      return Opacity(
        opacity: 1.0,
        child: InkResponse(
            child: Image.asset(
              path,
              width: imageSize,
              height: imageSize,
            ),
            radius: imageSize / 3,
            enableFeedback: true,
            onTap: () async {
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
                  List<Player> selectedPlayers =
                      selectRandomPlayers(!isWhite, shots);
                  pauseGame();
                  await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        String drinkingPlayers = '';
                        selectedPlayers.forEach((element) {
                          drinkingPlayers += element.name +
                              ' pije: ' +
                              element.currentDrinks.toString();
                          element.currentDrinks = 0;
                          drinkingPlayers += '\n';
                        });
                        return Container(
                          width: 200.0,
                          height: 100.0,
                          child: AlertDialog(
                            title: !isWhite
                                ? Center(child: Text('Biali piją!'))
                                : Center(child: Text('Czarni piją!')),
                            content: !isWhite
                                ? Center(
                                    child: Text('Biali: ' +
                                        whiteTeamShots[1].toString() +
                                        ' kieliszków\n Teraz: \n' +
                                        drinkingPlayers),
                                  )
                                : Center(
                                    child: Text('Czarni: ' +
                                        whiteTeamShots[1].toString() +
                                        ' kieliszków\n Teraz: \n' +
                                        drinkingPlayers)),
                          ),
                        );
                      });
                  switchPlayer();
                  break;
                default:
                  break;
              }
            }),
      );
    } else {
      return Opacity(
          opacity: 0.5,
          child: InkResponse(
              child: Image.asset(
                path,
                width: imageSize,
                height: imageSize,
              ),
              radius: imageSize / 3,
              onTap: null));
    }
  }

  // ----------------------------- Funkcje ---------------------------------- //

  void pauseGame() {
    _whiteTimer.onExecute.add(StopWatchExecute.stop);
    _blackTimer.onExecute.add(StopWatchExecute.stop);
  }

  void switchPlayer() {
    if (isWhite) {
      _whiteTimer.onExecute.add(StopWatchExecute.stop);
      _blackTimer.onExecute.add(StopWatchExecute.start);
      setState(() {
        isWhite = false;
      });
    } else if (!isWhite) {
      _whiteTimer.onExecute.add(StopWatchExecute.start);
      _blackTimer.onExecute.add(StopWatchExecute.stop);
      setState(() {
        isWhite = true;
      });
    }
  }

  List<Player> selectRandomPlayers(bool isWhite, int shots) {
    final _random = new Random();
    List<Player> selectedPlayers = new List();

    whiteTeam.forEach((element) {
      element.currentDrinks = 0;
    });
    blackTeam.forEach((element) {
      element.currentDrinks = 0;
    });

    if (isWhite) {
      for (int i = 0; i < shots; i++) {
        Player selectedPlayer = whiteTeam[_random.nextInt(whiteTeam.length)];
        selectedPlayer.currentDrinks += 1;
        selectedPlayer.totalDrinks += 1;
        if (selectedPlayer.currentDrinks <= 1)
          selectedPlayers.add(selectedPlayer);
      }
    } else {
      for (int i = 0; i < shots; i++) {
        Player selectedPlayer = blackTeam[_random.nextInt(blackTeam.length)];
        selectedPlayer.currentDrinks += 1;
        selectedPlayer.totalDrinks += 1;
        if (selectedPlayer.currentDrinks <= 1)
          selectedPlayers.add(selectedPlayer);
      }
    }
    whiteTeam.forEach((element) {
      print(element.name + ', wypił: ' + element.totalDrinks.toString());
    });
    print('\n');
    blackTeam.forEach((element) {
      print(element.name + ', wypił: ' + element.totalDrinks.toString());
    });
    print('\n');
    print('\n');
    whiteTeam.forEach((element) {
      print(element.name + ', wypił: ' + element.totalDrinks.toString());
    });
    print('\n');
    blackTeam.forEach((element) {
      print(element.name + ', wypił: ' + element.totalDrinks.toString());
    });
    return selectedPlayers;
  }
}
