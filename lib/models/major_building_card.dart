import 'building_card.dart';

class MajorBuildingCard {
  final String name;
  final int cost;
  final String effect;
  final TriggerTurn triggerTurn;
  final String backImagePath;
  final String frontImagePath;
  bool isActive;

  MajorBuildingCard({
    required this.name,
    required this.cost,
    required this.effect,
    required this.triggerTurn,
    required this.backImagePath,
    required this.frontImagePath,
    this.isActive = false,
  });
}