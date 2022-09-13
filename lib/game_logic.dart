import 'dart:math';

class Player {
  static const xTile = 'X';
  static const oTile = 'O';
  static const emptyTile = '';
  static List<int> playerX = [];
  static List<int> playerO = [];
}

class Game {
  void playGame(index, String activePlayer) {
    if (activePlayer == "X") {
      Player.playerX.add(index);
    } else {
      Player.playerO.add(index);
    }
  }

  checkRows(myPlayer) {
    if ((myPlayer.contains(0) &&
            myPlayer.contains(1) &&
            myPlayer.contains(2)) ||
        (myPlayer.contains(3) &&
            myPlayer.contains(4) &&
            myPlayer.contains(5)) ||
        (myPlayer.contains(6) &&
            myPlayer.contains(7) &&
            myPlayer.contains(8))) {
      return true;
    }
    return false;
  }

  checkColumns(myPlayer) {
    if ((myPlayer.contains(0) &&
            myPlayer.contains(3) &&
            myPlayer.contains(6)) ||
        (myPlayer.contains(1) &&
            myPlayer.contains(4) &&
            myPlayer.contains(7)) ||
        (myPlayer.contains(2) &&
            myPlayer.contains(5) &&
            myPlayer.contains(8))) {
      return true;
    }
    return false;
  }

  checkDiagonals(myPlayer) {
    if ((myPlayer.contains(0) &&
            myPlayer.contains(4) &&
            myPlayer.contains(8)) ||
        (myPlayer.contains(2) &&
            myPlayer.contains(4) &&
            myPlayer.contains(6))) {
      return true;
    }
    return false;
  }

  checkWinner(activePlayer) {
    List<int> currentPlayer = [];
    if (activePlayer == 'X') {
      currentPlayer = List.from(Player.playerX);
    } else {
      currentPlayer = List.from(Player.playerO);
    }
    if (checkColumns(currentPlayer) ||
        checkRows(currentPlayer) ||
        checkDiagonals(currentPlayer)) {
      return 1; //a player won so game over
    }
    if (Player.playerX.length + Player.playerO.length == 9) {
      return 2; //draw so game over
    }
    return 0; //resuming game
  }

  advancedSelect(currentPlayer,emptyCells){
    var set = Set.of(currentPlayer);
    int index;
    int flag=0;
    //start mid empty
    if (set.containsAll([0, 1]) && emptyCells.contains(2)) {
      index = 2;
    } else if (set.containsAll([3, 4]) && emptyCells.contains(5)) {
      index = 5;
    } else if (set.containsAll([6, 7]) && emptyCells.contains(8)) {
      index = 8;
    } else if (set.containsAll([0, 3]) && emptyCells.contains(6)) {
      index = 6;
    } else if (set.containsAll([1, 4]) && emptyCells.contains(7)) {
      index = 7;
    } else if (set.containsAll([2, 5]) && emptyCells.contains(8)) {
      index = 8;
    } else if (set.containsAll([0, 4]) && emptyCells.contains(8)) {
      index = 8;
    } else if (set.containsAll([2, 4]) && emptyCells.contains(6)) {
      index = 6;
    }

    //start empty end
    else if (set.containsAll([0, 2]) && emptyCells.contains(1)) {
      index = 1;
    } else if (set.containsAll([3, 5]) && emptyCells.contains(4)) {
      index = 4;
    } else if (set.containsAll([6, 8]) && emptyCells.contains(7)) {
      index = 7;
    } else if (set.containsAll([0, 6]) && emptyCells.contains(3)) {
      index = 3;
    } else if (set.containsAll([1, 7]) && emptyCells.contains(4)) {
      index = 4;
    } else if (set.containsAll([2, 8]) && emptyCells.contains(5)) {
      index = 5;
    } else if (set.containsAll([0, 8]) && emptyCells.contains(4)) {
      index = 4;
    } else if (set.containsAll([2, 6]) && emptyCells.contains(4)) {
      index = 4;
    }

    //empty mid end
    else if (set.containsAll([1, 2]) && emptyCells.contains(0)) {
      index = 0;
    } else if (set.containsAll([4, 5]) && emptyCells.contains(3)) {
      index = 3;
    } else if (set.containsAll([7, 8]) && emptyCells.contains(6)) {
      index = 6;
    } else if (set.containsAll([3, 6]) && emptyCells.contains(0)) {
      index = 0;
    } else if (set.containsAll([4, 7]) && emptyCells.contains(1)) {
      index = 1;
    } else if (set.containsAll([5, 8]) && emptyCells.contains(2)) {
      index = 2;
    } else if (set.containsAll([4, 8]) && emptyCells.contains(0)) {
      index = 0;
    } else if (set.containsAll([4, 6]) && emptyCells.contains(2)) {
      index = 2;
    } else {
      flag=1;
      Random random = Random();
      // random.nextInt(emptyCells.length);
      int randomIndex = random.nextInt(emptyCells.length);
      index = emptyCells[randomIndex];
    }
    return [flag,index];
  }

  Future<void> autoPlay(activePlayer) async {
    int index;
    List<int> emptyCells = [];
    for (var i = 0; i < 9; i++) {
      if (!Player.playerX.contains(i) && !Player.playerO.contains(i)) {
        emptyCells.add(i);
      }
    }

    if (emptyCells.isEmpty) {
      return;
    }

    List<int> currentPlayer = activePlayer == 'X'
        ? List.from(Player.playerX)
        : List.from(Player.playerO);
    List temp=advancedSelect(currentPlayer, emptyCells);
    if(temp[0]==1) {
      currentPlayer = activePlayer == 'X'
          ? List.from(Player.playerO)
          : List.from(Player.playerX);
      index=advancedSelect(currentPlayer, emptyCells)[1];
    }else{
      index=temp[1];
    }
    playGame(index, activePlayer);
  }
}
