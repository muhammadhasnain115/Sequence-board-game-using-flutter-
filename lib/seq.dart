import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'card.dart';
import 'fill_grid.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final int gridSize = 10;
  final double cellSize = 60.0;
  List<PlayingCard?> cards = fillGridManually();
  List<List<String>> boardState = List.generate(10, (_) => List.filled(10, 'empty'));
  List<List<String>> deck = [];
  List<String> playerHand = [];
  List<String> aiHand = [];
  bool isPlayerTurn = true;
  String currentCard = '';
  int remainingCards = 0;
  int playerSequences = 0;
  int aiSequences = 0;
  String? aiPlayedCard;
  bool showAiCard = false;
  bool gameOver = false;
  String winner = '';
  List<Point> highlightedSpots = [];
  List<List<bool>> sequenceMarkers = List.generate(10, (_) => List.filled(10, false));
  bool showDroppedCard = false;
  String? droppedCard;
  Timer? _highlightTimer;
  Point? aiLastMove;
  int? aiMoveRow;
  int? aiMoveCol;
  bool _showHistory = false;
  List<String> moveHistory = [];
  Point? aiLastMovePosition;  // To track the position
  String? aiLastMoveCard;     // To track the card played
  bool showAiLastMove = false; // To control visibility
  @override
  void initState() {
    super.initState();
    initializeDeck();
    dealCards();
    _initializeWildSpots();
    _startHighlightTimer();
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    super.dispose();
  }

  void _initializeWildSpots() {
    boardState[0][0] = 'wild';
    boardState[0][9] = 'wild';
    boardState[9][0] = 'wild';
    boardState[9][9] = 'wild';
  }

  void _startHighlightTimer() {
    _highlightTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (isPlayerTurn && !gameOver) {
        setState(() {
          highlightedSpots = _getHighlightedSpots();
        });
      }
    });
  }
  void _addToHistory(String move) {
    setState(() {
      moveHistory.insert(0, move); // Add to beginning to show latest first
      if (moveHistory.length > 10) {
        moveHistory.removeLast(); // Keep only last 10 moves
      }
    });
  }

  void _toggleHistory() {
    setState(() {
      _showHistory = !_showHistory;
    });
  }
  List<Point> _getHighlightedSpots() {
    List<Point> spots = [];
    for (String card in playerHand) {
      List<String> parts = card.split(' of ');
      bool isJack = parts[0] == 'J';

      for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
          if (isJack) {
            String eyes = getEyes(parts[0], parts[1]);
            if (eyes == 'single eye' && boardState[i][j] == 'player' && !sequenceMarkers[i][j]) {
              spots.add(Point(i, j));
            } else if (eyes == 'double eye' && boardState[i][j] == 'empty' && !_isWildSpot(i, j)) {
              spots.add(Point(i, j));
            }
          } else {
            if (cards[i * 10 + j]?.value == parts[0] &&
                cards[i * 10 + j]?.suit == parts[1] &&
                boardState[i][j] == 'empty') {
              spots.add(Point(i, j));
            }
          }
        }
      }
    }
    return spots;
  }

  bool _isWildSpot(int row, int col) {
    return (row == 0 && col == 0) ||
        (row == 0 && col == 9) ||
        (row == 9 && col == 0) ||
        (row == 9 && col == 9);
  }

  void initializeDeck() {
    List<String> values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
    List<String> suits = ['spades', 'hearts', 'clubs', 'diamonds'];

    deck = [];
    for (String suit in suits) {
      for (String value in values) {
        String eyes = 'nil';
        if (value == 'J') {
          eyes = (suit == 'clubs' || suit == 'diamonds') ? 'double eye' : 'single eye';
        }
        deck.add([value, suit, eyes]);
      }
    }

    // Add second deck (standard Sequence uses 2 decks)
    for (String suit in suits) {
      for (String value in values) {
        String eyes = 'nil';
        if (value == 'J') {
          eyes = (suit == 'clubs' || suit == 'diamonds') ? 'double eye' : 'single eye';
        }
        deck.add([value, suit, eyes]);
      }
    }

    deck.shuffle();
    remainingCards = deck.length;
  }

  void dealCards() {
    playerHand = [];
    aiHand = [];

    for (int i = 0; i < 5; i++) {
      if (deck.isNotEmpty) {
        playerHand.add('${deck.last[0]} of ${deck.last[1]}');
        deck.removeLast();
        remainingCards--;
      }
      if (deck.isNotEmpty) {
        aiHand.add('${deck.last[0]} of ${deck.last[1]}');
        deck.removeLast();
        remainingCards--;
      }
    }
  }

  void drawCard() {
    if (deck.isNotEmpty) {
      if (isPlayerTurn && playerHand.length < 5) {
        playerHand.add('${deck.last[0]} of ${deck.last[1]}');
        deck.removeLast();
        remainingCards--;
      } else if (!isPlayerTurn && aiHand.length < 5) {
        aiHand.add('${deck.last[0]} of ${deck.last[1]}');
        deck.removeLast();
        remainingCards--;
      }
    }
  }



  void _executePlayerMove(String card, int row, int col) {
    List<String> parts = card.split(' of ');
    bool isJack = parts[0] == 'J';

    if (isJack) {
      String eyes = getEyes(parts[0], parts[1]);
      if (eyes == 'single eye') {
        // SINGLE-EYED JACK: Can only remove AI's chips (never player's chips)
        if (boardState[row][col] == 'ai') {
          boardState[row][col] = 'empty';
        }
      } else {
        // DOUBLE-EYED JACK: Can only place on empty spaces
        if (boardState[row][col] == 'empty') {
          boardState[row][col] = 'player';
        }
      }
    } else {
      // NORMAL CARD: Must match board position and be empty
      if (boardState[row][col] == 'empty') {
        boardState[row][col] = 'player';
      }
    }
    _addToHistory('You placed $card at (${row+1},${col+1})');

    playerHand.remove(card);
    checkForSequence('player');
  }

  void placeChip(int row, int col) {
    if (!isPlayerTurn || gameOver || _isWildSpot(row, col)) return;

    // First check for regular cards that match this position
    String? regularCardToPlay;
    for (String card in playerHand) {
      List<String> parts = card.split(' of ');
      if (parts[0] != 'J' &&
          cards[row * 10 + col]?.value == parts[0] &&
          cards[row * 10 + col]?.suit == parts[1] &&
          boardState[row][col] == 'empty') {
        regularCardToPlay = card;
        break;
      }
    }

    if (regularCardToPlay != null) {
      setState(() {
        _executePlayerMove(regularCardToPlay!, row, col);
        _checkUnplayableCards();
        if (!gameOver) {
          isPlayerTurn = false;
          drawCard();
          print(aiHand);
          Future.delayed(Duration(milliseconds: 500), () => aiMakeMove());
        }
      });
      return;
    }

    // Only check for Jacks if no regular card matches
    String? jackCardToPlay;
    for (String card in playerHand) {
      List<String> parts = card.split(' of ');
      if (parts[0] == 'J') {
        String eyes = getEyes(parts[0], parts[1]);
        if (eyes == 'single eye' && boardState[row][col] == 'ai') {
          jackCardToPlay = card;
          break;
        } else if (eyes == 'double eye' && boardState[row][col] == 'empty') {
          jackCardToPlay = card;
          break;
        }
      }
    }

    if (jackCardToPlay != null) {
      setState(() {
        _executePlayerMove(jackCardToPlay!, row, col);
        _checkUnplayableCards();
        if (!gameOver) {
          isPlayerTurn = false;
          drawCard();
          print(aiHand);
          Future.delayed(Duration(milliseconds: 500), () => aiMakeMove());
        }
      });
    }
  }

  void _checkUnplayableCards() {
    List<String> toRemove = [];
    for (String card in playerHand) {
      if (!_isCardPlayable(card)) {
        toRemove.add(card);
        droppedCard = card;
        showDroppedCard = true;
        Future.delayed(Duration(seconds: 1), () {
          setState(() => showDroppedCard = false);
        });
      }
    }

    if (toRemove.isNotEmpty) {
      setState(() {
        playerHand.removeWhere((card) => toRemove.contains(card));
        drawCard();
      });
    }
  }

  bool _isCardPlayable(String card) {
    List<String> parts = card.split(' of ');
    if (parts[0] == 'J') return true; // Jacks are always playable

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (cards[i * 10 + j]?.value == parts[0] &&
            cards[i * 10 + j]?.suit == parts[1] &&
            boardState[i][j] == 'empty') {
          return true;
        }
      }
    }
    return false;
  }

  void aiMakeMove() {
    if (gameOver) return;

    _handleDeadCards();

    Move bestMove = _findBestMove(3);

    if (bestMove.card != null && bestMove.row != null && bestMove.col != null) {
      setState(() {
        _executeAiMove(bestMove);
        checkForSequence('ai');

        if (!gameOver) {
          isPlayerTurn = true;
          drawCard();
          aiLastMove = null;
        }
      });
    }
  }

  void _executeAiMove(Move move) {
    setState(() {
      // Store the AI's last move information
      aiLastMovePosition = Point(move.row!, move.col!);
      aiLastMoveCard = move.card;
      showAiLastMove = true;

      // Rest of your existing move execution code
      aiMoveRow = move.row;
      aiMoveCol = move.col;
      List<String> parts = move.card!.split(' of ');
      bool isJack = parts[0] == 'J';

      if (isJack) {
        String eyes = getEyes(parts[0], parts[1]);
        if (eyes == 'single eye') {
          if (boardState[move.row!][move.col!] == 'player' &&
              !sequenceMarkers[move.row!][move.col!]) {
            boardState[move.row!][move.col!] = 'empty';
          }
        } else {
          if (boardState[move.row!][move.col!] == 'empty') {
            boardState[move.row!][move.col!] = 'ai';
          }
        }
      } else {
        if (boardState[move.row!][move.col!] == 'empty') {
          boardState[move.row!][move.col!] = 'ai';
        }
      }

      aiPlayedCard = move.card;
      showAiCard = true;
      aiHand.remove(move.card);
      _addToHistory('AI placed ${move.card} at (${move.row!+1},${move.col!+1})');

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          showAiCard = false;
        });
      });
    });
  }

  void _handleDeadCards() {
    List<String> toRemove = [];
    for (String card in aiHand) {
      if (!_isCardPlayable(card)) {
        toRemove.add(card);
        droppedCard = card;
        showDroppedCard = true;
        Future.delayed(Duration(seconds: 2), () {
          setState(() => showDroppedCard = false);
        });
      }
    }

    if (toRemove.isNotEmpty) {
      setState(() {
        aiHand.removeWhere((card) => toRemove.contains(card));
        drawCard();
      });
    }
  }

  Move _findBestMove(int depth) {
    int bestScore = -9999;
    Move bestMove = Move(null, null, null);
    int alpha = -9999;
    int beta = 9999;

    for (String card in aiHand) {
      List<Move> possibleMoves = _getPossibleMoves(card);

      for (Move move in possibleMoves) {
        _executeAiMoveSimulated(move);
        int score = _minimax(depth - 1, alpha, beta, false);
        _undoMove(move);

        if (score > bestScore) {
          bestScore = score;
          bestMove = move;
        }

        alpha = max(alpha, bestScore);
        if (beta <= alpha) break;
      }
    }

    return bestMove;
  }

  void _executeAiMoveSimulated(Move move) {
    List<String> parts = move.card!.split(' of ');
    bool isJack = parts[0] == 'J';

    if (isJack) {
      String eyes = getEyes(parts[0], parts[1]);
      if (eyes == 'single eye') {
        if (boardState[move.row!][move.col!] == 'player' &&
            !sequenceMarkers[move.row!][move.col!]) {
          boardState[move.row!][move.col!] = 'empty';
        }
      } else {
        if (boardState[move.row!][move.col!] == 'empty') {
          boardState[move.row!][move.col!] = 'ai';
        }
      }
    } else {
      if (boardState[move.row!][move.col!] == 'empty') {
        boardState[move.row!][move.col!] = 'ai';
      }
    }
  }

  void _undoMove(Move move) {
    List<String> parts = move.card!.split(' of ');
    bool isJack = parts[0] == 'J';

    if (isJack) {
      String eyes = getEyes(parts[0], parts[1]);
      if (eyes == 'single eye') {
        boardState[move.row!][move.col!] = 'player';
      } else {
        boardState[move.row!][move.col!] = 'empty';
      }
    } else {
      boardState[move.row!][move.col!] = 'empty';
    }
  }

  int _minimax(int depth, int alpha, int beta, bool isMaximizing) {
    if (depth == 0) return _evaluateBoard();

    if (isMaximizing) {
      int maxEval = -9999;
      for (String card in aiHand) {
        List<Move> possibleMoves = _getPossibleMoves(card);

        for (Move move in possibleMoves) {
          _executeAiMoveSimulated(move);
          int eval = _minimax(depth - 1, alpha, beta, false);
          _undoMove(move);

          maxEval = max(maxEval, eval);
          alpha = max(alpha, eval);
          if (beta <= alpha) break;
        }
      }
      return maxEval;
    } else {
      int minEval = 9999;
      for (String card in playerHand) {
        List<Move> possibleMoves = _getPossibleMoves(card);

        for (Move move in possibleMoves) {
          _executePlayerMoveSimulated(move);
          int eval = _minimax(depth - 1, alpha, beta, true);
          _undoMove(move);

          minEval = min(minEval, eval);
          beta = min(beta, eval);
          if (beta <= alpha) break;
        }
      }
      return minEval;
    }
  }

  void _executePlayerMoveSimulated(Move move) {
    List<String> parts = move.card!.split(' of ');
    bool isJack = parts[0] == 'J';

    if (isJack) {
      String eyes = getEyes(parts[0], parts[1]);
      if (eyes == 'single eye') {
        boardState[move.row!][move.col!] = 'empty';
      } else {
        boardState[move.row!][move.col!] = 'player';
      }
    } else {
      boardState[move.row!][move.col!] = 'player';
    }
  }

  List<Move> _getPossibleMoves(String card) {
    List<Move> moves = [];
    List<String> parts = card.split(' of ');
    bool isJack = parts[0] == 'J';

    if (isJack) {
      String eyes = getEyes(parts[0], parts[1]);
      if (eyes == 'single eye') {
        // Can only remove player's non-sequence chips
        for (int i = 0; i < 10; i++) {
          for (int j = 0; j < 10; j++) {
            if (boardState[i][j] == 'player' &&
                !sequenceMarkers[i][j] &&
                !_isWildSpot(i, j)) {
              moves.add(Move(card, i, j));
            }
          }
        }
      } else {
        // Double-eye Jack - can place on empty non-wild spots
        for (int i = 0; i < 10; i++) {
          for (int j = 0; j < 10; j++) {
            if (boardState[i][j] == 'empty' && !_isWildSpot(i, j)) {
              moves.add(Move(card, i, j));
            }
          }
        }
      }
    } else {
      // Normal card - find matching empty spots on board
      for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
          if (cards[i * 10 + j]?.value == parts[0] &&
              cards[i * 10 + j]?.suit == parts[1] &&
              boardState[i][j] == 'empty') {
            moves.add(Move(card, i, j));
          }
        }
      }
    }

    return moves;
  }

  int _evaluateBoard() {
    int score = 0;

    // Current sequences
    score += aiSequences * 1000;
    score -= playerSequences * 1000;

    // Potential sequences
    score += _countPotentialSequences('ai') * 100;
    score -= _countPotentialSequences('player') * 100;

    // Center control
    for (int i = 3; i < 7; i++) {
      for (int j = 3; j < 7; j++) {
        if (boardState[i][j] == 'ai') score += 10;
        if (boardState[i][j] == 'player') score -= 10;
      }
    }

    // Jack cards in hand
    int aiJacks = aiHand.where((c) => c.startsWith('J')).length;
    int playerJacks = playerHand.where((c) => c.startsWith('J')).length;
    score += aiJacks * 50;
    score -= playerJacks * 50;

    return score;
  }

  int _countPotentialSequences(String player) {
    int count = 0;

    // Check horizontal potential
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 6; j++) {
        int playerCount = 0;
        int emptyCount = 0;
        for (int k = 0; k < 5; k++) {
          if (boardState[i][j + k] == player) playerCount++;
          else if (boardState[i][j + k] == 'empty') emptyCount++;
        }
        if (playerCount == 4 && emptyCount == 1) count++;
        if (playerCount == 3 && emptyCount == 2) count++;
      }
    }

    // Check vertical potential
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 10; j++) {
        int playerCount = 0;
        int emptyCount = 0;
        for (int k = 0; k < 5; k++) {
          if (boardState[i + k][j] == player) playerCount++;
          else if (boardState[i + k][j] == 'empty') emptyCount++;
        }
        if (playerCount == 4 && emptyCount == 1) count++;
        if (playerCount == 3 && emptyCount == 2) count++;
      }
    }

    // Check diagonal potential (top-left to bottom-right)
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        int playerCount = 0;
        int emptyCount = 0;
        for (int k = 0; k < 5; k++) {
          if (boardState[i + k][j + k] == player) playerCount++;
          else if (boardState[i + k][j + k] == 'empty') emptyCount++;
        }
        if (playerCount == 4 && emptyCount == 1) count++;
        if (playerCount == 3 && emptyCount == 2) count++;
      }
    }

    // Check diagonal potential (top-right to bottom-left)
    for (int i = 0; i < 6; i++) {
      for (int j = 4; j < 10; j++) {
        int playerCount = 0;
        int emptyCount = 0;
        for (int k = 0; k < 5; k++) {
          if (boardState[i + k][j - k] == player) playerCount++;
          else if (boardState[i + k][j - k] == 'empty') emptyCount++;
        }
        if (playerCount == 4 && emptyCount == 1) count++;
        if (playerCount == 3 && emptyCount == 2) count++;
      }
    }

    return count;
  }

  int _evaluateMove(Move move) {
    int score = 0;

    // Check if this move would complete a sequence
    if (_wouldCompleteSequence(move, 'ai')) score += 500;

    // Prefer center positions
    double centerDist = (move.row! - 4.5).abs() + (move.col! - 4.5).abs();
    score += (9 - centerDist).toInt();

    // High value for removing opponent's sequence chips with single-eye Jack
    List<String> parts = move.card!.split(' of ');
    if (parts[0] == 'J' && getEyes(parts[0], parts[1]) == 'single eye') {
      if (sequenceMarkers[move.row!][move.col!]) {
        score += 300;
      }
    }

    return score;
  }

  bool _wouldCompleteSequence(Move move, String player) {
    // Temporarily place the chip
    boardState[move.row!][move.col!] = player;

    // Check all directions
    bool wouldComplete = _checkSequenceAt(move.row!, move.col!, player);

    // Undo the temporary placement
    boardState[move.row!][move.col!] = 'empty';

    return wouldComplete;
  }

  bool _checkSequenceAt(int row, int col, String player) {
    // Check horizontal
    int left = max(0, col - 4);
    int right = min(9, col + 4);
    for (int i = left; i <= right - 4; i++) {
      if (_checkFiveInARow(row, i, 0, 1, player)) return true;
    }

    // Check vertical
    int top = max(0, row - 4);
    int bottom = min(9, row + 4);
    for (int i = top; i <= bottom - 4; i++) {
      if (_checkFiveInARow(i, col, 1, 0, player)) return true;
    }

    // Check diagonal (top-left to bottom-right)
    int startOffset = min(row, col);
    int startRow = row - startOffset;
    int startCol = col - startOffset;
    while (startRow <= 5 && startCol <= 5 && startRow >= 0 && startCol >= 0) {
      if (_checkFiveInARow(startRow, startCol, 1, 1, player)) return true;
      startRow++;
      startCol++;
    }

    // Check diagonal (top-right to bottom-left)
    startOffset = min(row, 9 - col);
    startRow = row - startOffset;
    startCol = col + startOffset;
    while (startRow <= 5 && startCol >= 4 && startRow >= 0 && startCol <= 9) {
      if (_checkFiveInARow(startRow, startCol, 1, -1, player)) return true;
      startRow++;
      startCol--;
    }

    return false;
  }

  bool _checkFiveInARow(int startRow, int startCol, int rowStep, int colStep, String player) {
    for (int i = 0; i < 5; i++) {
      int row = startRow + i * rowStep;
      int col = startCol + i * colStep;

      // Wild corner counts for both players
      if (_isWildSpot(row, col)) {
        continue;
      }

      if (boardState[row][col] != player && boardState[row][col] != 'wild') {
        return false;
      }
    }
    return true;
  }
  void checkForSequence(String player) {
    int newSequences = 0;
    List<List<bool>> newSequenceMarkers = List.generate(10, (_) => List.filled(10, false));

    // Check all possible sequences
    List<List<Point>> allSequences = [];

    // Check horizontal sequences
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 6; j++) {
        List<Point> sequence = [];
        int playerCount = 0;
        bool hasWild = false;

        for (int k = 0; k < 5; k++) {
          if (boardState[i][j + k] == player ||
              (sequenceMarkers[i][j + k] && boardState[i][j + k] == player)) {
            sequence.add(Point(i, j + k));
            playerCount++;
          } else if (_isWildSpot(i, j + k)) {
            hasWild = true;
          } else {
            break;
          }
        }

        if (playerCount + (hasWild ? 1 : 0) >= 5) {
          allSequences.add(sequence);
        }
      }
    }

    // Check vertical sequences
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 10; j++) {
        List<Point> sequence = [];
        int playerCount = 0;
        bool hasWild = false;

        for (int k = 0; k < 5; k++) {
          if (boardState[i + k][j] == player ||
              (sequenceMarkers[i + k][j] && boardState[i + k][j] == player)) {
            sequence.add(Point(i + k, j));
            playerCount++;
          } else if (_isWildSpot(i + k, j)) {
            hasWild = true;
          } else {
            break;
          }
        }

        if (playerCount + (hasWild ? 1 : 0) >= 5) {
          allSequences.add(sequence);
        }
      }
    }

    // Check diagonal (top-left to bottom-right)
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        List<Point> sequence = [];
        int playerCount = 0;
        bool hasWild = false;

        for (int k = 0; k < 5; k++) {
          if (boardState[i + k][j + k] == player ||
              (sequenceMarkers[i + k][j + k] && boardState[i + k][j + k] == player)) {
            sequence.add(Point(i + k, j + k));
            playerCount++;
          } else if (_isWildSpot(i + k, j + k)) {
            hasWild = true;
          } else {
            break;
          }
        }

        if (playerCount + (hasWild ? 1 : 0) >= 5) {
          allSequences.add(sequence);
        }
      }
    }

    // Check diagonal (top-right to bottom-left)
    for (int i = 0; i < 6; i++) {
      for (int j = 4; j < 10; j++) {
        List<Point> sequence = [];
        int playerCount = 0;
        bool hasWild = false;

        for (int k = 0; k < 5; k++) {
          if (boardState[i + k][j - k] == player ||
              (sequenceMarkers[i + k][j - k] && boardState[i + k][j - k] == player)) {
            sequence.add(Point(i + k, j - k));
            playerCount++;
          } else if (_isWildSpot(i + k, j - k)) {
            hasWild = true;
          } else {
            break;
          }
        }

        if (playerCount + (hasWild ? 1 : 0) >= 5) {
          allSequences.add(sequence);
        }
      }
    }

    // Process found sequences
    for (var sequence in allSequences) {
      // Check if this sequence shares more than one chip with existing sequences
      int sharedChips = 0;
      for (var point in sequence) {
        if (sequenceMarkers[point.x][point.y]) {
          sharedChips++;
        }
      }

      if (sharedChips <= 1) { // Allow only one shared chip between sequences
        newSequences++;
        for (var point in sequence) {
          newSequenceMarkers[point.x][point.y] = true;
        }
      }
    }

    setState(() {
      sequenceMarkers = newSequenceMarkers;
      // Mark wild corners as part of sequences if they're adjacent to player's chips
      _markWildCorners(player);

      if (player == 'player') {
        playerSequences = newSequences;
      } else {
        aiSequences = newSequences;
      }

      if (playerSequences >= 2 || aiSequences >= 2) {
        gameOver = true;
        winner = playerSequences >= 2 ? 'Player' : 'AI';
        _showWinnerDialog();
      }
    });
  }

  void _markWildCorners(String player) {
    // Check each wild corner to see if it should be part of a sequence
    List<Point> wildCorners = [Point(0,0), Point(0,9), Point(9,0), Point(9,9)];

    for (var corner in wildCorners) {
      bool shouldMark = false;

      // Check adjacent positions
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          if (i == 0 && j == 0) continue; // Skip the corner itself

          int x = corner.x + i;
          int y = corner.y + j;

          if (x >= 0 && x < 10 && y >= 0 && y < 10) {
            if (boardState[x][y] == player && sequenceMarkers[x][y]) {
              shouldMark = true;
              break;
            }
          }
        }
        if (shouldMark) break;
      }

      if (shouldMark) {
        sequenceMarkers[corner.x][corner.y] = true;
      }
    }
  }

  void _showGameDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Details',
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Current Turn', isPlayerTurn ? 'Your Turn' : 'AI Turn',
                    isPlayerTurn ? Icons.person : Icons.computer,
                    isPlayerTurn ? Colors.blue : Colors.red
                ),
                Divider(),
                _buildDetailItem('Your Sequences', '$playerSequences', Icons.star, Colors.blue),
                _buildDetailItem('AI Sequences', '$aiSequences', Icons.star, Colors.red),
                Divider(),
                _buildDetailItem('Cards Left', '$remainingCards', Icons.deck, Colors.deepPurple),
                _buildDetailItem('Cards in Your Hand', '${playerHand.length}', Icons.credit_card, Colors.green),
                _buildDetailItem('Cards in AI Hand', '${aiHand.length}', Icons.credit_card, Colors.orange),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white.withOpacity(0.95),
          elevation: 10,
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.deepPurple)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          content: Text('$winner wins the game!'),
          actions: <Widget>[
            TextButton(
              child: Text('New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      initializeDeck();
      dealCards();
      boardState = List.generate(10, (_) => List.filled(10, 'empty'));
      _initializeWildSpots();
      playerSequences = 0;
      aiSequences = 0;
      isPlayerTurn = true;
      gameOver = false;
      winner = '';
      sequenceMarkers = List.generate(10, (_) => List.filled(10, false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sequence Game', style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetGame,
            tooltip: 'New Game',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade100,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      int row = index ~/ 10;
                      int col = index % 10;
                      bool isWild = _isWildSpot(row, col);
                      bool isHighlighted = highlightedSpots.any((point) => point.x == row && point.y == col) &&
                          isPlayerTurn &&
                          !gameOver;

                      // Check if this is the AI's last move position
                      bool isAiLastMove = showAiLastMove &&
                          aiLastMovePosition != null &&
                          aiLastMovePosition!.x == row &&
                          aiLastMovePosition!.y == col;

                      return GestureDetector(
                        onTap: () => placeChip(row, col),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isHighlighted
                                ? Colors.yellow.withOpacity(0.3)
                                : isAiLastMove
                                ? Colors.red.withOpacity(1)
                                : Colors.white,
                            border: isHighlighted
                                ? Border.all(color: Colors.yellow, width: 2)
                                : isAiLastMove
                                ? Border.all(color: Colors.red, width: 2)
                                : null,
                          ),
                          child: Stack(
                            children: [
                              CardCell(
                                card: cards[index],
                                size: cellSize,
                              ),
                              if (isWild)
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              if (boardState[row][col] == 'player')
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 2),
                                      ),
                                      child: Icon(
                                        Icons.circle,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              if (boardState[row][col] == 'ai')
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 2),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              if (sequenceMarkers[row][col])
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: boardState[row][col] == 'player'
                                            ? Colors.blue.withOpacity(0.5)
                                            : Colors.red.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showGameDetails,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Your Hand',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 5,
                          runSpacing: 5,
                          children: playerHand.map((card) =>
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentCard = card;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: currentCard == card
                                          ? Colors.yellow
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: _buildPlayerCardItem(card),
                                ),
                              ),
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx > 5) { // Swiped right
                    if (!_showHistory) _toggleHistory();
                  } else if (details.delta.dx < -5) { // Swiped left
                    if (_showHistory) _toggleHistory();
                  }
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-0.5, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutQuart,
                      )),
                      child: child,
                    );
                  },
                  child: Column(
                    key: ValueKey<bool>(_showHistory),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arrow button to toggle history
                      GestureDetector(
                        onTap: _toggleHistory,
                        onPanUpdate: (details) {
                          // Allow swiping on the arrow button too
                          if (details.delta.dx > 5 && !_showHistory) _toggleHistory();
                          else if (details.delta.dx < -5 && _showHistory) _toggleHistory();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Icon(
                            _showHistory ? Icons.arrow_left : Icons.arrow_right,
                            color: Colors.deepPurple[800],
                            size: 30,
                          ),
                        ),
                      ),

                      // History panel
                      if (_showHistory)
                        Container(
                          width: 220,
                          constraints: BoxConstraints(maxHeight: 300),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            border: Border.all(
                              color: Colors.deepPurple.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(right: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Move History',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple[800],
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.history,
                                    size: 18,
                                    color: Colors.deepPurple[400],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              if (moveHistory.isEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'No moves yet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                )
                              else
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: moveHistory.asMap().entries.map((entry) =>
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: entry.key % 2 == 0
                                                  ? Colors.deepPurple.withOpacity(0.05)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 6,
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              '${entry.key + 1}. ${entry.value}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                      ).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20, // Changed from 550 to 10 to move to top left
              left: 150,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        SizedBox(width: 4),
                        Text(
                          isPlayerTurn ? 'Your turn' : 'AI thinking...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isPlayerTurn ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (showAiCard && aiPlayedCard != null)
              Center(
                child: ScaleTransition(
                  scale: AlwaysStoppedAnimation(1.5),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.red.shade100,
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AI played:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 15),
                          _buildAiCard(),
                          SizedBox(height: 15),
                          Text(
                            getEyes(aiPlayedCard!.split(' of ')[0], aiPlayedCard!.split(' of ')[1]) == 'single eye'
                                ? 'Removed ${cards[aiMoveRow! * 10 + aiMoveCol!]?.value} of ${cards[aiMoveRow! * 10 + aiMoveCol!]?.suit}'
                                : 'Placed on ${cards[aiMoveRow! * 10 + aiMoveCol!]?.value} of ${cards[aiMoveRow! * 10 + aiMoveCol!]?.suit}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            if (showDroppedCard && droppedCard != null)
              Center(
                child: ScaleTransition(
                  scale: AlwaysStoppedAnimation(1.2),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade100,
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Dropped card:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 15),
                          _buildDroppedCard(),
                          SizedBox(height: 10),
                          Text(
                            'No valid moves for this card',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, int sequences, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '$label: $sequences sequence${sequences != 1 ? 's' : ''}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPlayerCardItem(String card) {
    List<String> parts = card.split(' of ');
    return PlayingCard(
      suit: parts[1],
      value: parts[0],
      eyes: getEyes(parts[0], parts[1]),
      valueSize: 14,
      isSmall: true,
    ).buildCard(40);
  }

  Widget _buildPlayerCard(int index) {
    List<String> parts = playerHand[index].split(' of ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: PlayingCard(
        suit: parts[1],
        value: parts[0],
        eyes: getEyes(parts[0], parts[1]),
        valueSize: 16,
      ).buildCard(45),
    );
  }

  Widget _buildAiCard() {
    List<String> parts = aiPlayedCard!.split(' of ');
    return PlayingCard(
      suit: parts[1],
      value: parts[0],
      eyes: getEyes(parts[0], parts[1]),
      valueSize: 24,
    ).buildCard(80);
  }

  Widget _buildDroppedCard() {
    List<String> parts = droppedCard!.split(' of ');
    return PlayingCard(
      suit: parts[1],
      value: parts[0],
      eyes: getEyes(parts[0], parts[1]),
      valueSize: 20,
    ).buildCard(60);
  }

  String getEyes(String value, String suit) {
    if (value == 'J') {
      return suit == 'clubs' || suit == 'diamonds' ? 'double eye' : 'single eye';
    }
    return 'nil';
  }
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}

class Move {
  final String? card;
  final int? row;
  final int? col;

  Move(this.card, this.row, this.col);
}