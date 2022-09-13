import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac/game_logic.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String activePlayer;
  bool gameOver = false;
  Random rand = Random();

  String result = "";

  Game game = Game();

  bool isSwitched = false;

  @override
  void initState() {
    // TODO: implement initState

    activePlayer = rand.nextInt(100) % 2 == 0 ? 'X' : 'O';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:   MediaQuery.of(context).orientation == Orientation.portrait? SafeArea(
        child: Column(
          children: [
            SwitchListTile.adaptive(
                title: const Text(
                  "Turn on/off two player",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                value: isSwitched,
                onChanged: (bool newValue) {
                  setState(() {
                    Player.playerX = [];
                    Player.playerO = [];
                    activePlayer = rand.nextInt(100) % 2 == 0 ? 'X' : 'O';
                    gameOver = false;
                    // turn = 0;
                    result = "";
                    isSwitched = newValue;
                  });
                }),
            Text(
              "Its's $activePlayer turn",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 52, color: Colors.white),
            ),
            Expanded(
                child: GridView.count(
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
              crossAxisCount: 3,
              children: List.generate(
                  9,
                  (index) => InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: gameOver ? null : () => _onTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                              child: Text(
                            Player.playerX.contains(index)
                                ? 'X'
                                : Player.playerO.contains(index)
                                    ? 'O'
                                    : "",
                            style: TextStyle(
                                color: Player.playerX.contains(index)
                                    ? Colors.blue
                                    : Colors.pink,
                                fontSize: 52),
                          )),
                        ),
                      )),
            )),
            Text(
              "$result",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 52, color: Colors.white),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  Player.playerX = [];
                  Player.playerO = [];
                  activePlayer = rand.nextInt(100) % 2 == 0 ? 'X' : 'O';
                  gameOver = false;
                  // turn = 0;
                  result = "";
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text("Repeat the game"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).splashColor)),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ):
      SafeArea(
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SwitchListTile.adaptive(
                      title: const Text(
                        "Turn on/off two player",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      value: isSwitched,
                      onChanged: (bool newValue) {
                        setState(() {
                          Player.playerX = [];
                          Player.playerO = [];
                          activePlayer = rand.nextInt(100) % 2 == 0 ? 'X' : 'O';
                          gameOver = false;
                          // turn = 0;
                          result = "";
                          isSwitched = newValue;
                        });
                      }),
                  Text(
                    "Its's $activePlayer turn",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 52, color: Colors.white),
                  ),

                  Text(
                    "$result",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 52, color: Colors.white),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        Player.playerX = [];
                        Player.playerO = [];
                        activePlayer = rand.nextInt(100) % 2 == 0 ? 'X' : 'O';
                        gameOver = false;
                        // turn = 0;
                        result = "";
                      });
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text("Repeat the game"),
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).splashColor)),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                  crossAxisCount: 3,
                  children: List.generate(
                      9,
                          (index) => InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: gameOver ? null : () => _onTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                              child: Text(
                                Player.playerX.contains(index)
                                    ? 'X'
                                    : Player.playerO.contains(index)
                                    ? 'O'
                                    : "",
                                style: TextStyle(
                                    color: Player.playerX.contains(index)
                                        ? Colors.blue
                                        : Colors.pink,
                                    fontSize: 52),
                              )),
                        ),
                      )),
                )),
          ],
        ),
      )
      ,
    );
  }

  _onTap(index) async {
    if (Player.playerX.contains(index) || Player.playerO.contains(index)) {
      return;
    }
    game.playGame(index, activePlayer);
    updateState();
    if (!isSwitched && !gameOver) {
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  void updateState() {
    setState(() {
      int checkWinCond = game.checkWinner(activePlayer);
      if (checkWinCond > 0) {
        gameOver = true;
        if (checkWinCond == 1)
          result = "$activePlayer has Won";
        else {
          result = "It's a draw";
        }
      }
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
    });
  }
}
