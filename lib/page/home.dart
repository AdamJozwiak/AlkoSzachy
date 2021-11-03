import 'package:alkochin/models/gameStartInfo.dart';
import 'package:alkochin/models/player.dart';
import 'package:alkochin/widgets/file_manager.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int timer;
  final _formKey = GlobalKey<FormState>();
  List<bool> buttonError = new List(3);
  List<Player> players;
  List<Player> whitePlayers;
  List<Player> blackPlayers;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 40.0,
              wordSpacing: 10.0,
              letterSpacing: 2.0,
              color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: ListView(children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Text(
                'Witamy w \nAlkoszachach!',
                style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                'Ustaw czas gry',
                style: TextStyle(fontSize: 35.0, wordSpacing: 4.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: 250.0,
                height: 80.0,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    initialValue: timer != 0.0 ? timer.toString() : '',
                    decoration: InputDecoration(
                        hintText: timer.toString(),
                        border: OutlineInputBorder(),
                        filled: true,
                        prefixIcon: Icon(Icons.timer),
                        suffix: Text(
                          'minut',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25.0),
                        ),
                        errorStyle:
                            TextStyle(fontFamily: 'Roboto', fontSize: 13.0)),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ustaw czas';
                      } else if (double.tryParse(value) == null) {
                        return 'Tylko liczby!';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          timer = int.parse(value);
                          buttonError[0] = false;
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/teams');
                  },
                  icon: Icon(Icons.people),
                  label: Text(
                    'Wybierz drużyny',
                    style: TextStyle(fontSize: 30.0, letterSpacing: 1.5),
                  )),
              SizedBox(
                height: 30.0,
              ),
              Divider(
                height: 5.0,
                thickness: 3.0,
                color: Colors.black38,
              ),
              SizedBox(
                height: 30.0,
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

                  //Check if every condition is met
                  if (buttonError[0] == false &&
                      buttonError[1] == false &&
                      buttonError[2] == false) {
                    Navigator.pushNamed(context, '/game',
                        arguments: GameInfo(timer, whitePlayers, blackPlayers));
                  }
                },
                child: Text('Graj!',
                    style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: BorderSide(color: Colors.black)))),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(children: [
                if (buttonError[0])
                  Text(
                    'Długość gry musi być większa niż 30 sek!',
                    style: TextStyle(fontSize: 25.0, color: Colors.red[400]),
                  )
                else if (buttonError[1])
                  Text(
                    'Brak graczy.',
                    style: TextStyle(fontSize: 25.0, color: Colors.red[400]),
                  )
                else if (buttonError[2])
                  Text(
                    'Musi być przynajmniej jeden gracz w każdej drużynie.',
                    style: TextStyle(fontSize: 25.0, color: Colors.red[400]),
                  ),
              ])
            ],
          ),
        ),
      ]),
    );
  }
}
