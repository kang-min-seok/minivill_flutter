class MajorBuildingCard {
  final String name;
  final int cost;
  final String backImagePath;
  final String frontImagePath;
  bool isActive;

  MajorBuildingCard({
    required this.name,
    required this.cost,
    required this.backImagePath,
    required this.frontImagePath,
    this.isActive = false,
  });
}