import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sliding_puzzle/models/enums.dart';
import 'package:sliding_puzzle/settings/constants.dart';

class GameController with ChangeNotifier {
  int _puzzleDimension = kPuzzleDimension;
  int _piecesCount = kPuzzleDimension * kPuzzleDimension - 1;
  int _moveCount = 0;
  List<int> _piecesPositions = [];
  List<Widget> _piecesContents = [];
  GameMode _gameMode = GameMode.number;
  String _gameImage = 'assets/images/image1.png';
  File? _userImage;
  GameStatus _gameStatus = GameStatus.ready;
  Stopwatch? _stopwatch;

  // 매초 변경시마다 notifyListeners()를 호출할 필요가 없도록 하기 위해 stream을 사용한다.
  String _elapsedTime = '00:00';
  StreamController<String>? _timerStreamController;

  GameController() {
    _init();
  }

  /// 테스트 전용 코드
  /// todo delete me
  void testShuffle() {
    for (int i = 0; i < _piecesPositions.length; i++) {
      _piecesPositions[i] = i == _piecesPositions.length - 1 ? _piecesPositions.length : i;
    }
    notifyListeners();
  }

  /// Getters
  int get puzzleDimension => _puzzleDimension;

  int get piecesCount => _piecesCount;

  int get moveCount => _moveCount;

  GameMode get gameMode => _gameMode;

  String get gameImage => _gameImage;

  File? get userImage => _userImage;

  GameStatus get gameStatus => _gameStatus;

  String get elapsedTime => _elapsedTime;

  Stream get elapsedTimeStream => _timerStreamController!.stream;

  /// Setters
  set gameMode(GameMode mode) {
    _gameMode = mode;
    _prepareContents();
    notifyListeners();
  }

  set gameImage(String gameImage) {
    _gameImage = gameImage;
    _gameMode = GameMode.image;
    _prepareContents();
    notifyListeners();
  }

  set userImage(File? userImage) {
    _userImage = userImage;
    _gameMode = GameMode.image;
    _prepareContents();
    notifyListeners();
  }

  /// 게임리셋
  void resetGame() async {
    debugPrint('Game reseted');
    _init();
    _stopTimer(reset: true);
    _gameStatus = GameStatus.ready;
    notifyListeners();
  }

  /// 시작중
  void startingGame() {
    debugPrint('Game starting');
    _init();
    _gameStatus = GameStatus.starting;
    notifyListeners();
  }

  /// 게임시작
  void startGame() async {
    debugPrint('Game started');
    _gameStatus = GameStatus.playing;
    _startTimer();
    notifyListeners();
  }

  /// 게임 난이도 변경
  void setPuzzleDimension(int dimension) {
    _puzzleDimension = dimension;
    _piecesCount = _puzzleDimension * _puzzleDimension - 1;
    _init();
    notifyListeners();
  }

  /// 퍼즐 조각 섞기
  void shuffle() {
    _piecesPositions.shuffle();
    notifyListeners();
  }

  /// 조각 위치 반환
  int getPiecePosition(int pieceId) => _piecesPositions[pieceId];

  /// 조각 이름 반환
  Widget getPieceContent(int pieceId) => _piecesContents[pieceId];

