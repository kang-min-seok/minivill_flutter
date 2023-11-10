import 'player.dart';
import 'center_building_card.dart';
import 'major_building_card.dart';
import 'package:vibration/vibration.dart';

class MiniVillGame {
  final int numOfPlayers;
  List<Player> players = [];
  List<CenterBuildingCard> centerCards = [];
  List<MajorBuildingCard> majorCards = [];
  int currentPlayerIndex = 0;
  int opponentPlayerIndex = 0;
  int everyPlayerIndex = 0;

  bool rollDiceStatus = false;
  bool extraTurn = false;
  bool extraDice = true;

  MiniVillGame(this.numOfPlayers) {
    // Initialize players with default money and centerBuildings
    for (int i = 0; i < numOfPlayers; i++) {
      players.add(Player(id: i));
    }

    // Initialize center cards
    centerCards = [
      CenterBuildingCard(
          name: '밀밭',
          type: '작물',
          cost: 1,
          triggerValue: [1],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_0.jpg'),
      CenterBuildingCard(
          name: '목장',
          type: '가축',
          cost: 1,
          triggerValue: [2],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_1.jpg'),
      CenterBuildingCard(
          name: '빵집',
          type: '서비스',
          cost: 1,
          triggerValue: [2, 3],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_2.jpg'),
      CenterBuildingCard(
          name: '카페',
          type: '커피',
          cost: 2,
          triggerValue: [3],
          triggerTurn: TriggerTurn.OpponentTurn,
          effect: 'steal',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_3.jpg'),
      CenterBuildingCard(
          name: '편의점',
          type: '서비스',
          cost: 2,
          triggerValue: [4],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_4.jpg'),
      CenterBuildingCard(
          name: '숲',
          type: '자원',
          cost: 3,
          triggerValue: [5],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 1,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_5.jpg'),
      CenterBuildingCard(
          name: '전시장',
          type: '특수',
          cost: 8,
          triggerValue: [6],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'special-building',
          effectValue: 1,
          availableCount: 4,
          imagePath: 'assets/center_card/center_card_6.jpg'),
      CenterBuildingCard(
          name: 'TV 방송국',
          type: '특수',
          cost: 7,
          triggerValue: [6],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'special-steal',
          effectValue: 5,
          availableCount: 4,
          imagePath: 'assets/center_card/center_card_7.jpg'),
      CenterBuildingCard(
          name: '경기장',
          type: '특수',
          cost: 6,
          triggerValue: [6],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'all-steal',
          effectValue: 2,
          availableCount: 4,
          imagePath: 'assets/center_card/center_card_8.jpg'),
      CenterBuildingCard(
          name: '치즈 공장',
          type: '공장',
          cost: 5,
          triggerValue: [7],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus-building-cheese',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_9.jpg'),
      CenterBuildingCard(
          name: '가구 공장',
          type: '공장',
          cost: 3,
          triggerValue: [8],
          triggerTurn: TriggerTurn.MyTurn,
          effect: 'plus-building-gagoo',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_10.jpg'),
      CenterBuildingCard(
          name: '광산',
          type: '자원',
          cost: 6,
          triggerValue: [9],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 5,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_11.jpg'),
      CenterBuildingCard(
          name: '패밀리 레스토랑',
          type: '커피',
          cost: 3,
          triggerValue: [9, 10],
          triggerTurn: TriggerTurn.OpponentTurn,
          effect: 'steal',
          effectValue: 2,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_12.jpg'),
      CenterBuildingCard(
          name: '사과밭',
          type: '작물',
          cost: 3,
          triggerValue: [10],
          triggerTurn: TriggerTurn.EveryTurn,
          effect: 'plus',
          effectValue: 3,
          availableCount: 6,
          imagePath: 'assets/center_card/center_card_13.jpg'),
      CenterBuildingCard(
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
          backImagePath: 'assets/major_card/major_card_back_0.jpg',
          frontImagePath: 'assets/major_card/major_card_front_0.jpg'),
      MajorBuildingCard(
          name: '쇼핑몰',
          cost: 10,
          backImagePath: 'assets/major_card/major_card_back_1.jpg',
          frontImagePath: 'assets/major_card/major_card_front_1.jpg'),
      MajorBuildingCard(
          name: '놀이공원',
          cost: 16,
          backImagePath: 'assets/major_card/major_card_back_2.jpg',
          frontImagePath: 'assets/major_card/major_card_front_2.jpg'),
      MajorBuildingCard(
          name: '라디오 방송국',
          cost: 22,
          backImagePath: 'assets/major_card/major_card_back_3.jpg',
          frontImagePath: 'assets/major_card/major_card_front_3.jpg')
    ];


    for (int i = 0; i < numOfPlayers; i++) {
      players[i].centerBuildings.add(centerCards[0]);
      players[i].centerBuildings.add(centerCards[2]);

      players[i].majorBuildings.add(MajorBuildingCard(
          name: '기차역',
          cost: 4,
          backImagePath: 'assets/major_card/major_card_back_0.jpg',
          frontImagePath: 'assets/major_card/major_card_front_0.jpg'));
      players[i].majorBuildings.add(MajorBuildingCard(
          name: '쇼핑몰',
          cost: 10,
          backImagePath: 'assets/major_card/major_card_back_1.jpg',
          frontImagePath: 'assets/major_card/major_card_front_1.jpg'));
      players[i].majorBuildings.add(MajorBuildingCard(
          name: '놀이공원',
          cost: 16,
          backImagePath: 'assets/major_card/major_card_back_2.jpg',
          frontImagePath: 'assets/major_card/major_card_front_2.jpg'));
      players[i].majorBuildings.add(MajorBuildingCard(
          name: '라디오 방송국',
          cost: 22,
          backImagePath: 'assets/major_card/major_card_back_3.jpg',
          frontImagePath: 'assets/major_card/major_card_front_3.jpg'));
    }

    players[currentPlayerIndex].currentPlayerTurn = true;
  }

  void rollDice(int diceValue) {
    // 상대의 턴 실행
    // 현재 플레이어 턴 인덱스 값을 중심으로 뺏어오기 위해 선언
    opponentPlayerIndex = currentPlayerIndex;
    // 상대의 턴 먼저 모두 실행(내 다음 순서부터 순차적으로 진행)
    for (int i = 0; i < numOfPlayers - 1; i++) {
      // 상대의 인덱스 값
      opponentPlayerIndex = (opponentPlayerIndex + 1) % numOfPlayers;
      // 상대가 가진 건물 수 만큼 반복
      for (int j = 0; j < players[opponentPlayerIndex].centerBuildings.length; j++) {
        // 현재 나온 주사위 값과 내가 가진 건물의 발동 눈금이 같고 / 발동 조건이 상대 턴이라면 실행
        if (players[opponentPlayerIndex].centerBuildings[j].triggerValue
                .contains(diceValue) && players[opponentPlayerIndex]
            .centerBuildings[j].triggerTurn == TriggerTurn.OpponentTurn) {
          // 쇼핑몰 활성화한 상대라면 건물 당 1원 추가 획득
          // 발동 조건이 상대턴인 것은 카페와 패밀리 레스토랑 밖에 없음
          if(players[opponentPlayerIndex].majorBuildings[1].isActive){
            players[opponentPlayerIndex].money += 1;
          }
          // 뺏어오는 돈 만큼 반복문 실행
          for(int k=0; k< players[opponentPlayerIndex].centerBuildings[j].effectValue; k++){
            // 돈을 뺏기는 플레이어의 돈이 0원이 아니라면 실행
            if(players[currentPlayerIndex].money != 0){
              // 1원씩 뺏어오기
              players[currentPlayerIndex].money -= 1;
              players[opponentPlayerIndex].money += 1;
            }
          }
        }
      }
    }


    // -------------------------------------------------------------------------
    // 모두의 턴 실행
    // 플레이어 인원수 만큼 반복
    for (int i = 0; i < numOfPlayers; i++) {
      // i번째 플레이어의 중앙 건물 갯수 만큼 반복
      for (int j = 0; j < players[i].centerBuildings.length; j++) {
        // i번째 플레이어의 건물 발동 눈금과 주사위 값이 똑같고 / 발동조건이 모두의 턴이라면 실행
        if (players[i].centerBuildings[j].triggerValue.contains(diceValue) &&
            players[i].centerBuildings[j].triggerTurn == TriggerTurn.EveryTurn) {
          // 위 조건 만족하는 건물의 얻는 돈만큼 i번째 플레이어 돈 증가
          players[i].money += players[i].centerBuildings[j].effectValue;
        }
      }
    }


    // -------------------------------------------------------------------------
    // 나의 턴 실행
    // 턴을 진행하고 있는 플레이어의 중앙 건물 개수 만큼 반복
    for (int i = 0; i < players[currentPlayerIndex].centerBuildings.length; i++) {
      // 턴을 진행하고 있는 플레이어 건물의 발동 눈금과 주사위 값이 같고 / 발동조건이 나의 턴이라면 실행
      if (players[currentPlayerIndex]
              .centerBuildings[i]
              .triggerValue
              .contains(diceValue) &&
          players[currentPlayerIndex].centerBuildings[i].triggerTurn ==
              TriggerTurn.MyTurn) {
        // -------------------------------------------------------------------------
        // 건물의 효과가 plus라면 실행
        if(players[currentPlayerIndex].centerBuildings[i].effect =="plus"){
          // 위 조건 만족하는 건물의 얻는 돈 만큼 플레이어 돈 증가
          players[currentPlayerIndex].money += players[currentPlayerIndex].centerBuildings[i].effectValue;
          // 쇼핑몰 활성화한 상태하면 건물 당 1원씩 추가
          // 나의 턴이면서 효과가 plus인것은 빵집, 편의점 뿐
          if(players[currentPlayerIndex].majorBuildings[1].isActive){
            players[currentPlayerIndex].money += 1;
          }
        }
        // -------------------------------------------------------------------------
        // 건물의 효과가 special-building이라면 실행 (전시장, 다음 차례 가장 비싼 건물 뺏기)
        else if(players[currentPlayerIndex].centerBuildings[i].effect=="special-building"){
          int maxCostIndex = 0;
          // 내 다음 차례 플레이어 첫번째 건물의 가격을 maxCost에 저장
          int maxCost = players[(currentPlayerIndex + 1) % numOfPlayers].centerBuildings[0].cost;
          // 내 다음 차례 플레이어 두번째 건물부터 소유 중인 건물 끝까지 반복
          for (int j = 1; j < players[(currentPlayerIndex + 1) % numOfPlayers].centerBuildings.length; j++) {
            // 반복중에 만약 더 비싼 건물이 있다면 실행
            if (players[(currentPlayerIndex + 1) % numOfPlayers].centerBuildings[j].cost > maxCost) {
              // 더 비싼 건물의 가격과 해당 건물의 인덱스 값을 저장
              maxCost = players[(currentPlayerIndex + 1) % numOfPlayers].centerBuildings[j].cost;
              maxCostIndex = j;
            }
          }
          // 현재 턴을 진행하는 플레이어가 다음 차례 플레이어의 가장 비싼 건물을 추가
          players[currentPlayerIndex].centerBuildings.add(players[(currentPlayerIndex + 1) % numOfPlayers].centerBuildings[maxCostIndex]);
          // 현재 턴 다음 플레이어의 가장 비싼 건물 삭제
          players[(currentPlayerIndex + 1) % numOfPlayers].centerBuildings.removeAt(maxCostIndex);
        }
        // -------------------------------------------------------------------------
        // 건물의 효과가 special-steal이라면 실행 (TV방송국, 다음 차례 플레이어에게서 5원 뺏기)
        else if(players[currentPlayerIndex].centerBuildings[i].effect=="special-steal"){
          // 뺏어오는 돈 만큼 반복문 실행
          for(int j=0; j< players[currentPlayerIndex].centerBuildings[i].effectValue; j++){
            // 다음 차례 플레이어의 돈이 0원이 아니라면 실행
            if(players[(currentPlayerIndex + 1) % numOfPlayers].money != 0){
              // 1원씩 뺏어오기
              players[currentPlayerIndex].money += 1;
              players[(currentPlayerIndex + 1) % numOfPlayers].money -= 1;
            }
          }
        }
        // -------------------------------------------------------------------------
        // 건물의 효과가 all-steal이라면 실행 (경기장, 모든 플레이어에게서 2원 뺏기)
        else if(players[currentPlayerIndex].centerBuildings[i].effect=="all-steal"){
          // 내 다음 차례 플레이어 인덱스 값 저장
          int stealPlayerIndex = (currentPlayerIndex + 1) % numOfPlayers;
          // 플레이어 인원수 -1 만큼 반복(본인 제외)
          for(int j=0; j<numOfPlayers-1;j++){
            // 뺏어오는 돈만큼 반복문 실행
            for(int k=0; k< players[currentPlayerIndex].centerBuildings[i].effectValue; k++){
              // 돈을 뺏기는 플레이어의 돈이 0원이 아니라면 실행
              if(players[stealPlayerIndex].money != 0){
                // 1원씩 뺏어오기
                players[currentPlayerIndex].money += 1;
                players[stealPlayerIndex].money -= 1;
              }
            }
            // 그 다음 차례의 플레이어 인덱스 지정
            stealPlayerIndex = (stealPlayerIndex+1) % numOfPlayers;
          }
        }
        // 건물의 효과 중 plus-building이라는 문구가 있다면 실행 (치즈 공장, 가구 공장, 농산물 시장)
        else if(players[currentPlayerIndex].centerBuildings[i].effect.contains("plus-building")){
          // -------------------------------------------------------------------------
          // 건물의 효과 중 cheese라는 문구가 있다면 실행 (치즈 공장)
          if(players[currentPlayerIndex].centerBuildings[i].effect.contains("cheese")){
            int cheeseCount = 0;
            // 현재 플레이어가 가진 중앙 건물 개수 만큼 반복
            for(int j=0;j<players[currentPlayerIndex].centerBuildings.length;j++){
              // 현재 플레이어가 가진 건물의 종류가 가축이라면 cheeseCount 1증가
              if(players[currentPlayerIndex].centerBuildings[j].type == "가축"){
                cheeseCount +=1;
              }
            }
            // 가축 건물 개수 * 치즈 공장 얻는 돈 만큼 현재 플레이어 돈 증가
            players[currentPlayerIndex].money += cheeseCount*players[currentPlayerIndex].centerBuildings[i].effectValue;
          }
          // -------------------------------------------------------------------------
          // 건물의 효과 중 gagoo라는 문구가 있다면 실행 (가구 공장)
          else if(players[currentPlayerIndex].centerBuildings[i].effect.contains("gagoo")){
            int gagooCount = 0;
            // 현재 플레이어가 가진 중앙 건물 개수 만큼 반복
            for(int j=0;j<players[currentPlayerIndex].centerBuildings.length;j++){
              // 현재 플레이어가 가진 건물의 종류가 자원이라면 gagooCount 1증가
              if(players[currentPlayerIndex].centerBuildings[j].type == "자원"){
                gagooCount +=1;
              }
            }
            // 자원 건물 개수 * 가구 공장 얻는 돈 만큼 현재 플레이어 돈 증가
            players[currentPlayerIndex].money += gagooCount*players[currentPlayerIndex].centerBuildings[i].effectValue;
          }
          // -------------------------------------------------------------------------
          // 건물의 효과 중 farm이라는 문구가 있다면 실행 (농산물 시장)
          else if(players[currentPlayerIndex].centerBuildings[i].effect.contains("farm")){
            int farmCount = 0;
            // 현재 플레이어가 가진 중앙 건물 개수 만큼 반복
            for(int j=0;j<players[currentPlayerIndex].centerBuildings.length;j++){
              // 현재 플레이어가 가진 건물의 종류가 작물이라면 farmCount 1증가
              if(players[currentPlayerIndex].centerBuildings[j].type == "작물"){
                farmCount +=1;
              }
            }
            // 작물 건물 개수 * 농산물 시장 얻는 돈 만큼 현재 플레이어 돈 증가
            players[currentPlayerIndex].money += farmCount*players[currentPlayerIndex].centerBuildings[i].effectValue;
          }
        }
      }
    }
  }

  
  void nextTurn() {
    if(extraTurn){
      rollDiceStatus = false;
      extraTurn = false;
    }
    else{
      print("턴넘김 , 인덱스값: $currentPlayerIndex");
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
      print("턴넘김 , 인덱스값: $currentPlayerIndex");
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
