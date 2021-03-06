import 'package:alkoszachy/models/gameStartInfo.dart';
import 'package:alkoszachy/models/player.dart';
import 'package:alkoszachy/widgets/customText.dart';
import 'package:alkoszachy/widgets/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _textFieldValue = 0;
  int timer;
  final _formKey = GlobalKey<FormState>();
  List<bool> buttonError = new List(3);
  List<Player> players;
  List<Player> whitePlayers;
  List<Player> blackPlayers;
  List<double> screenSize = [0.0, 0.0];

  @override
  void initState() {
    super.initState();
    buttonError = [false, false, false];
    timer = 10;
    players = new List();
    whitePlayers = new List();
    blackPlayers = new List();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = [
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height
    ];
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: ListView(
                shrinkWrap: true,
                itemExtent: screenSize[1] / 1.02,
                children: [
                  Stack(children: [
                    Image.asset(
                      "assets/alchess_baner.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Spacer(
                                  flex: 2,
                                ),
                                Opacity(
                                  opacity: 0.9,
                                  child: CustomText(
                                    text: widget.title,
                                    fontSize: 45.0,
                                    fontFamily: GoogleFonts.cardo().fontFamily,
                                    weight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                    color: Colors.black,
                                    backgroundColor: Colors.white,
                                    bgWidth: screenSize[0] / 1.134,
                                    bgHeight: screenSize[1] / 5,
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                CustomText(
                                  text: 'Ustaw czas gry',
                                  fontSize: 30.0,
                                ),
                                SizedBox(
                                  height: screenSize[1] * 0.01,
                                ),
                                Container(
                                  width: 240.0,
                                  height: 50.0,
                                  child: Form(
                                    key: _formKey,
                                    child: Focus(
                                      child: TextFormField(
                                        initialValue: timer != 0.0
                                            ? timer.toString()
                                            : '',
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                -10.0, 10.0, 10.0, 10.0),
                                            hintText: timer.toString(),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            fillColor: Colors.white70,
                                            filled: true,
                                            prefixIcon: Icon(Icons.timer),
                                            suffix: CustomText(
                                              text: 'minut',
                                              fontSize: 15.0,
                                            ),
                                            errorStyle: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13.0)),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 25.0),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ustaw czas';
                                          } else if (double.tryParse(value) ==
                                              null) {
                                            return 'Tylko liczby!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => this
                                            ._textFieldValue = int.parse(value),
                                        onFieldSubmitted: (value) {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              timer = int.parse(value);
                                              buttonError[0] = false;
                                            });
                                          }
                                        },
                                      ),
                                      onFocusChange: (hasFocus) {
                                        if (!hasFocus) {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              timer = this._textFieldValue;
                                              buttonError[0] = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                RaisedButton.icon(
                                    color: Colors.white60,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side:
                                            BorderSide(color: Colors.black12)),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/teams');
                                    },
                                    icon: Icon(Icons.people),
                                    label: CustomText(
                                      text: 'Wybierz dru??yny',
                                      fontSize: 25.0,
                                    )),
                                Spacer(
                                  flex: 2,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    //Check if timer was set
                                    if (timer != null && timer >= 1) {
                                      setState(() {
                                        buttonError[0] = false;
                                      });
                                    } else {
                                      setState(() {
                                        buttonError[0] = true;
                                      });
                                      return;
                                    }

                                    //Read file
                                    FileManager fileManager = new FileManager();
                                    await fileManager.init();
                                    this.players = fileManager.readFile();
                                    this.whitePlayers.clear();
                                    this.blackPlayers.clear();
                                    if (this.players != null) {
                                      if (this.players.isNotEmpty) {
                                        this.players.forEach((player) {
                                          if (player.isWhite) {
                                            this.whitePlayers.add(player);
                                          } else {
                                            this.blackPlayers.add(player);
                                          }
                                        });
                                      }
                                      if (this.players.isEmpty) {
                                        setState(() {
                                          buttonError[1] = true;
                                        });
                                        return;
                                      } else if (this.players.length >= 2) {
                                        setState(() {
                                          buttonError[1] = false;
                                        });
                                        if (this.whitePlayers.length > 0 &&
                                            this.blackPlayers.length > 0) {
                                          setState(() {
                                            buttonError[2] = false;
                                          });
                                        } else {
                                          setState(() {
                                            buttonError[2] = true;
                                          });
                                          return;
                                        }
                                      } else {
                                        setState(() {
                                          buttonError[1] = false;
                                          buttonError[2] = true;
                                        });
                                        return;
                                      }
                                    } else {
                                      setState(() {
                                        buttonError[1] = true;
                                      });
                                    }

                                    //Check if every condition is met
                                    if (buttonError[0] == false &&
                                        buttonError[1] == false &&
                                        buttonError[2] == false) {
                                      Navigator.pushNamed(context, '/game',
                                          arguments: GameInfo(timer, players,
                                              whitePlayers, blackPlayers));
                                    }
                                  },
                                  child: CustomText(
                                      text: 'Graj!',
                                      fontSize: 40.0,
                                      weight: FontWeight.bold,
                                      color: Colors.black),
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.white60,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          side:
                                              BorderSide(color: Colors.black))),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Column(children: [
                                  if (buttonError[0])
                                    CustomText(
                                      text:
                                          'D??ugo???? gry musi by?? wi??ksza ni?? 30 sek!',
                                      fontSize: 20.0,
                                      color: Colors.red[400],
                                    )
                                  else if (buttonError[1])
                                    CustomText(
                                      text: 'Brak graczy.',
                                      fontSize: 20.0,
                                      color: Colors.red[400],
                                    )
                                  else if (buttonError[2])
                                    CustomText(
                                      text:
                                          'Musi by?? przynajmniej jeden gracz w ka??dej dru??ynie.',
                                      fontSize: 20.0,
                                      color: Colors.red[400],
                                    ),
                                ]),
                                Spacer(
                                  flex: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ]),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white60,
              child: Icon(Icons.info_outline),
              onPressed: () async {
                await _showInfo(context);
              }),
        ));
  }

  Future<void> _showInfo(BuildContext context) async {
    await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Scaffold(
                body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      CustomText(
                        text: 'Jak gra???',
                        fontSize: 40.0,
                        weight: FontWeight.w700,
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomText(
                          text: 'Alkoszachy to gra nastawiona na picie dru??ynowe, st??d im wi??cej os??b' +
                              ' tym lepiej i ??atwiej.\n\nGra oferuje dwa przyciski ze stoperem pokazuj??ce' +
                              ' czas pozosta??y do ko??ca gry. Aby zako??czy?? tur?? nale??y nacisn????' +
                              ' sw??j przycisk.\nW przypadku gdy zostanie zbita bierka, gracz zbijaj??cy' +
                              ' powinien nacisn???? odpowiadaj??cy jej przycisk',
                          fontSize: 18.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: pieceButtons(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomText(
                          text: 'a gra wylosuje osoby z dru??yny przeciwnej, kt??rych zadaniem b??dzie' +
                              ' wsp??lnie wypi?? liczb?? kieliszk??w odpowiadaj??c??' +
                              ' koszcie zbitej bierki.\n\nNa zako??czenie wy??wietlane jest podsumowanie' +
                              ', a gra ko??czy si?? w przypadku gdy kt??ry?? ze stoper??w osi??gnie warto???? 0' +
                              ', b??d?? gdy zostanie klikni??ty przycisk \'Kr??la\'',
                          fontSize: 18.0,
                        ),
                      ),
                      Spacer(
                        flex: 3,
                      )
                    ],
                  ),
                ),
              ],
            )),
          );
        });
  }

  Widget pieceButtons() {
    final barHeight = 70.0;
    return Container(
      height: barHeight,
      width: screenSize[0] - 15.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/pawn.png',
            width: 30.0,
            height: 30.0,
          ),
          Image.asset(
            'assets/knight.png',
            width: 30.0,
            height: 30.0,
          ),
          Image.asset(
            'assets/bishop.png',
            width: 30.0,
            height: 30.0,
          ),
          Image.asset(
            'assets/rook.png',
            width: 30.0,
            height: 30.0,
          ),
          Image.asset(
            'assets/queen.png',
            width: 30.0,
            height: 30.0,
          ),
          Image.asset(
            'assets/king.png',
            width: 30.0,
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
