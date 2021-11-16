import 'package:alkoszachy/models/player.dart';

class GameInfo {
  final int timer;
  final List<Player> players;
  final List<Player> whitePlayers;
  final List<Player> blackPlayers;

  GameInfo(this.timer, this.players, this.whitePlayers, this.blackPlayers);
}
