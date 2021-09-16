import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class FileManager {
  File saveFile;
  Directory directory;
  final fileName = 'savedPlayers.json';
  bool fileExists = false;
  Map<String, String> fileContent;

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

  void createFile(Map<String, String> content) {
    saveFile.createSync();
    fileExists = true;
    saveFile.writeAsStringSync(jsonEncode(content));
  }

  void writeToFile(String key, String value) {
    Map<String, String> content = {key: value};
    if (fileExists) {
      Map<String, String> jsonFileContent =
          json.decode(saveFile.readAsStringSync());
      jsonFileContent.addAll(content);
      saveFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      createFile(content);
    }
    fileContent = jsonDecode(saveFile.readAsStringSync());
  }
}
