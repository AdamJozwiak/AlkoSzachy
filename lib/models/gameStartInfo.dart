import 'package:alkochin/models/player.dart';

class GameInfo {
  final int timer;
  final List<Player> whitePlayers;
  final List<Player> blackPlayers;

  GameInfo(this.timer, this.whitePlayers, this.blackPlayers);
}
