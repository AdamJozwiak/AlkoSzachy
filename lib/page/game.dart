import 'dart:math';
import 'package:alkoszachy/models/gameStartInfo.dart';
import 'package:alkoszachy/models/player.dart';
import 'package:alkoszachy/widgets/customText.dart';
import 'package:alkoszachy/widgets/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:alkoszachy/widgets/stop_watch_timer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Game extends StatefulWidget {
  const Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Player> players = new List<Player>();
  List<Player> blackTeam = new List<Player>();
  List<Player> whiteTeam = new List<Player>();
  List<int> blackTeamShots = new List<int>(2);
  List<int> whiteTeamShots = new List<int>(2);
  List<double> screenSize = new List<double>(2);
  List<bool> whoWon;
  bool isWhite;
  bool gameStarted = false;
  bool firstStart = true;
  bool gameEnded = false;
  bool countOn = false;
  bool kingPressed = false;
  int timerValue = 0;
  int initialTime = 0;
  final StopWatchTimer _whiteTimer = new StopWatchTimer();
  final StopWatchTimer _blackTimer = new StopWatchTimer();
  FileManager fileManager = new FileManager();

  @override
  void initState() {
    super.initState();
    blackTeamShots = [0, 0];
    whiteTeamShots = [0, 0];
    whoWon = [false, false];
    isWhite = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fileManager.init();
    });
    pauseGame();
  }

  @override
  void dispose() async {
    fileManager = null;
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
        initialTime = gameInfo.timer;
        players = gameInfo.players;
        whiteTeam = gameInfo.whitePlayers;
        blackTeam = gameInfo.blackPlayers;
        players.forEach((element) {
          element.gameDrinks = 0;
          element.currentDrinks = 0;
        });
        gameInfo = null;
        _whiteTimer.onExecute.add(StopWatchExecute.start);
        Future.delayed(Duration(seconds: initialTime), () async {
          //minutes: gameInfo.timer), () {
          checkTime();
        });
        setState(() {
          firstStart = false;
        });
      }
      return mainScreen(1.0);
    }
  }

  Future checkTime() async {
    if (kingPressed) {
      return null;
    } else if (gameEnded) {
      return await endGame();
    } else {
      return Future.delayed(Duration(microseconds: timerValue), () async {
        //minutes: gameInfo.timer), () {
        return checkTime();
      });
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
                    CustomText(
                      text: 'Gotowi do chlania?',
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
                            child: CustomText(
                              text: 'OK!',
                              fontSize: 30.0,
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
              onPressed: () => switchPlayer(!whitePlayer),
              child: StreamBuilder<int>(
                stream: whitePlayer
                    ? _whiteTimer.rawTime.cast<int>()
                    : _blackTimer.rawTime.cast<int>(),
                initialData: whitePlayer
                    ? _whiteTimer.rawTime.value
                    : _blackTimer.rawTime.value,
                builder: (context, snapshot) {
                  final value = snapshot.data;
                  if (value > 0.0) {
                    this.countOn = true;
                  }
                  if (countOn && value == 0.0) {
                    this.gameEnded = true;
                  }
                  final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: false);
                  return CustomText(
                    text: displayTime,
                    fontSize: 60.0,
                    color: Colors.black,
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
          pieceIcon('assets/pawn.png', 1),
          pieceIcon('assets/knight.png', 3),
          pieceIcon('assets/bishop.png', 3),
          pieceIcon('assets/rook.png', 5),
          pieceIcon('assets/queen.png', 9),
          pieceIcon('assets/king.png', 7, 30.0),
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
                  if (!isWhite) {
                    whiteTeamShots[0] = whiteTeamShots[1];
                    whiteTeamShots[1] += shots;
                  } else {
                    blackTeamShots[0] = blackTeamShots[1];
                    blackTeamShots[1] += shots;
                  }
                  List<Player> selectedPlayers =
                      selectRandomPlayers(!isWhite, shots);
                  pauseGame();
                  String drinkingPlayers = '';
                  selectedPlayers.forEach((element) {
                    drinkingPlayers += element.name +
                        ' pije: ' +
                        element.currentDrinks.toString();
                    element.currentDrinks = 0;
                    drinkingPlayers += '\n';
                  });
                  await Alert(
                    context: context,
                    image: Image.asset(
                      'assets/alert.png',
                      width: 180.0,
                    ),
                    title: (!isWhite ? 'Biali piją: ' : 'Czarni piją: ') +
                        shots.toString() +
                        '\n',
                    desc: drinkingPlayers,
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Wypite!",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                  fileManager.writeToFile(selectedPlayers);
                  if (shots == 7) {
                    kingPressed = true;
                    return await endGame(true);
                  }
                  //Switches to opposite player
                  switchPlayer(!isWhite);
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

  Widget overlayScreen(String title, String content) {
    return SafeArea(
      child: Opacity(
        opacity: 0.8,
        child: Scaffold(
          body: Stack(children: [
            Container(
                width: screenSize[0],
                height: screenSize[1] * 4,
                padding: EdgeInsets.all(20),
                color: Colors.white),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    CustomText(
                      text: title,
                      fontSize: 40.0,
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    CustomText(
                      text: content,
                      fontSize: 30.0,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    CustomText(
                      text: 'Tabela wyników',
                      fontSize: 40.0,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Container(
                        width: screenSize[0] / 1.2,
                        height: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              Player thisPlayer;
                              if (index < players.length) {
                                thisPlayer = players[index];
                                return Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        color: Colors.white60),
                                    height: players.length + 30.0,
                                    width: screenSize[0],
                                    child: Center(
                                      child: Container(
                                        child: RichText(
                                          strutStyle:
                                              StrutStyle(fontSize: 25.0),
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                              text: thisPlayer.name +
                                                  ' - ' +
                                                  thisPlayer.gameDrinks
                                                      .toString(),
                                              style: TextStyle(
                                                  wordSpacing: 8.0,
                                                  color: Colors.black,
                                                  fontSize: 25.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            })),
                    Spacer(
                      flex: 3,
                    ),
                    Container(
                      width: 140,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.black12)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: CustomText(
                          text: 'Wyjdź',
                          fontSize: 30.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 4,
                    ),
                  ],
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  // ----------------------------- Funkcje ---------------------------------- //

  void pauseGame() {
    _whiteTimer.onExecute.add(StopWatchExecute.stop);
    _blackTimer.onExecute.add(StopWatchExecute.stop);
  }

  Future<void> endGame([bool puttonPressed = false]) async {
    pauseGame();
    if (puttonPressed) {
      if (isWhite) {
        whoWon = [true, true];
      } else {
        whoWon = [true, false];
      }
    } else if (_whiteTimer.rawTime.value > _blackTimer.rawTime.value) {
      whoWon = [true, true];
    } else if (_whiteTimer.rawTime.value < _blackTimer.rawTime.value) {
      whoWon = [true, false];
    }
    await _showOverlay(context);
    Navigator.pop(context);
  }

  void switchPlayer(bool toWhite) {
    if (isWhite && !toWhite) {
      _whiteTimer.onExecute.add(StopWatchExecute.stop);
      _blackTimer.onExecute.add(StopWatchExecute.start);
      setState(() {
        isWhite = false;
      });
    } else if (!isWhite && toWhite) {
      _whiteTimer.onExecute.add(StopWatchExecute.start);
      _blackTimer.onExecute.add(StopWatchExecute.stop);
      setState(() {
        isWhite = true;
      });
    }
  }

  Future<void> _showOverlay(BuildContext context) async {
    await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          Player mostDrunk = new Player('Najbardziej uchlany');
          players.forEach((element) {
            if (element.gameDrinks > mostDrunk.gameDrinks) {
              mostDrunk = element;
            }
          });
          if (whoWon[0] && whoWon[1]) {
            return overlayScreen(
                'Biali wygrali wypijając: ' + whiteTeamShots[1].toString(),
                'Najwięcej wypił/a:\n' +
                    mostDrunk.name +
                    ' - ' +
                    mostDrunk.gameDrinks.toString());
          } else if (whoWon[0] && !whoWon[1]) {
            return overlayScreen(
                'Czarni wygrali wypijając: ' + blackTeamShots[1].toString(),
                'Najwięcej wypił/a:\n' +
                    mostDrunk.name +
                    ' - ' +
                    mostDrunk.gameDrinks.toString());
          }
        });
  }

  List<Player> selectRandomPlayers(bool isWhite, int shots) {
    List<Player> selectedPlayers = new List();
    Random _random;

    whiteTeam.forEach((element) {
      element.currentDrinks = 0;
    });
    blackTeam.forEach((element) {
      element.currentDrinks = 0;
    });

    if (isWhite) {
      for (int i = 0; i < shots; i++) {
        _random = new Random();
        Player selectedPlayer = whiteTeam[_random.nextInt(whiteTeam.length)];
        selectedPlayer.currentDrinks += 1;
        selectedPlayer.gameDrinks += 1;
        selectedPlayer.totalDrinks += 1;
        if (selectedPlayer.currentDrinks <= 1)
          selectedPlayers.add(selectedPlayer);
      }
    } else {
      for (int i = 0; i < shots; i++) {
        _random = new Random();
        Player selectedPlayer = blackTeam[_random.nextInt(blackTeam.length)];
        selectedPlayer.currentDrinks += 1;
        selectedPlayer.gameDrinks += 1;
        selectedPlayer.totalDrinks += 1;
        if (selectedPlayer.currentDrinks <= 1)
          selectedPlayers.add(selectedPlayer);
      }
    }
    return selectedPlayers;
  }

  RaisedButton exitButton(BuildContext context) {
    return RaisedButton(
      color: Colors.white70,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black12)),
      onPressed: () {
        Navigator.pop(context);
      },
      child: CustomText(
        text: 'Wyjdź',
        fontSize: 25.0,
      ),
    );
  }
}
