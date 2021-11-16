import 'dart:io';
import 'dart:convert';
import 'package:alkoszachy/models/player.dart';
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

  Future<void> init() async {
    this._directory = await getApplicationDocumentsDirectory();
    this._saveFile = File(this._directory.path + "/" + this._fileName);
    checkFile();
    if (_fileExists) {
      this._fileContent = readFile();
    }
  }

  void checkFile() {
    this._fileExists = this._saveFile.existsSync();
  }

  void writeToFile(List<Player> players, [bool force = false]) {
    if (_fileExists) {
      List<Player> jsonFileContent = readFile();
      if (players.length > jsonFileContent.length) {
        //If adding new player
        int playerIterator = 0;
        Map<Player, int> foundPlayersIterators = new Map<Player, int>();
        while (playerIterator < players.length) {
          for (int i = 0; i < jsonFileContent.length; i++) {
            if (jsonFileContent[i].name == players[playerIterator].name) {
              if (players[playerIterator].totalDrinks >
                  jsonFileContent[i].totalDrinks) {
                jsonFileContent[i].totalDrinks =
                    players[playerIterator].totalDrinks;
              }
              if (players[playerIterator].isWhite !=
                  jsonFileContent[i].isWhite) {
                jsonFileContent[i].isWhite = players[playerIterator].isWhite;
              }
              foundPlayersIterators.addAll(
                  <Player, int>{players[playerIterator]: playerIterator});
            }
          }
          playerIterator++;
        }
        for (int i = 0; i < players.length; i++) {
          bool playerFound = false;
          foundPlayersIterators.forEach((key, value) {
            if (i == value) {
              playerFound = true;
            }
          });
          if (!playerFound) {
            jsonFileContent.add(players[i]);
          }
        }
      } else {
        //If modifying existing player
        int savedPlayerIterator = 0;
        while (savedPlayerIterator < jsonFileContent.length) {
          for (int i = 0; i < players.length; i++) {
            if (players[i].name == jsonFileContent[savedPlayerIterator].name) {
              if (force) {
                jsonFileContent[savedPlayerIterator] = players[i];
              } else {
                if (jsonFileContent[savedPlayerIterator].totalDrinks <
                    players[i].totalDrinks) {
                  jsonFileContent[savedPlayerIterator].totalDrinks =
                      players[i].totalDrinks;
                }
                if (jsonFileContent[savedPlayerIterator].isWhite !=
                    players[i].isWhite) {
                  jsonFileContent[savedPlayerIterator].isWhite =
                      players[i].isWhite;
                }
              }
            }
          }
          savedPlayerIterator++;
        }
      }
      _saveFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      _createFile(players);
    }
    this._fileContent = readFile();
  }

  void _createFile(List<Player> players) {
    _saveFile.createSync();
    _fileExists = true;
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
    if (_fileExists) {
      List<Player> loadedList = new List();
      List<dynamic> decoded = jsonDecode(this._saveFile.readAsStringSync());
      decoded.forEach((element) {
        loadedList.add(new Player.mapped(
            element['name'], element['totalDrinks'], element['isWhite']));
      });
      return loadedList;
    }
    return null;
  }

  List<Player> get saveContent {
    return _fileContent;
  }

  void deleteUserScores() {
    List<Player> players = readFile();
    players.forEach((element) {
      element.totalDrinks = 0;
    });
    writeToFile(players, true);
  }

  void deleteFile() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      checkFile();
      if (_fileExists) {
        _saveFile.deleteSync();
      }
    });
  }
}
