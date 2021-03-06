class Player {
  String name;
  int totalDrinks;
  int gameDrinks;
  int currentDrinks;
  bool isWhite;

  Player(this.name) {
    this.totalDrinks = 0;
    this.gameDrinks = 0;
    this.currentDrinks = 0;
    this.isWhite = true;
  }

  Player.mapped(this.name, this.totalDrinks, this.isWhite);

  Map toJson() =>
      {'name': name, 'totalDrinks': totalDrinks, 'isWhite': isWhite};
}
