import 'center_building_card.dart';
import 'major_building_card.dart';

class Player {
  int money = 3; // Default money
  List<CenterBuildingCard> centerBuildings = []; // Player's buildings
  List<MajorBuildingCard> majorBuildings = []; // Player's major buildings
  int id;
  bool currentPlayerTurn = false;

  Player({
    required this.id
  });
}