  /// 조각 이동: 이동 후에는 새로운 위치를 반환한다.
  int? movePiece(int pieceId) {
    int? emptyPosition;
    int? moveSteps;

    if (_gameStatus != GameStatus.playing) return null;

    emptyPosition = _findEmptyPosition(pieceId, 'UP');
    if (emptyPosition != null) {
      moveSteps = _puzzleDimension * -1;
    } else {
      emptyPosition = _findEmptyPosition(pieceId, 'DOWN');
      if (emptyPosition != null) {
        moveSteps = _puzzleDimension;
      } else {
        emptyPosition = _findEmptyPosition(pieceId, 'LEFT');
        if (emptyPosition != null) {
          moveSteps = -1;
        } else {
          emptyPosition = _findEmptyPosition(pieceId, 'RIGHT');
          if (emptyPosition != null) {
            moveSteps = 1;
          }
        }
      }
    }

    List<int> pieceIds = [];
    if (emptyPosition != null && moveSteps != null) {
      _moveCount++;

      for (int position = _piecesPositions[pieceId]; position != emptyPosition; position += moveSteps) {
        pieceIds.add(_piecesPositions.indexWhere((element) => element == position));
      }
      for (int i = 0; i < pieceIds.length; i++) {
        _piecesPositions[pieceIds[i]] += moveSteps;
      }

      if (_completeCheck()) {
        _stopTimer(reset: false);
        debugPrint('Completed');
      }
      notifyListeners();
    }

    return emptyPosition;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /// 내부 전용 함수
  //////////////////////////////////////////////////////////////////////////////////////////////////

  void _init() {
    _piecesPositions = List.generate(_piecesCount, (index) => index);
    _prepareContents();
    _moveCount = 0;

    _timerStreamController?.close();
    _timerStreamController = null;
    _timerStreamController = StreamController<String>.broadcast();
  }

  /// 상하좌우 방향으로 빈셀 위치 찾기
  int? _findEmptyPosition(int pieceId, String direction) {
    int currentPosition = _piecesPositions[pieceId];

    switch (direction) {
      case 'UP':
        int checkPosition = currentPosition - _puzzleDimension;
        while (checkPosition >= 0) {
          // 체크셀의 위치(Position)가 사용중이 아니라면 찾던 빈셀이다.
          if (!_piecesPositions.contains(checkPosition)) {
            return checkPosition;
          }
          checkPosition -= _puzzleDimension;
        }
        break;

      case 'DOWN':
        int checkPosition = currentPosition + _puzzleDimension;
        while (checkPosition < _puzzleDimension * _puzzleDimension) {
          // 체크셀의 위치(Position)가 사용중이 아니라면 찾던 빈셀이다.
          if (!_piecesPositions.contains(checkPosition)) {
            return checkPosition;
          }
          checkPosition += _puzzleDimension;
        }
        break;

      case 'LEFT':
        int currentRow = currentPosition ~/ _puzzleDimension;
        int checkPosition = currentPosition - 1;
        // 줄 번호가 같아야 한다.
        while (checkPosition >= 0 && (checkPosition ~/ _puzzleDimension) == currentRow) {
          // 체크셀의 위치(Position)가 사용중이 아니라면 찾던 빈셀이다.
          if (!_piecesPositions.contains(checkPosition)) {
            return checkPosition;
          }
          checkPosition -= 1;
        }
        break;

      case 'RIGHT':
        int currentRow = currentPosition ~/ _puzzleDimension;
        int checkPosition = currentPosition + 1;
        // 줄 번호가 같아야 한다.
        while ((checkPosition ~/ _puzzleDimension) == currentRow) {
          // 체크셀의 위치(Position)가 사용중이 아니라면 찾던 빈셀이다.
          if (!_piecesPositions.contains(checkPosition)) {
            return checkPosition;
          }
          checkPosition += 1;
        }
        break;
    }

    // 여기까지 왔다면 상하좌우 방향으로 빈 셀이 없는 것이다.
    return null;
  }

  /// 조각 라벨 또는 이미지 준비
  void _prepareContents() {
    if (_gameMode == GameMode.number) {
      double fontSize = 0;
      if (_puzzleDimension == 3) {
        fontSize = 24;
      } else if (_puzzleDimension == 4) {
        fontSize = 18;
      } else {
        fontSize = 16;
      }

      _piecesContents = List.generate(
        _piecesCount,
        (index) => Text(
          '${index + 1}',
          style: TextStyle(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      _piecesContents = getSlicedWidget(
        horizontalCount: _puzzleDimension,
        verticalCount: _puzzleDimension,
        horizontalSpacing: kPuzzlePieceSpace,
        verticalSpacing: kPuzzlePieceSpace,
        child: _gameImage.isNotEmpty
            ? Image.asset(_gameImage, fit: BoxFit.cover)
            : Image.file(_userImage!, fit: BoxFit.cover),
      );
    }
  }

  /// 완성 여부 반환
  bool _completeCheck() {
    // 모든 조각의 id가 위치번호와 일치하면 완성된 것이다.
    for (int pieceId = 0; pieceId < _piecesPositions.length; pieceId++) {
      if (_piecesPositions[pieceId] != pieceId) {
        notifyListeners();
        return false;
      }
    }
    _gameStatus = GameStatus.completed;
    return true;
  }

  /// 시간 문자열 생성: output => 03:05
  String _formattedTime() {
    if (_stopwatch == null) {
      return '00:00';
    } else {
      return _stopwatch!.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0') +
          ':' +
          _stopwatch!.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    }
  }

  /// 타이머 시작
  void _startTimer() {
    _stopwatch = Stopwatch()..start();
    _elapsedTime = _formattedTime();
    _timerStreamController?.sink.add(_elapsedTime);

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_stopwatch?.isRunning ?? false) {
        _elapsedTime = _formattedTime();
        _timerStreamController?.sink.add(_elapsedTime);
      } else {
        timer.cancel();
      }
    });
  }

  /// 타이머 종료
  void _stopTimer({required bool reset}) {
    _stopwatch?.stop();
    if (reset) _stopwatch?.reset();
    _elapsedTime = _formattedTime();
    _timerStreamController?.sink.add(_elapsedTime);
  }

  /// 이미지를 조각내기
  List<Widget> getSlicedWidget(
      {required int horizontalCount,
      required int verticalCount,
      required double horizontalSpacing,
      required double verticalSpacing,
      required Widget child}) {
    // 전체 그림의 가로와 세로 크기 기본값. 이 값이 퍼즐 화면보다 커야만 정상적인 조각이 가능하다.
    // 아주 여우있게 1000 정도로 정했다
    const defaultSize = 1000.0;
    List<Widget> slicedWidgets = [];

    final sliceWidth = (defaultSize - horizontalSpacing * (horizontalCount - 1)) / horizontalCount;
    final sliceHeight = (defaultSize - verticalSpacing * (verticalCount - 1)) / verticalCount;

    final widthFactor = sliceWidth / defaultSize;
    final heightFactor = sliceHeight / defaultSize;

    for (int sliceNo = 0; sliceNo < horizontalCount * verticalCount; sliceNo++) {
      final xOffset = (sliceWidth + horizontalSpacing) * (sliceNo % horizontalCount);
      final xFactor = xOffset / (defaultSize - sliceWidth);

      final yOffset = (sliceHeight + verticalSpacing) * (sliceNo ~/ horizontalCount);
      final yFactor = yOffset / (defaultSize - sliceHeight);

      Widget sliced = FittedBox(
        child: ClipRect(
          child: Align(
            alignment: FractionalOffset(xFactor, yFactor),
            widthFactor: widthFactor,
            heightFactor: heightFactor,
            child: SizedBox(
              width: defaultSize,
              height: defaultSize,
              child: child,
            ),
          ),
        ),
      );
      slicedWidgets.add(sliced);
    }
    return slicedWidgets;
  }
}
