import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double timer;
  final _formKey = GlobalKey<FormState>();
  bool buttonError;

  @override
  void initState() {
    super.initState();
    buttonError = false;
    timer = 0.0;
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
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        prefixIcon: Icon(Icons.timer),
                        suffix: Text(
                          'minut',
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
                          timer = double.parse(value);
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
                onPressed: () {
                  if (timer != null && timer > 0.5) {
                    setState(() {
                      buttonError = false;
                    });
                    Navigator.pushNamed(context, '/game', arguments: timer);
                  } else {
                    setState(() {
                      buttonError = true;
                    });
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
              Visibility(
                visible: buttonError,
                child: Text(
                  'Długość gry musi być większa niż 30 sek!',
                  style: TextStyle(fontSize: 25.0, color: Colors.red[400]),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
