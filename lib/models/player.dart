class Player {
  String name;
  int totalDrinks;
  bool isWhite;

  Player(this.name) {
    this.totalDrinks = 0;
    this.isWhite = true;
  }

  Player.mapped(this.name, this.totalDrinks, this.isWhite);

  Map toJson() =>
      {'name': name, 'totalDrinks': totalDrinks, 'isWhite': isWhite};
}
