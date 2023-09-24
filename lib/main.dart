import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'models/player.dart';
import 'models/building_card.dart';
import 'models/major_building_card.dart';
import 'models/game.dart';
import 'models/socket_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 인원수 (기본 2명)
  int numOfPlayers = 2;

  // 방 생성 or 참가 여부 (true = 생성 / false = 참가)
  bool createJoin = false;

  // 방코드
  String roomCode = "";

  // 유저 이름
  String userName = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('MiniVill'),
            elevation: 0.0,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings),
              )
            ],
          ),
          body: Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    // Main body 위쪽 빈공간
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    // Main body 중앙 컨텐츠 공간
                    flex: 8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  child: Icon(Icons.person),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: AutoSizeText(
                                  '이름 설정',
                                  minFontSize: 5,
                                  style: TextStyle(fontSize: 20.0),
                                  // 시작할 폰트 크기
                                  maxLines: 1, // 최대 줄 수
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '이름',
                                        ),
                                        onChanged: (String) => userName =
                                            String, // 'text' 파라미터를 사용하여 userName 변수에 값을 저장
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  child: Icon(Icons.people),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: AutoSizeText(
                                  '인원 설정',
                                  minFontSize: 5,
                                  style: TextStyle(fontSize: 20.0),
                                  // 시작할 폰트 크기
                                  maxLines: 1, // 최대 줄 수
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  child: Text('$numOfPlayers명'),
                                  onPressed: () {
                                    setState(() {
                                      numOfPlayers = numOfPlayers == 4
                                          ? 2
                                          : numOfPlayers + 1;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  child: Icon(Icons.play_circle_fill),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  child: AutoSizeText(
                                    '방 만들기',
                                    minFontSize: 5,
                                    style: TextStyle(fontSize: 20.0),
                                    // 시작할 폰트 크기
                                    maxLines: 1, // 최대 줄 수
                                  ),
                                  onPressed: () {
                                    createJoin = true;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameScreen(
                                            numOfPlayers: numOfPlayers,
                                            createJoin: createJoin,
                                            roomCode: roomCode,
                                            userName: userName),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: '방 코드',
                                          ),
                                          onChanged: (String) =>
                                              roomCode = String),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: ElevatedButton(
                                        child: AutoSizeText(
                                          '참가하기',
                                          minFontSize: 5,
                                          style: TextStyle(fontSize: 20.0),
                                          // 시작할 폰트 크기
                                          maxLines: 2, // 최대 줄 수
                                        ),
                                        onPressed: () {
                                          createJoin = false;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GameScreen(
                                                  numOfPlayers: numOfPlayers,
                                                  createJoin: createJoin,
                                                  roomCode: roomCode,
                                                  userName: userName),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class GameScreen extends StatefulWidget {
  final int numOfPlayers;
  final bool createJoin;
  final String roomCode;
  final String userName;

  GameScreen(
      {required this.numOfPlayers,
      required this.createJoin,
      required this.roomCode,
      required this.userName});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _animation;

  // 주사위 이미지를 위한 상태를 추가합니다.
  int diceNumber1 = 1;
  int diceNumber2 = 1;
  int numberOfDiceToRoll = 1;
  int diceResult = 0;

  int socketDiceResult = 0;
  int socketDiceNumber1 = 0;
  int socketDiceNumber2 = 0;

  int myPlayerIdIndex = 0;

  // 게임 설정
  String? selectedCardPath;

  Map<String, int> cardCounts = {};
  Map<String, bool> cardFlipped = {
    'assets/major_card/major_card_back_0.jpg': false,
    'assets/major_card/major_card_back_1.jpg': false,
    'assets/major_card/major_card_back_2.jpg': false,
    'assets/major_card/major_card_back_3.jpg': false,
  };

  bool diceConfirm = false;

  late MiniVillGame game;
  late SocketService socketService;

  List<String> playerName = [
    'waiting..',
    'waiting..',
    'waiting..',
    'waiting..'
  ];

  //widget.createJoin == true라면 방 만들기
  //widget.createJoin == false라면 방 참가
  //입력한 방 코드는 widget.roomCode
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    socketService = SocketService(widget.createJoin, widget.roomCode,
        widget.userName, widget.numOfPlayers);

    if (widget.createJoin) {
      socketService.createRoom(widget.userName, widget.numOfPlayers);
    } else {
      socketService.joinRoom(widget.roomCode, widget.userName);
    }

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      socketService.onGameStarted((data) {
        String roomCode = data['roomCode'];
        List<dynamic> players = data['players'];
        List<dynamic> playerNames = data['playerNames'];
        int numOfPlayer = data['numOfPlayer'];
        Future.delayed(Duration(milliseconds: 500), () {
          if (roomCode == socketService.nowRoomCode) {
            for (int i = 0; i < playerNames.length; i++) {
              print("유저이름: ${playerNames[i]}");
              playerName[i] = playerNames[i];
            }
            print("방 인원수: $numOfPlayer");
            Navigator.pop(context);
          }
        });
      });

      socketService.onRoomCreated((data) {
        List<dynamic> playerNames = data['playerNames'];
        Future.delayed(Duration(milliseconds: 100), () {
          _showWaitingDialog(context);
          myPlayerIdIndex = socketService.myPlayerId;
          for (int i = 0; i < playerNames.length; i++) {
            playerName[i] = playerNames[i];
          }
          setState(() {});
        });
      });

      socketService.onRoomJoined((data) {
        List<dynamic> playerNames = data['playerNames'];
        Future.delayed(Duration(milliseconds: 100), () {
          if (socketService.myPlayerId == data['playerId']) {
            _showWaitingDialog(context);
          }
          myPlayerIdIndex = socketService.myPlayerId;
          for (int i = 0; i < playerNames.length; i++) {
            playerName[i] = playerNames[i];
          }
          setState(() {});
        });
      });

      socketService.onDiceRolled((data) {
        String roomCode = data['roomCode'];
        socketDiceNumber1 = data['dice1Result'];
        socketDiceNumber2 = data['dice2Result'];
        numberOfDiceToRoll = data['numberOfDiceToRoll'];
        Future.delayed(Duration(milliseconds: 100), () {
          game.extraTurn = false;
          if (roomCode == socketService.nowRoomCode) {
            socketDiceResult = socketDiceNumber1 +
                (numberOfDiceToRoll == 2 ? socketDiceNumber2 : 0);
            if (game.players[game.currentPlayerIndex].majorBuildings[2]
                    .isActive &&
                socketDiceNumber1 == socketDiceNumber2 &&
                numberOfDiceToRoll == 2) {
              game.extraTurn = true;
            }
            // 주사위 애니메이션 실행
            _controller.forward();
          }
        });
      });

      socketService.onNextTurned((data) {
        String roomCode = data['roomCode'];
        Future.delayed(Duration(milliseconds: 100), () {
          if (roomCode == socketService.nowRoomCode) {
            game.socketNextTurn();
            setState(() {});
          }
        });
      });

      socketService.onCenterCardPurchased((data) {
        String roomCode = data['roomCode'];
        int purchasePlayerId = data['purchasePlayerId'];
        int buildingIndex = data['buildingIndex'];
        int buildingCost = data['buildingCost'];
        Future.delayed(Duration(milliseconds: 100), () {
          if (roomCode == socketService.nowRoomCode) {
            String socketSelectedCard;
            game.players[purchasePlayerId].buildings
                .add(game.centerCards[buildingIndex]);
            game.players[purchasePlayerId].money -= buildingCost;
            game.centerCards[buildingIndex].availableCount -= 1;
            socketSelectedCard = game.centerCards[buildingIndex].imagePath;
            cardCounts[socketSelectedCard!] =
                game.centerCards[buildingIndex].availableCount;
            setState(() {});
          }
        });
      });

      socketService.onMajorCardPurchased((data) {
        String roomCode = data['roomCode'];
        int purchasePlayerId = data['purchasePlayerId'];
        int buildingIndex = data['buildingIndex'];
        int buildingCost = data['buildingCost'];
        List<dynamic> playerNames = data['playerNames'];
        Future.delayed(Duration(milliseconds: 100), () {
          if (roomCode == socketService.nowRoomCode) {
            game.players[purchasePlayerId].majorBuildings[buildingIndex]
                .isActive = true;
            game.players[purchasePlayerId].money -= buildingCost;

            int victoryCount = 0;
            for (int i = 0;
                i < game.players[purchasePlayerId].majorBuildings.length;
                i++) {
              if (game.players[purchasePlayerId].majorBuildings[i].isActive) {
                victoryCount += 1;
              }
            }
            if (victoryCount >= 4) {
              _showVictoryDialog(
                  context, "${playerNames[purchasePlayerId]}이(가) 승리했어요!");
            }
          }
        });
      });

      socketService.onExtraDiceRolled((data) {
        String roomCode = data['roomCode'];
        bool shouldRollAgain = data['shouldRollAgain'];
        int extraNumberOfDiceToRoll = data['numberOfDiceToRoll'];
        int extraDice1Result = data['dice1Result'];
        int extraDice2Result = data['dice2Result'];
        int extraDiceResult;
        print("더굴릴지 말지 정보 받음");
        Future.delayed(Duration(milliseconds: 100), () {
          if (roomCode == socketService.nowRoomCode) {
            if (shouldRollAgain) {
              extraDiceResult = extraDice1Result +
                  (extraNumberOfDiceToRoll == 2 ? extraDice2Result : 0);
              // 주사위 확정시 주사위 효과 적용
              print("정보 받았는데 주사위 확정한대");
              game.rollDice(extraDiceResult);
              game.rollDiceStatus = true;
              game.extraDice = true;

              if (game.players[game.currentPlayerIndex].majorBuildings[2]
                      .isActive &&
                  extraDice1Result == extraDice2Result &&
                  extraNumberOfDiceToRoll == 2) {
                game.extraTurn = true;
                _showCustomDialog(context, "한턴을 추가로 진행할 수 있어요!");
              }
            } else {
              print("정보 받았는데 확정 안한대");
            }
          }
          setState(() {});
        });
      });
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: -100).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.forward ||
          _controller.status == AnimationStatus.reverse) {
        diceNumber1 = Random().nextInt(6) + 1;
        diceNumber2 = Random().nextInt(6) + 1;
      }
    });

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        diceNumber1 = socketDiceNumber1;
        diceNumber2 = socketDiceNumber2;
        diceResult = diceNumber1 + (numberOfDiceToRoll == 2 ? diceNumber2 : 0);
        setState(() {}); // UI 갱신

        if (!game.players[game.currentPlayerIndex].majorBuildings[3].isActive) {
          // 라디오 방송국 비활성화 시 바로 주사위 이벤트 진행
          game.rollDice(socketDiceResult);
          game.rollDiceStatus = true;

          if (game.players[game.currentPlayerIndex].majorBuildings[2]
                  .isActive &&
              diceNumber1 == diceNumber2 &&
              numberOfDiceToRoll == 2) {
            game.extraTurn = true;
            _showCustomDialog(context, "한턴을 추가로 진행할 수 있어요!");
          }
        } else if (game
                .players[game.currentPlayerIndex].majorBuildings[3].isActive &&
            game.extraDice) {
          // 주사위 다시 굴릴것 인지 물어보는 코드
          game.extraDice = false;
          if (game.currentPlayerIndex == socketService.myPlayerId) {
            bool shouldRollAgain =
                await _showDiceRollConfirmationDialog(context);
            if (shouldRollAgain) {
              // 주사위 확정시 주사위 효과 적용
              socketService.extraRollDice(shouldRollAgain, numberOfDiceToRoll,
                  diceNumber1, diceNumber2);
              print("주사위 확정");
              game.rollDice(socketDiceResult);
              game.rollDiceStatus = true;
              game.extraDice = true;

              if (game.players[game.currentPlayerIndex].majorBuildings[2]
                      .isActive &&
                  diceNumber1 == diceNumber2 &&
                  numberOfDiceToRoll == 2) {
                game.extraTurn = true;
                _showCustomDialog(context, "한턴을 추가로 진행할 수 있어요!");
              }
            }
          }
        } else {
          // 주사위 확정 안했을 시 추가로 진행한 주사위 이벤트 적용
          print("주사위 두번 굴리고 보상 얻음");
          game.rollDice(socketDiceResult);
          game.rollDiceStatus = true;
          game.extraDice = true;

          if (game.players[game.currentPlayerIndex].majorBuildings[2]
                  .isActive &&
              diceNumber1 == diceNumber2 &&
              numberOfDiceToRoll == 2) {
            game.extraTurn = true;
            _showCustomDialog(context, "한턴을 추가로 진행할 수 있어요!");
          }
        }
        setState(() {});
      }
    });

    game = MiniVillGame(widget.numOfPlayers);
    cardCounts = Map.fromIterable(
      game.centerCards,
      key: (item) => item.imagePath,
      value: (item) => item.availableCount,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 생명 주기 상태 변화를 감지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 이동했을 때
      print("App went to Background");
    } else if (state == AppLifecycleState.detached) {
      // 앱이 종료될 때 (안드로이드에서만 작동)
      print("App is closing");
      if (socketService.myPlayerId == 0) {
        socketService.gameFinish();
      }
    }
  }

  _showWaitingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (socketService.myPlayerId == 0) {
              socketService.gameFinish();
            }
            socketService.socket.off('roomCreated');
            socketService.socket.off('roomJoined');
            socketService.disconnect();

            Navigator.of(context).popUntil((route) => route.isFirst);

            return false;
          },
          child: AlertDialog(
            title: Text('게임 대기 중...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('방코드: ${socketService.nowRoomCode}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 방장일 경우에만 게임 시작 가능
                        if (socketService.myPlayerId == 0) {
                          socketService.gameStart();
                        }
                      },
                      child: Text('게임 시작'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (socketService.myPlayerId == 0) {
                          socketService.gameFinish();
                        }
                        socketService.socket.off('roomCreated');
                        socketService.socket.off('roomJoined');
                        socketService.disconnect();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text('돌아가기'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sideSpaceWidth = screenWidth * 0.2;

    List<Widget> playerWidgets = [];
    // numOfPlayers 만큼 왼쪽 플레이어 영역 추가
    for (int i = 0; i < widget.numOfPlayers; i++) {
      playerWidgets.add(
        Flexible(
            child: _playerWidget(
                playerName[i], game.players[i].id, game.currentPlayerIndex)),
      );
    }
    // 4 - numOfPlayers 만큼 빈공간 생성
    for (int i = 0; i < (4 - widget.numOfPlayers); i++) {
      playerWidgets.add(
        Flexible(
          child: Padding(padding: EdgeInsets.all(5.0)),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (socketService.gameStarted) {
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            //게임스크린 (플레이어 영역)
            Container(
              width: sideSpaceWidth,
              color: Colors.grey[200],
              child: Column(
                children: playerWidgets,
              ),
            ),
            //게임스크린 (게임 보드 영역)
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // 그리드 뷰 영역
                      Expanded(
                        flex: 3,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            double itemWidth = constraints.maxWidth / 5;
                            double itemHeight = constraints.maxHeight / 3;
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: itemWidth / itemHeight,
                              ),
                              itemCount: game.centerCards.length,
                              itemBuilder: (context, index) {
                                BuildingCard card = game.centerCards[index];
                                String cardImagePath = card.imagePath;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCardPath = cardImagePath;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CardStack(
                                          cardImagePath: cardImagePath,
                                          cardCount:
                                              cardCounts[cardImagePath] ?? 6),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _boardMajorCardImage(
                                      game.players[myPlayerIdIndex].id, 0),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _boardMajorCardImage(
                                      game.players[myPlayerIdIndex].id, 1),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _boardMajorCardImage(
                                      game.players[myPlayerIdIndex].id, 2),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _boardMajorCardImage(
                                      game.players[myPlayerIdIndex].id, 3),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 9,
                                              child: FittedBox(
                                                child: Icon(Icons.attach_money),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 9,
                                              child: AutoSizeText(
                                                '${game.players[myPlayerIdIndex].money}원',
                                                minFontSize: 5,
                                                style:
                                                    TextStyle(fontSize: 20.0),
                                                // 시작할 폰트 크기
                                                maxLines: 1, // 최대 줄 수
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _showPlayerBuildingStatusDialog(
                                                context,
                                                game.players[myPlayerIdIndex]
                                                    .id);
                                          },
                                          child: AutoSizeText(
                                            '건물 현황',
                                            minFontSize: 5,
                                            style: TextStyle(fontSize: 15.0),
                                            // 시작할 폰트 크기
                                            maxLines: 1, // 최대 줄 수
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // 건물 구매 안하고 턴넘기기
                                            setState(() {
                                              // 내 차레라는 뜻
                                              if (game.currentPlayerIndex ==
                                                  socketService.myPlayerId) {
                                                if (game.rollDiceStatus) {
                                                  socketService.nextTurn();
                                                  game.nextTurn();
                                                } else {
                                                  _showCustomDialog(context,
                                                      "주사위를 먼저 굴리십시오.");
                                                }
                                              } else {
                                                _showCustomDialog(
                                                    context, "내 차례가 아니에요!");
                                              }
                                            });
                                          },
                                          child: AutoSizeText(
                                            '턴 넘기기',
                                            minFontSize: 5,
                                            style: TextStyle(fontSize: 15.0),
                                            // 시작할 폰트 크기
                                            maxLines: 1, // 최대 줄 수
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (selectedCardPath != null)
                    ExpandedCardOverlay(
                      cardImagePath: selectedCardPath!,
                      onClose: () {
                        setState(() {
                          selectedCardPath = null;
                        });
                      },
                      onPurchase: () {
                        setState(() {
                          // 내 차레라는 뜻
                          if (game.currentPlayerIndex ==
                              socketService.myPlayerId) {
                            if (game.rollDiceStatus) {
                              if (selectedCardPath != null &&
                                  selectedCardPath!.startsWith('assets/center_card')) {
                                BuildingCard selectedCard = game.centerCards
                                    .firstWhere((card) =>
                                        card.imagePath == selectedCardPath);
                                int selectedIndex =
                                    game.centerCards.indexOf(selectedCard);
                                if (selectedCard.availableCount > 0) {
                                  if (selectedCard.cost <=
                                      game.players[game.currentPlayerIndex]
                                          .money) {
                                    selectedCard.availableCount -= 1;
                                    cardCounts[selectedCardPath!] =
                                        selectedCard.availableCount;
                                    game.players[game.currentPlayerIndex]
                                        .buildings
                                        .add(game.centerCards.firstWhere(
                                            (card) =>
                                                card.imagePath ==
                                                selectedCardPath));
                                    game.players[game.currentPlayerIndex]
                                        .money -= selectedCard.cost;
                                    socketService.centerCardPurchase(
                                        socketService.myPlayerId,
                                        selectedIndex,
                                        selectedCard.cost);

                                    socketService.nextTurn();

                                    game.nextTurn();
                                  } else if (selectedCard.cost >
                                      game.players[game.currentPlayerIndex]
                                          .money) {
                                    _showCustomDialog(context, "돈이 모자라요!");
                                  }
                                } else if (selectedCard.availableCount <= 0) {
                                  _showCustomDialog(context, "카드가 이미 다 팔렸어요!");
                                }
                              } else if (selectedCardPath != null &&
                                  selectedCardPath!
                                      .startsWith('assets/major_card')) {
                                int selectedIndex = game.majorCards.indexWhere(
                                    (card) =>
                                        card.backImagePath ==
                                            selectedCardPath ||
                                        card.frontImagePath ==
                                            selectedCardPath);
                                if (!game.players[game.currentPlayerIndex]
                                    .majorBuildings[selectedIndex].isActive) {
                                  if (game.majorCards[selectedIndex].cost <=
                                      game.players[game.currentPlayerIndex]
                                          .money) {
                                    game.players[game.currentPlayerIndex]
                                            .money -=
                                        game.majorCards[selectedIndex].cost;
                                    game
                                        .players[game.currentPlayerIndex]
                                        .majorBuildings[selectedIndex]
                                        .isActive = true;

                                    socketService.majorCardPurchase(
                                        socketService.myPlayerId,
                                        selectedIndex,
                                        game.majorCards[selectedIndex].cost);
                                    int victoryCount = 0;
                                    for (int i = 0;
                                        i <
                                            game
                                                .players[
                                                    game.currentPlayerIndex]
                                                .majorBuildings
                                                .length;
                                        i++) {
                                      if (game.players[game.currentPlayerIndex]
                                          .majorBuildings[i].isActive) {
                                        victoryCount += 1;
                                      }
                                    }
                                    if (victoryCount >= 4) {
                                      _showVictoryDialog(context,
                                          "${playerName[game.currentPlayerIndex]}이(가) 승리했어요!");
                                    }

                                    socketService.nextTurn();

                                    game.nextTurn();
                                  } else if (game
                                          .majorCards[selectedIndex].cost >
                                      game.players[game.currentPlayerIndex]
                                          .money) {
                                    // 돈이 모자라서 못산다는 메세지 띄우기
                                    _showCustomDialog(context, "돈이 모자라요!");
                                  }
                                } else if (game.players[game.currentPlayerIndex]
                                    .majorBuildings[selectedIndex].isActive) {
                                  // 이미 구매한 건물이라는 메세지 띄우기
                                  _showCustomDialog(
                                      context, "이미 구매한 주요 건물이에요!");
                                }
                              }
                            } else {
                              _showCustomDialog(context, "주사위를 먼저 굴리십시오.");
                            }
                          } else {
                            _showCustomDialog(context, "내 차례가 아니에요!");
                          }
                        });
                      },
                    ),
                ],
              ),
            )),
            //게임스크린 (주사위 영역)
            Container(
              width: sideSpaceWidth,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.translate(
                          offset: Offset(0, _animation.value),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 첫 번째 주사위 이미지
                                Image.asset(
                                  'assets/dice/dice_$diceNumber1.png',
                                  width: sideSpaceWidth * 0.4,
                                  fit: BoxFit.fitWidth,
                                ),
                                SizedBox(width: 10),
                                // 주사위 2개를 굴릴 때만 두 번째 주사위 이미지 표시
                                if (numberOfDiceToRoll == 2)
                                  Image.asset(
                                    'assets/dice/dice_$diceNumber2.png',
                                    width: sideSpaceWidth * 0.4,
                                    fit: BoxFit.fitWidth,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 10,
                          child: AutoSizeText(
                            '결과: $diceResult',
                            minFontSize: 5,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              diceEvent(1);
                            },
                            child: AutoSizeText(
                              '주사위 1개 굴리기',
                              minFontSize: 5,
                              style: TextStyle(fontSize: 15.0), // 시작할 폰트 크기
                              maxLines: 1, // 최대 줄 수
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              diceEvent(2);
                            },
                            child: AutoSizeText(
                              '주사위 2개 굴리기',
                              minFontSize: 5,
                              style: TextStyle(fontSize: 15.0), // 시작할 폰트 크기
                              maxLines: 1, // 최대 줄 수
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void diceEvent(int numberOfDice){
    if (game.currentPlayerIndex ==
        socketService.myPlayerId) {
      if (!game.rollDiceStatus) {
        if (!game.players[game.currentPlayerIndex]
            .majorBuildings[0].isActive && numberOfDice == 2) {
          _showCustomDialog(
              context, "기차역을 먼저 구매해야 합니다.");
        }else{
          setState(() {
            diceResult = 0;
            socketDiceResult = 0;
            numberOfDiceToRoll = numberOfDice;
          });
          _controller.forward();
          socketDiceNumber1 = Random().nextInt(6) + 1;
          socketDiceNumber2 = Random().nextInt(6) + 1;
          socketDiceResult = socketDiceNumber1 +
              (numberOfDiceToRoll == 2
                  ? socketDiceNumber2
                  : 0);
          socketService.rollDice(
              socketService.nowRoomCode,
              numberOfDiceToRoll,
              socketDiceNumber1,
              socketDiceNumber2);
        }
      }else {
        _showCustomDialog(context, "주사위를 이미 굴리셨습니다.");
      }
    }else {
      _showCustomDialog(context, "내 차례가 아니에요!");
    }
  }

  Widget _playerWidget(
      String playerName, int playerID, int currentPlayerIndex) {
    bool nowTurn = false;
    if (playerID == currentPlayerIndex) {
      nowTurn = true;
    }
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: nowTurn
            ? Border.all(
                color: Colors.red, width: 3) // 현재 플레이어의 차례일 때 빨간색 테두리 적용
            : Border.all(color: Colors.transparent), // 그렇지 않으면 투명한 테두리 적용
      ),
      child: Column(
        children: [
          // 프로필 아이콘과 이름
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    playerName,
                    minFontSize: 5,
                    style: TextStyle(fontSize: 20.0), // 시작할 폰트 크기
                    maxLines: 1, // 최대 줄 수
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: AutoSizeText(
                    '${game.players[playerID].money}원',
                    minFontSize: 5,
                    style: TextStyle(fontSize: 20.0), // 시작할 폰트 크기
                    maxLines: 1, // 최대 줄 수
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _showPlayerBuildingStatusDialog(context, playerID);
                    },
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.check, size: 100),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 4장의 카드
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: _playerMajorCardImage(playerID, 0),
                ),
                Expanded(
                  flex: 1,
                  child: _playerMajorCardImage(playerID, 1),
                ),
                Expanded(
                  flex: 1,
                  child: _playerMajorCardImage(playerID, 2),
                ),
                Expanded(
                  flex: 1,
                  child: _playerMajorCardImage(playerID, 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerMajorCardImage(int playerID, int majorNum) {
    String imagePath;
    if (game.players[playerID].majorBuildings[majorNum].isActive) {
      imagePath = "assets/major_card/major_card_front_$majorNum.jpg";
    } else {
      imagePath = "assets/major_card/major_card_back_$majorNum.jpg";
    }
    return Image.asset(
      imagePath,
      width: 40,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _boardMajorCardImage(int playerID, int majorNum) {
    String frontImagePath = "assets/major_card/major_card_front_$majorNum.jpg";
    String backImagePath = "assets/major_card/major_card_back_$majorNum.jpg";
    return GestureDetector(
      onTap: () {
        selectedCardPath = backImagePath;
        if (game.players[playerID].majorBuildings[majorNum].isActive) {
          setState(() {
            cardFlipped[selectedCardPath!] = true;
            selectedCardPath = frontImagePath;
          });
        } else {
          setState(() {
            cardFlipped[selectedCardPath!] = false;
            selectedCardPath = backImagePath;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Image.asset(
          game.players[playerID].majorBuildings[majorNum].isActive == true
              ? frontImagePath
              : backImagePath,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  _showCustomDialog(BuildContext context, String dialogText) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        child: Container(
          width: screenWidth * 0.5,
          height: screenHeight * 0.3,
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              dialogText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    await Future.delayed(Duration(seconds: 1));

    Navigator.of(context).pop();
  }

  void _showVictoryDialog(BuildContext context, String dialogText) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 바깥을 터치했을 때 Dialog가 닫히지 않도록 설정
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        child: Container(
          width: screenWidth * 0.5,
          height: screenHeight * 0.3,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dialogText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (socketService.myPlayerId == 0) {
                    socketService.gameFinish();
                    socketService.socket.off('roomCreated');
                    socketService.socket.off('roomJoined');
                    socketService.disconnect();
                  }
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlayerBuildingStatusDialog(BuildContext context, int playerID) {
    final playerBuildings = game.players[playerID].buildings;

    // 건물의 이름을 기반으로 건물의 수를 카운트
    final Map<String, int> buildingCounts = {};
    for (var building in playerBuildings) {
      if (buildingCounts.containsKey(building.name)) {
        buildingCounts[building.name] = buildingCounts[building.name]! + 1;
      } else {
        buildingCounts[building.name] = 1;
      }
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 컨텐츠에 따라 크기 조절
            children: [
              Text(
                '${playerName[playerID]}의 건물 현황',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              ...buildingCounts.entries
                  .map((entry) => Text('${entry.key}: ${entry.value}개')),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('닫기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDiceRollConfirmationDialog(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        child: Container(
            width: screenWidth * 0.5,
            height: screenHeight * 0.3,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 컨텐츠에 따라 크기 조절
              children: [
                Expanded(
                  flex: 6,
                  child: AutoSizeText(
                    '주사위를 다시 굴리시겠습니까?',
                    minFontSize: 5,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // 주사위를 다시 굴리는 코드를 여기에 작성하세요.
                            Navigator.of(context).pop(false); // 다이얼로그 닫기
                          },
                          child: AutoSizeText(
                            '다시 굴리기',
                            minFontSize: 5,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // 주사위 결과를 확정하는 코드를 여기에 작성하세요.
                            Navigator.of(context).pop(true); // 다이얼로그 닫기
                          },
                          child: AutoSizeText(
                            '확정하기',
                            minFontSize: 5,
                          ),
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );

    return result ?? false;
  }
}

class CardStack extends StatelessWidget {
  final String cardImagePath; // 각 카드의 이미지 경로
  final int cardCount; // 카드의 수

  CardStack({required this.cardImagePath, required this.cardCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(cardCount, (index) {
        return TransformCard(
          offset: 0.0,
          rotation: 0.1 * (3 - index), // 3을 카드의 중간 값으로 사용
          imagePath: cardImagePath,
        );
      }),
    );
  }
}

class TransformCard extends StatelessWidget {
  final double offset;
  final double rotation;
  final String imagePath; // 카드 이미지 경로

  TransformCard({
    required this.offset,
    required this.rotation,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.8;
        double cardHeight = constraints.maxHeight * 0.9;

        return Transform.translate(
          offset: Offset(offset, offset),
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              height: cardHeight, // GridView의 높이의 80%
              width: cardWidth, // GridView의 너비의 80%
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitHeight, // 이미지가 컨테이너에 맞게 조절됨
              ),
            ),
          ),
        );
      },
    );
  }
}

class ExpandedCardOverlay extends StatelessWidget {
  final String cardImagePath;
  final VoidCallback onClose;
  final VoidCallback onPurchase;

  ExpandedCardOverlay({
    required this.cardImagePath,
    required this.onClose,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(cardImagePath,
                width: screenWidth * 0.3,
                height: screenHeight * 0.8,
                fit: BoxFit.fitHeight),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      onPurchase();
                      onClose();
                    },
                    child: Text('구매하기')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: onClose, child: Text('취소하기')),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
