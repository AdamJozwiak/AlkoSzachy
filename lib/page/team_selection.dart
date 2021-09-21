// ignore_for_file: unused_impor, deprecated_member_use, unused_import

import 'dart:io';
import 'package:alkochin/models/player.dart';
import 'package:alkochin/widgets/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TeamSelection extends StatefulWidget {
  const TeamSelection({Key key}) : super(key: key);
  final fontSize = 55.0;
  @override
  _TeamSelectionState createState() => _TeamSelectionState();
}

class _TeamSelectionState extends State<TeamSelection> {
  List<Player> players;
  List<Player> whitePlayers;
  List<Player> blackPlayers;
  String _playerName = '';
  final _formKey = GlobalKey<FormState>();
  final _playerNameSize = 30.0;
  FileManager saveFile;
  bool saveFileInitialized = false;

  @override
  void initState() {
    this.players = List<Player>();
    this.whitePlayers = List<Player>();
    this.blackPlayers = List<Player>();
    this.saveFile = new FileManager();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await saveFile.init();
      if (saveFile.saveContent.isNotEmpty) {
        players = saveFile.saveContent;
        players.forEach((player) {
          if (player.isWhite) {
            whitePlayers.add(player);
          } else {
            blackPlayers.add(player);
          }
        });
        setState(() {});
      } else
        print('Brak zawartości');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Wybierz drużyny',
          style: TextStyle(fontSize: 35.0, letterSpacing: 2.0),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: ListView(shrinkWrap: true, children: [
        Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 480.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    child: Column(
                      children: [
                        Text(
                          'Białe',
                          style: TextStyle(
                              fontSize: widget.fontSize, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Divider(
                          color: Colors.black45,
                          height: 20.0,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: whitePlayers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Center(
                                    child: Text(
                                  '${whitePlayers[index].name}',
                                  style: TextStyle(fontSize: _playerNameSize),
                                )),
                              );
                            }),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 120.0,
                    color: Colors.black45,
                    thickness: 3.0,
                  ),
                  Container(
                    width: 120.0,
                    child: Column(
                      children: [
                        Text(
                          'Czarne',
                          style: TextStyle(fontSize: widget.fontSize),
                          textAlign: TextAlign.center,
                        ),
                        Divider(
                          color: Colors.black45,
                          height: 20.0,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: blackPlayers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Center(
                                    child: Text('${blackPlayers[index].name}',
                                        style: TextStyle(
                                            fontSize: _playerNameSize))),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 180.0),
          child: InkResponse(
            child: Container(
              width: 20.0,
              height: 50.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  boxShadow: [BoxShadow(spreadRadius: 1.0, blurRadius: 5)]),
              child: players.isEmpty
                  ? Icon(Icons.add)
                  : Icon(
                      Icons.theater_comedy,
                      size: 35,
                    ),
            ),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, stateSetter) {
                        return AlertDialog(
                          backgroundColor: Colors.white70,
                          content: teamSelectionDialog(players, stateSetter),
                        );
                      },
                    );
                  });
            },
          ),
        ),
      ]),
    );
  }

  Widget teamSelectionDialog(
      List<Player> initialPlayers, void Function(void Function()) stateSetter) {
    final TextEditingController _textController = new TextEditingController();
    double _baseDialogHeight = 200.0;
    int _numberOfPlayers = initialPlayers.length;
    double _boxSpacing = 40;
    double _noPlayersLabelSize = 70.0;
    double _maxHeight = 160.0;
    List<List<bool>> checkBoxState = new List();
    String _occupiedName = '';
    initialPlayers.forEach((player) {
      checkBoxState
          .add([player.isWhite, !player.isWhite]); // Checkbox: White, Black
    });

    return SingleChildScrollView(
      child: Container(
        height: _baseDialogHeight +
            (_numberOfPlayers > 1
                ? (_numberOfPlayers * 20.0)
                : _numberOfPlayers >= 4
                    ? _maxHeight
                    : 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: _numberOfPlayers > 0
                  ? (_numberOfPlayers >= 4
                      ? _maxHeight
                      : _numberOfPlayers * 44.0)
                  : _noPlayersLabelSize,
              width: 300.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  // ignore: missing_return
                  itemBuilder: (BuildContext context, int index) {
                    Player thisPlayer;
                    if (index < initialPlayers.length) {
                      thisPlayer = players[index];
                      return Container(
                        height: _numberOfPlayers + _boxSpacing,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 90.0,
                                child: RichText(
                                  strutStyle: StrutStyle(fontSize: 25.0),
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: thisPlayer.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'EnchantedLand',
                                          fontSize: 25.0)),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            InkResponse(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                    ),
                                    child: Opacity(
                                      opacity:
                                          checkBoxState[index][0] ? 1.0 : 0.0,
                                      child: Icon(
                                        Icons.check_circle_sharp,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (thisPlayer.isWhite) {
                                  stateSetter(() {
                                    checkBoxState[index] = [false, false];
                                  });
                                } else {
                                  changeTeam(thisPlayer, true);
                                  savePlayer(thisPlayer);
                                  stateSetter(() {
                                    checkBoxState[index] = [true, false];
                                  });
                                  setState(() {});
                                }
                              },
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            InkResponse(
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.black,
                                ),
                                child: Opacity(
                                  opacity: checkBoxState[index][1] ? 1.0 : 0.0,
                                  child: Icon(
                                    Icons.check_circle_sharp,
                                    size: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (!thisPlayer.isWhite) {
                                  stateSetter(() {
                                    checkBoxState[index] = [false, false];
                                  });
                                } else {
                                  changeTeam(thisPlayer, false);
                                  savePlayer(thisPlayer);
                                  stateSetter(() {
                                    checkBoxState[index] = [false, true];
                                  });
                                  setState(() {});
                                }
                              },
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Container(
                              width: 60.0,
                              child: FlatButton.icon(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  onPressed: () {
                                    if (thisPlayer.isWhite) {
                                      whitePlayers.remove(thisPlayer);
                                    } else {
                                      blackPlayers.remove(thisPlayer);
                                    }
                                    players.remove(thisPlayer);
                                    saveFile.deleteFromFile(thisPlayer);
                                    stateSetter(() {});
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red[700],
                                  ),
                                  label: Text('')),
                            )
                          ],
                        ),
                      );
                    } else if (index == 0) {
                      return Container(
                        height: _noPlayersLabelSize,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: Text(
                                'Brak graczy',
                                style: TextStyle(fontSize: 40.0),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (thisPlayer != null) {
                      players[index] = thisPlayer;
                    }
                  }),
            ),
            Container(
              width: 200.0,
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _textController,
                    style: TextStyle(fontSize: 30.0),
                    decoration:
                        InputDecoration(errorStyle: TextStyle(fontSize: 25.0)),
                    onChanged: (value) => _playerName = value,
                    validator: (value) {
                      if (value == _occupiedName) {
                        return 'Ta nazwa jest już zajęta!';
                      }
                      return (value == null || value.isEmpty)
                          ? 'Nazwa nie może być pusta'
                          : null;
                    },
                  )),
            ),
            SizedBox(height: 5.0),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.white60,
                    onPrimary: Colors.amber[900],
                    animationDuration: Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0))),
                onPressed: () {
                  players.forEach((element) {
                    if (element.name == _playerName) {
                      _occupiedName = element.name;
                    }
                  });
                  if (_formKey.currentState.validate()) {
                    String result = _playerName[0].toUpperCase();
                    for (int i = 1; i < _playerName.length; i++) {
                      result += _playerName[i];
                    }
                    Player newPlayer = new Player(result);
                    players.add(newPlayer);
                    if (players.isNotEmpty && players.last.isWhite) {
                      whitePlayers.add(players.last);
                    } else if (players.isNotEmpty && !players.last.isWhite) {
                      blackPlayers.add(players.last);
                    }
                    _textController.clear();
                    savePlayer(newPlayer);
                    stateSetter(() {});
                  }
                  setState(() {});
                },
                child: Text(
                  'Dodaj',
                  style: TextStyle(fontSize: 30.0, color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }

  void savePlayer(Player player) {
    bool playerNotFound = true;
    players.forEach((element) {
      if (element.name == player.name) {
        element = player;
        playerNotFound = false;
      }
    });
    if (playerNotFound) {
      players.add(player);
    }
    saveFile.writeToFile(players);
  }

  void changeTeam(Player player, bool white) {
    if (white && !player.isWhite) {
      this.blackPlayers.remove(player);
      player.isWhite = true;
      this.whitePlayers.add(player);
    } else if (!white && player.isWhite) {
      this.whitePlayers.remove(player);
      player.isWhite = false;
      this.blackPlayers.add(player);
    } else {
      return;
    }
    return;
  }
}
