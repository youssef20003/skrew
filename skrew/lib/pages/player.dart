import 'package:flutter/material.dart';

class Player {
  String name;
  int r1;
  int r2;
  int r3;
  int r4;

  Player({
    required this.name,
    this.r1 = 0,
    this.r2 = 0,
    this.r3 = 0,
    this.r4 = 0,
  });

  int get totalScore => r1 + r2 + r3 + r4;
}

class PlayerPage extends StatefulWidget {
  final List<Player> players;

  const PlayerPage({Key? key, required this.players}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Map<int, List<TextEditingController>> _roundControllers;
  int _currentRound = 1;
  bool _isAllRoundsFinished = false;

  @override
  void initState() {
    super.initState();
    _roundControllers = {};
    for (int i = 0; i < widget.players.length; i++) {
      _roundControllers[i] = [
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ];
    }
  }

  void _updateRoundScores(int playerIndex, int round) {
    final controller = _roundControllers[playerIndex]![round - 1];
    final score = int.tryParse(controller.text) ?? 0;
    setState(() {
      if (round == 1) {
        widget.players[playerIndex].r1 = score;
      } else if (round == 2) {
        widget.players[playerIndex].r2 = score;
      } else if (round == 3) {
        widget.players[playerIndex].r3 = score;
      } else if (round == 4) {
        widget.players[playerIndex].r4 = score;
      }
    });
  }

  void _moveToNextRound() {
    setState(() {
      if (_currentRound < 4) {
        _currentRound++;
      }
    });
  }

  void _replaceSmallestInRound() {
    List<int> roundScores = [];
    for (int i = 0; i < widget.players.length; i++) {
      roundScores.add(
        _currentRound == 1
            ? widget.players[i].r1
            : _currentRound == 2
                ? widget.players[i].r2
                : _currentRound == 3
                    ? widget.players[i].r3
                    : widget.players[i].r4,
      );
    }

    int minScore = roundScores.reduce((a, b) => a < b ? a : b);
    int minScoreIndex = roundScores.indexOf(minScore);

    setState(() {
      if (_currentRound == 1) {
        widget.players[minScoreIndex].r1 = 0;
      } else if (_currentRound == 2) {
        widget.players[minScoreIndex].r2 = 0;
      } else if (_currentRound == 3) {
        widget.players[minScoreIndex].r3 = 0;
      } else if (_currentRound == 4) {
        widget.players[minScoreIndex].r4 = 0;
      }
    });

    _roundControllers[minScoreIndex]![(_currentRound - 1)].text = "0";
  }

  String _getWinner() {
    widget.players.sort((a, b) => a.totalScore.compareTo(b.totalScore));
    return widget.players.isNotEmpty ? widget.players[0].name : '';
  }

  void _finishRound4() {
    setState(() {
      _isAllRoundsFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Players'),
      ),
      body: widget.players.isEmpty
          ? const Center(
              child: Text(
                'No players to display',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Player Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'R1',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'R2',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'R3',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'R4',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      final player = widget.players[index];
                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  player.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _roundControllers[index]![0],
                                  decoration: const InputDecoration(
                                    labelText: 'R1',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _updateRoundScores(index, 1);
                                    }
                                  },
                                  enabled: _currentRound == 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _roundControllers[index]![1],
                                  decoration: const InputDecoration(
                                    labelText: 'R2',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _updateRoundScores(index, 2);
                                    }
                                  },
                                  enabled: _currentRound == 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _roundControllers[index]![2],
                                  decoration: const InputDecoration(
                                    labelText: 'R3',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _updateRoundScores(index, 3);
                                    }
                                  },
                                  enabled: _currentRound == 3,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _roundControllers[index]![3],
                                  decoration: const InputDecoration(
                                    labelText: 'R4',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _updateRoundScores(index, 4);
                                    }
                                  },
                                  enabled: _currentRound == 4,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${player.totalScore}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentRound == 4) {
                        _finishRound4();
                      } else {
                        _replaceSmallestInRound();
                        _moveToNextRound();
                      }
                    },
                    child: Text(_currentRound < 4
                        ? 'Finish Round $_currentRound'
                        : 'All Rounds Finished'),
                  ),
                ),
                if (_isAllRoundsFinished)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Winner: ${_getWinner()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
