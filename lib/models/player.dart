class Player {
  String name;
  int totalDrinks;
  bool isWhite;

  Player(String name) {
    this.name = name;
    this.totalDrinks = 0;
    this.isWhite = true;
  }

  Map toJson() =>
      {'name': name, 'totalDrinks': totalDrinks, 'isWhite': isWhite};
}
