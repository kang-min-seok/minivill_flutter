import 'dart:io' show Platform;

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  late int myPlayerId;
  late String mySocketID;
  bool gameStarted= false;
  late String nowRoomCode="";

  late String myPlayerName;
  late int numOfPlayer;

  SocketService(bool createJoin, String roomCode, String playerName, int numOfPlayer) {

    socket = IO.io('https://natural-gennifer-beakseok.koyeb.app/',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();

    socket.on('connect_error', (error) => print('Connect error: $error'));
  }


  void gameStart(){
    socket.emit('gameStart', {'roomCode': nowRoomCode});
  }

  void onGameStarted(Function callback) {
    socket.on('gameStarted', (data) => callback(data));
  }

  void onRoomCreated(Function callback) {
    socket.on('roomCreated', (data) => callback(data));
  }

  void onRoomJoined(Function callback) {
    socket.on('roomJoined', (data) => callback(data));
  }

  void rollDice(String roomCode, int numberOfDiceToRoll, int dice1Result, int dice2Result) {
    socket.emit('rollDice', {
      'roomCode': roomCode,
      'numberOfDiceToRoll': numberOfDiceToRoll,
      'dice1Result': dice1Result,
      'dice2Result': dice2Result});
  }

  void onDiceRolled(Function callback) {
    socket.on('diceRolled', (diceResult) => callback(diceResult));
  }

  void extraRollDice(bool shouldRollAgain, int numberOfDiceToRoll, int dice1Result, int dice2Result){
    socket.emit('extraRollDice', {
                              'roomCode': nowRoomCode,
                              'shouldRollAgain': shouldRollAgain,
                              'numberOfDiceToRoll': numberOfDiceToRoll,
                              'dice1Result': dice1Result,
                              'dice2Result':dice1Result});
  }

  void onExtraDiceRolled(Function callback) {
    socket.on('extraDiceRolled', (data) => callback(data));
  }

  void nextTurn(){
    socket.emit('nextTurn', {'roomCode': nowRoomCode});
  }

  void centerCardPurchase(int purchasePlayerId, int buildingIndex, int buildingCost){
    // 방코드, 구매한 플레이어 id, 건물의 종류, 건물의 가격 날리기
    socket.emit('centerCardPurchase',{
      'roomCode': nowRoomCode,
      'purchasePlayerId' : purchasePlayerId,
      'buildingIndex' :buildingIndex,
      'buildingCost' : buildingCost
    });
  }
  void onCenterCardPurchased(Function callback) {
    socket.on('centerCardPurchased', (data) => callback(data));
  }

  void majorCardPurchase(int purchasePlayerId, int buildingIndex, int buildingCost){
    // 방코드, 구매한 플레이어 id, 건물의 종류, 건물의 가격 날리기
    socket.emit('majorCardPurchase',{
      'roomCode': nowRoomCode,
      'purchasePlayerId' : purchasePlayerId,
      'buildingIndex' :buildingIndex,
      'buildingCost' : buildingCost
    });
  }
  void onMajorCardPurchased(Function callback) {
    socket.on('majorCardPurchased', (data) => callback(data));
  }

  void onNextTurned(Function callback) {
    socket.on('doNextTurn', (data) => callback(data));
  }


  // 방 생성 요청
  void createRoom(String hostName, int numOfPlayer) {
    socket.emit('createRoom', {'hostName': hostName, 'numOfPlayer': numOfPlayer});
    socket.on('roomCreated', (data) {
      print('Room created with code: ${data['roomCode']}');
      print('Your player ID: ${data['playerId']}');
      myPlayerId = data['playerId'];
      nowRoomCode = data['roomCode'];
      mySocketID = data['socketID'];
    });
  }

  // 방에 참여 요청
  void joinRoom(String roomCode, String userName) {
    socket.emit('joinRoom', {'roomCode': roomCode, 'userName': userName});
    socket.on('roomJoined', (data) {
      print('Joined room with code: ${data['roomCode']}');
      print('Your player ID: ${data['playerId']}');
      myPlayerId = data['playerId'];
      nowRoomCode = data['roomCode'];
      mySocketID = data['socketID'];
    });

  }


  void gameFinish(){
    socket.emit('gameWon',{'roomCode': nowRoomCode});
  }
}
