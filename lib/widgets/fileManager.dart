import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:alkochin/models/player.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  File _saveFile;
  Directory _directory;
  final _fileName = 'savedPlayers.json';
  bool _fileExists;
  List<Player> _fileContent;

  FileManager() {
    this._fileContent = new List<Player>();
    _fileExists = false;
  }

  void init() async {
    this._directory = await getApplicationDocumentsDirectory();
    this._saveFile = new File(this._directory.path + "/" + this._fileName);
    this._fileExists = this._saveFile.existsSync();
    print('Czy plik istnieje?: ' + this._fileName);
    if (_fileExists) {
      this._fileContent = readFile();
    }
  }

  void writeToFile(List<Player> players) {
    if (_fileExists) {
      List<Player> jsonFileContent = readFile();
      int playerIterator = 0;
      int biggerListLength = max(players.length, jsonFileContent.length);
      while (playerIterator < biggerListLength) {
        bool playerNotFound = true;
        if (jsonFileContent.isNotEmpty &&
            playerIterator < jsonFileContent.length) {
          players.forEach((element) {
            if (element.name == jsonFileContent[playerIterator].name) {
              if (jsonFileContent[playerIterator].totalDrinks <
                  element.totalDrinks) {
                jsonFileContent[playerIterator].totalDrinks =
                    element.totalDrinks;
              }
              if (jsonFileContent[playerIterator].isWhite != element.isWhite) {
                jsonFileContent[playerIterator].isWhite = element.isWhite;
              }
              playerNotFound = false;
            }
          });
        }
        if (playerNotFound) {
          jsonFileContent.add(players[playerIterator]);
          print('Dodano gracza: ' + players[playerIterator].name);
          jsonFileContent.forEach((player) {
            print(player.name);
          });
        }
        playerIterator++;
      }
      _saveFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      _createFile(players);
    }
    this._fileContent = readFile();
    print('Nowy content: ');
    _fileContent.forEach((element) {
      print('Gracz: ' +
          element.name +
          ', kolor biały?:' +
          element.isWhite.toString());
    });
  }

  void _createFile(List<Player> players) {
    _saveFile.createSync();
    _fileExists = true;
    print('Zapisuję pierwszy raz: ' + jsonEncode(players));
    _saveFile.writeAsStringSync(jsonEncode(players));
  }

  void deleteFromFile(Player player) {
    _fileContent.forEach((element) {
      if (element.name == player.name) {
        _fileContent.remove(element);
      }
    });
    _saveFile.writeAsStringSync(jsonEncode(_fileContent));
  }

  List<Player> readFile() {
    List<Player> loadedList = new List();
    List<dynamic> decoded = jsonDecode(this._saveFile.readAsStringSync());
    decoded.forEach((element) {
      loadedList.add(new Player.mapped(
          element['name'], element['totalDrinks'], element['isWhite']));
    });
    return loadedList;
  }

  // void _deleteFile() {
  //   getApplicationDocumentsDirectory().then((Directory directory) {
  //     if (_fileExists) {
  //       _saveFile.deleteSync();
  //     }
  //   });
  // }

  List<Player> get saveContent {
    return _fileContent;
  }
}
