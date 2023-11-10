enum TriggerTurn {
  MyTurn,
  OpponentTurn,
  EveryTurn
}

class BuildingCard {
  String name;
  String type;
  int cost;
  List<int> triggerValue;
  TriggerTurn triggerTurn;
  String effect;
  int effectValue;
  int availableCount;
  String imagePath;

  BuildingCard({
    required this.name,
    required this.type,
    required this.cost,
    required this.triggerValue,
    required this.triggerTurn,
    required this.effect,
    required this.effectValue,
    required this.availableCount,
    required this.imagePath
  });
}