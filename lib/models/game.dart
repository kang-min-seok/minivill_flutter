import 'player.dart';
import 'building_card.dart';
import 'major_building_card.dart';
import 'package:vibration/vibration.dart';

class MiniVillGame {
  final int numOfPlayers;
  List<Player> players = [];
  List<BuildingCard> centerCards = [];
  List<MajorBuildingCard> majorCards = [];
  int currentPlayerIndex = 0;
  int opponentPlayerIndex = 0;
  int everyPlayerIndex = 0;

  bool rollDiceStatus = false;
  bool extraTurn = false;
  bool extraDice = true;

  MiniVillGame(this.numOfPlayers) {
    // Initialize players with default money and buildings
    for (int i = 0; i < numOfPlayers; i++) {
      players.add(Player(id: i));
    }

    // Initialize center cards
    centerCards = [
      BuildingCard(
          name: '밀밭',
          type: '작물',
          cost: 1,
          triggerValue: [1],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_0.jpg'),
      BuildingCard(
          name: '목장',
          type: '가축',
          cost: 1,
          triggerValue: [2],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_1.jpg'),
      BuildingCard(
          name: '빵집',
          type: '서비스',
          cost: 1,
          triggerValue: [2, 3],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_2.jpg'),
      BuildingCard(
          name: '카페',
          type: '커피',
          cost: 2,
          triggerValue: [3],
          triggerTurn: TriggerTurn.OpponentTurn,
          effect: 'steal',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_3.jpg'),
      BuildingCard(
          name: '편의점',
          type: '서비스',
          cost: 2,
          triggerValue: [4],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_4.jpg'),
      BuildingCard(
          name: '숲',
          type: '자원',
          cost: 3,
          triggerValue: [5],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_5.jpg'),
      BuildingCard(
          name: '전시장',
          type: '특수',
          cost: 8,
          triggerValue: [6],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'special-building',
          effectValue: 1,
          availableCount: 4,
          imagePath: 'assets/center_card/center_card_6.jpg'),
      BuildingCard(
          name: 'TV 방송국',
          type: '특수',
          cost: 7,
          triggerValue: [6],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'special-steal',
          effectValue: 5,
          availableCount: 4,
          imagePath: 'assets/center_card/center_card_7.jpg'),
      BuildingCard(
          name: '경기장',
          type: '특수',
          cost: 6,
          triggerValue: [6],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'all-steal',
          effectValue: 2,
          availableCount: 4,
          imagePath: 'assets/center_card/center_card_8.jpg'),
      BuildingCard(
          name: '치즈 공장',
          type: '공장',
          cost: 5,
          triggerValue: [7],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus-building-cheese',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_9.jpg'),
      BuildingCard(
          name: '가구 공장',
          type: '공장',
          cost: 3,
          triggerValue: [8],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus-building-gagoo',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_10.jpg'),
      BuildingCard(
          name: '광산',
          type: '자원',
          cost: 6,
          triggerValue: [9],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 5,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_11.jpg'),
      BuildingCard(
          name: '패밀리 레스토랑',
          type: '커피',
          cost: 3,
          triggerValue: [9, 10],
          triggerTurn: TriggerTurn.OpponentTurn,
          effect: 'steal',
          effectValue: 2,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_12.jpg'),
      BuildingCard(
          name: '사과밭',
          type: '작물',
          cost: 3,
          triggerValue: [10],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_13.jpg'),
      BuildingCard(
          name: '농산물 시장',
          type: '시장',
          cost: 2,
          triggerValue: [11, 12],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus-building-farm',
          effectValue: 2,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_14.jpg')
    ];

    majorCards = [
      MajorBuildingCard(
          name: '기차역',
          cost: 4,
          effect: '내 차례에 주사위를 2개 굴릴수 있다.',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_0.jpg',
          frontImagePath: 'assets/major_card/major_card_front_0.jpg'),
      MajorBuildingCard(
          name: '쇼핑몰',
          cost: 10,
          effect: '카페 or 서비스의 경우, 카드당 1원씩 추가 획득',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_1.jpg',
          frontImagePath: 'assets/major_card/major_card_front_1.jpg'),
      MajorBuildingCard(
          name: '놀이공원',
          cost: 16,
          effect: '굴린 주사위 눈금이 같은 경우, 1턴 추가 진행',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_2.jpg',
          frontImagePath: 'assets/major_card/major_card_front_2.jpg'),
      MajorBuildingCard(
          name: '라디오 방송국',
          cost: 22,
          effect: '주사위를 1회 다시 굴릴 수 있음',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_3.jpg',
          frontImagePath: 'assets/major_card/major_card_front_3.jpg')
    ];


    for (int i = 0; i < numOfPlayers; i++) {
      players[i].buildings.add(centerCards[0]);
      players[i].buildings.add(centerCards[2]);

      players[i].majorBuildings.add(MajorBuildingCard(
          name: '기차역',
          cost: 4,
          effect: '내 차례에 주사위를 2개 굴릴수 있다.',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_0.jpg',
          frontImagePath: 'assets/major_card/major_card_front_0.jpg'));
      players[i].majorBuildings.add(MajorBuildingCard(
          name: '쇼핑몰',
          cost: 10,
          effect: '카페 or 서비스의 경우, 카드당 1원씩 추가 획득',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_1.jpg',
          frontImagePath: 'assets/major_card/major_card_front_1.jpg'));
      players[i].majorBuildings.add(MajorBuildingCard(
          name: '놀이공원',
          cost: 16,
          effect: '굴린 주사위 눈금이 같은 경우, 1턴 추가 진행',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_2.jpg',
          frontImagePath: 'assets/major_card/major_card_front_2.jpg'));
      players[i].majorBuildings.add(MajorBuildingCard(
          name: '라디오 방송국',
          cost: 22,
          effect: '주사위를 1회 다시 굴릴 수 있음',
          triggerTurn: TriggerTurn.MyTurn,
          backImagePath: 'assets/major_card/major_card_back_3.jpg',
          frontImagePath: 'assets/major_card/major_card_front_3.jpg'));
    }

    players[currentPlayerIndex].currentPlayerTurn = true;
  }

  void rollDice(int diceValue) {
    opponentPlayerIndex = currentPlayerIndex;
    // 상대의 턴 먼저 모두 실행
    for (int i = 0; i < numOfPlayers - 1; i++) {
      opponentPlayerIndex = (opponentPlayerIndex + 1) % numOfPlayers;
      for (int j = 0; j < players[opponentPlayerIndex].buildings.length; j++) {
        if (players[opponentPlayerIndex].buildings[j].triggerValue
                .contains(diceValue) && players[opponentPlayerIndex]
            .buildings[j].triggerTurn == TriggerTurn.OpponentTurn) {
          if(players[opponentPlayerIndex].majorBuildings[1].isActive){
            players[opponentPlayerIndex].money += 1;
          }
          if(players[currentPlayerIndex].money>=players[opponentPlayerIndex].buildings[j].effectValue){
            players[currentPlayerIndex].money -= players[opponentPlayerIndex].buildings[j].effectValue;
            players[opponentPlayerIndex].money += players[opponentPlayerIndex].buildings[j].effectValue;
          }else{
            print("뺏어올 돈이 없습니다.");
          }
          print(
              "플레이어${opponentPlayerIndex + 1}의 ${players[opponentPlayerIndex].buildings[j].name} 효과 발동");
        }
      }
    }
    print("----------------------------");
    // 모두의 턴 실행
    for (int i = 0; i < numOfPlayers; i++) {
      for (int j = 0; j < players[i].buildings.length; j++) {
        if (players[i].buildings[j].triggerValue.contains(diceValue) &&
            players[i].buildings[j].triggerTurn == TriggerTurn.EveryTurn) {
          players[i].money += players[i].buildings[j].effectValue;
          print("플레이어${i + 1}의 ${players[i].buildings[j].name} 효과 발동");
        }
      }
    }
    // 나의 턴 실행
    print("----------------------------");
    for (int i = 0; i < players[currentPlayerIndex].buildings.length; i++) {
      if (players[currentPlayerIndex]
              .buildings[i]
              .triggerValue
              .contains(diceValue) &&
          players[currentPlayerIndex].buildings[i].triggerTurn ==
              TriggerTurn.MyTurn) {
        if(players[currentPlayerIndex].buildings[i].effect =="plus"){
          players[currentPlayerIndex].money += players[currentPlayerIndex].buildings[i].effectValue;
          if(players[currentPlayerIndex].majorBuildings[1].isActive){
            players[currentPlayerIndex].money += 1;
          }
        }
        else if(players[currentPlayerIndex].buildings[i].effect=="special-building"){
          int maxCostIndex = 0;
          int maxCost = players[(currentPlayerIndex + 1) % numOfPlayers].buildings[0].cost;
          for (int i = 1; i < players[(currentPlayerIndex + 1) % numOfPlayers].buildings.length; i++) {
            if (players[(currentPlayerIndex + 1) % numOfPlayers].buildings[i].cost > maxCost) {
              maxCost = players[0].buildings[i].cost;
              maxCostIndex = i;
            }
          }
          players[currentPlayerIndex].buildings.add(players[(currentPlayerIndex + 1) % numOfPlayers].buildings[maxCostIndex]);
          players[(currentPlayerIndex + 1) % numOfPlayers].buildings.removeAt(maxCostIndex);
        }
        else if(players[currentPlayerIndex].buildings[i].effect=="special-steal"){
          if(players[(currentPlayerIndex + 1) % numOfPlayers].money >= players[currentPlayerIndex].buildings[i].effectValue){
            players[(currentPlayerIndex + 1) % numOfPlayers].money -= players[currentPlayerIndex].buildings[i].effectValue;
            players[currentPlayerIndex].money += players[currentPlayerIndex].buildings[i].effectValue;
          }
        }
        else if(players[currentPlayerIndex].buildings[i].effect=="all-steal"){
          int stealPlayerIndex = (currentPlayerIndex + 1) % numOfPlayers;
          for(int i=0; i<numOfPlayers-1;i++){
            if(players[stealPlayerIndex].money >= players[currentPlayerIndex].buildings[i].effectValue){
              players[stealPlayerIndex].money -= players[currentPlayerIndex].buildings[i].effectValue;
              players[currentPlayerIndex].money += players[currentPlayerIndex].buildings[i].effectValue;
              stealPlayerIndex = (stealPlayerIndex+1) % numOfPlayers;
            }
          }
        }
        else if(players[currentPlayerIndex].buildings[i].effect.contains("plus-building")){
          if(players[currentPlayerIndex].buildings[i].effect.contains("cheese")){
            int cheeseCount = 0;
            for(int i=0;i<players[currentPlayerIndex].buildings.length;i++){
              if(players[currentPlayerIndex].buildings[i].type == "가축"){
                cheeseCount +=1;
              }
            }
            players[currentPlayerIndex].money += cheeseCount*players[currentPlayerIndex].buildings[i].effectValue;
          }
          else if(players[currentPlayerIndex].buildings[i].effect.contains("gagoo")){
            int gagooCount = 0;
            for(int i=0;i<players[currentPlayerIndex].buildings.length;i++){
              if(players[currentPlayerIndex].buildings[i].type == "자원"){
                gagooCount +=1;
              }
            }
            players[currentPlayerIndex].money += gagooCount*players[currentPlayerIndex].buildings[i].effectValue;
          }
          else if(players[currentPlayerIndex].buildings[i].effect.contains("farm")){
            int farmCount = 0;
            for(int i=0;i<players[currentPlayerIndex].buildings.length;i++){
              if(players[currentPlayerIndex].buildings[i].type == "작물"){
                farmCount +=1;
              }
            }
            players[currentPlayerIndex].money += farmCount*players[currentPlayerIndex].buildings[i].effectValue;
          }
        }
        print(
            "플레이어${currentPlayerIndex + 1}의 ${players[currentPlayerIndex].buildings[i].name} 효과 발동");
        print(players[currentPlayerIndex].buildings[i].effect);
      }
    }
    print("----------------------------");
  }

  void nextTurn() {
    if(extraTurn){
      rollDiceStatus = false;
      extraTurn = false;
    }
    else{
      players[currentPlayerIndex].currentPlayerTurn = false;
      currentPlayerIndex = (currentPlayerIndex + 1) % numOfPlayers;
      players[currentPlayerIndex].currentPlayerTurn = true;
      rollDiceStatus = false;
    }
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator == true) {
        Vibration.vibrate(pattern: [0, 100, 50, 100]);
      }
    });
  }

  void socketNextTurn(){
    if(extraTurn){
      rollDiceStatus = false;
      extraTurn = false;
    }
    else{
      players[currentPlayerIndex].currentPlayerTurn = false;
      currentPlayerIndex = (currentPlayerIndex + 1) % numOfPlayers;
      players[currentPlayerIndex].currentPlayerTurn = true;
      rollDiceStatus = false;
    }
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator == true) {
        Vibration.vibrate(pattern: [0, 100, 150, 100]);
      }
    });
  }
}
