import 'dart:io';
import 'dart:convert';
import 'package:alkochin/models/player.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  File saveFile;
  Directory directory;
  final fileName = 'savedPlayers.json';
  bool fileExists = false;
  List<Player> fileContent;

  FileManager() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      this.directory = directory;
      saveFile = new File(this.directory.path + "/" + fileName);
      fileExists = saveFile.existsSync();
      if (fileExists) {
        fileContent = jsonDecode(saveFile.readAsStringSync());
      }
    });
  }

  void writeToFile(List<Player> players) {
    // Map<String, String> content = {key: value};
    if (fileExists) {
      // Map<String, String> jsonFileContent =
      //     json.decode(saveFile.readAsStringSync());
      // jsonFileContent.addAll(content);
      // saveFile.writeAsStringSync(jsonEncode(jsonFileContent));
      List<Player> jsonFileContent = jsonDecode(saveFile.readAsStringSync());
      int playerIterator = 0;
      while (playerIterator < jsonFileContent.length) {
        Player savedPlayer = jsonFileContent[playerIterator];
        Player inGamePlayer = players[playerIterator];
        if (savedPlayer.name == inGamePlayer.name) {
          if (savedPlayer.totalDrinks < inGamePlayer.totalDrinks) {
            savedPlayer.totalDrinks = inGamePlayer.totalDrinks;
          }
          if (savedPlayer.isWhite != inGamePlayer.isWhite) {
            savedPlayer.isWhite = inGamePlayer.isWhite;
          }
        }
        playerIterator++;
      }
      jsonFileContent.addAll(players);
    } else {
      _createFile(players);
    }
    fileContent = jsonDecode(saveFile.readAsStringSync());
    print('Nowy content: ');
    fileContent.forEach((element) {
      print('Gracz: ' +
          element.name +
          ', kolor biały?:' +
          element.isWhite.toString());
    });
  }

  void _createFile(List<Player> players) {
    saveFile.createSync();
    fileExists = true;
    print('Zapisuję pierwszy raz: ' + jsonEncode(players));
    saveFile.writeAsStringSync(jsonEncode(players));
  }

  void _deleteFile() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      if (fileExists) {
        saveFile.deleteSync();
      }
    });
  }
}
