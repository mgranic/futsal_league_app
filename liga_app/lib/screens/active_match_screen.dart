import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liga_app/shared_preferences_mgr/shared_preferences_handler.dart';

import '../database_mgr/continue_match_data.dart';
import '../database_mgr/game_log_entry.dart';
import '../database_mgr/player.dart';
import '../server_communication/new_match_data.dart';
import 'home_screen.dart';

class ActiveMatchScreen extends StatefulWidget {
  late List<Player?> _selectedHomePlayers;
  late List<Player?> _selectedAwayPlayers;
  late String selectedHomeTeam;
  late String selectedAwayTeam;
  bool continueMatch = false;
  Player? goalScorer;
  Player? assistMaker;

  ActiveMatchScreen.continueMatch() {
    continueMatch = true;
    _selectedHomePlayers = <Player?>[];
    _selectedAwayPlayers = <Player?>[];
    selectedHomeTeam = 't1';
    selectedAwayTeam = 't2';
  }

  ActiveMatchScreen(this.selectedHomeTeam, this.selectedAwayTeam,
      this._selectedHomePlayers, this._selectedAwayPlayers, this.continueMatch);

  //final String title;
  @override
  State<ActiveMatchScreen> createState() => _ActiveMatchScreenState(
      selectedHomeTeam,
      selectedAwayTeam,
      _selectedHomePlayers,
      _selectedAwayPlayers,
      continueMatch);
}

class _ActiveMatchScreenState extends State<ActiveMatchScreen> {
  late List<Player?> _selectedHomePlayers;
  late List<Player?> _selectedAwayPlayers;
  late String selectedHomeTeam;
  late String selectedAwayTeam;
  late List<String> _selectedHomePlayersName;
  late List<String> _selectedAwayPlayersName;
  bool continueMatch = false;
  String goalScorer = SELECT_PLAYER;
  String assistMaker = SELECT_PLAYER;
  bool isOwnGoal = false;

  /// 0 if there is no action
  /// 1 if it is home team
  /// 2 if it is away team
  int homeAwayTeamAction = 0;

  //static const countdownDuration = Duration(minutes: 10);
  Duration duration = const Duration();
  Timer? timer;
  int homeScore = 0;
  int awayScore = 0;

  late List<Text> mLog;

  _ActiveMatchScreenState(
      this.selectedHomeTeam,
      this.selectedAwayTeam,
      this._selectedHomePlayers,
      this._selectedAwayPlayers,
      this.continueMatch) {
    mLog = <Text>[];
    _selectedHomePlayersName = <String>[];
    _selectedAwayPlayersName = <String>[];
    _selectedHomePlayersName.add(SELECT_PLAYER);
    _selectedAwayPlayersName.add(SELECT_PLAYER);

    if (continueMatch == true) {
      // read data from DB
      ContinueMatchData cmData = ContinueMatchData();

      this.selectedHomeTeam = ContinueMatchData.homeTeam;
      this.selectedAwayTeam = ContinueMatchData.awayTeam;

      homeScore = ContinueMatchData.homeScore;
      awayScore = ContinueMatchData.awayScore;

      duration = Duration(seconds: ContinueMatchData.matchTime);
      _startTimer();

      for (int i = 0; i < ContinueMatchData.homeTeamPlayersList.length; i++) {
        _selectedHomePlayersName
            .add(ContinueMatchData.homeTeamPlayersList[i]!.name);
      }

      for (int i = 0; i < ContinueMatchData.awayTeamPlayersList.length; i++) {
        _selectedAwayPlayersName
            .add(ContinueMatchData.awayTeamPlayersList[i]!.name);
      }
      for (int i = 0; i < ContinueMatchData.matchLogHistory.length; i++) {
        if (ContinueMatchData.matchLogHistory[i].player.name != 'N/A') {
          _matchLog(
              ContinueMatchData.matchLogHistory[i].eventType,
              ContinueMatchData.matchLogHistory[i].teamName,
              ContinueMatchData.matchLogHistory[i].secs,
              player: ContinueMatchData.matchLogHistory[i].player.name,
              result: ContinueMatchData.matchLogHistory[i].result);
        } else {
          _matchLog(
              ContinueMatchData.matchLogHistory[i].eventType,
              ContinueMatchData.matchLogHistory[i].teamName,
              ContinueMatchData.matchLogHistory[i].secs);
        }
      }
      return;
    }

    for (int i = 0; i < _selectedHomePlayers.length; i++) {
      _selectedHomePlayersName.add(_selectedHomePlayers[i]!.name);
    }

    for (int i = 0; i < _selectedAwayPlayers.length; i++) {
      _selectedAwayPlayersName.add(_selectedAwayPlayers[i]!.name);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stopTimer(resets: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zidić Liga'),
      ),
      body: Center(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Column(
                    children: [
                      _buildTime(),
                      SizedBox(
                        height: 12,
                      ),
                      _buildButtons()
                    ],
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                children: [
                  Text(
                    selectedHomeTeam,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      homeScore.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 50),
                    ),
                  ),
                ],
              ),
              const VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 20,
                endIndent: 0,
                color: Colors.grey,
              ),
              Column(
                children: [
                  Text(selectedAwayTeam,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20)),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      awayScore.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 50),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SingleChildScrollView(
              //child: Column (
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _handleGoalAction(selectedHomeTeam, true);
                      },
                      child: Text('Home Goal')),
                  ElevatedButton(
                      onPressed: () {
                        _handleShootAction(selectedHomeTeam, true);
                      },
                      child: Text('Home Shoot'))
                ],
              ),
              //),
              const VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 20,
                endIndent: 0,
                color: Colors.grey,
              ),
              Column(
                //SingleChildScrollView(
                //child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _handleGoalAction(selectedAwayTeam, false);
                      },
                      child: Text('Away Goal')),
                  ElevatedButton(
                      onPressed: () {
                        _handleShootAction(selectedAwayTeam, false);
                      },
                      child: Text('Away Shoot'))
                ],
                //),
              )
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: mLog,
            ),
          )),
          ElevatedButton(
              onPressed: _handleEndMatchAction, child: Text('End match'))
        ],
      )),
    );
  }

  /// construct dialog box to register new goal and/or assist
  void _handleGoalAction(String teamName, bool isHomeTeam) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: 10.0,
              ),
              title: Text(
                "$teamName goal",
                style: TextStyle(fontSize: 24.0),
              ),
              content: Container(
                height: 400,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        SELECT_GOAL_SCORRER,
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Container(
                        child: DropdownButton(
                          // Initial Value
                          value: goalScorer,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: _getHomeAwayPlayerList(isHomeTeam)
                              .map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              goalScorer = newValue!;
                            });
                          },
                        ),
                      ),
                      Text(
                        SELECT_ASSIST_MAKER,
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          // Initial Value
                          value: assistMaker,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: _getHomeAwayPlayerList(isHomeTeam)
                              .map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              assistMaker = newValue!;
                            });
                          },
                        ),
                      ),
                      Text(
                        "Is it own goal?",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          checkColor: Colors.white,
                          //fillColor: MaterialStateProperty.resolveWith(Colors.blue),
                          value: isOwnGoal,
                          onChanged: (bool? value) {
                            setState(() {
                              isOwnGoal = value!;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            String logEvent = '';
                            int logTime = 0;
                            if (goalScorer != SELECT_PLAYER) {
                              if (isHomeTeam == true) {
                                if (isOwnGoal != true) {
                                  ++homeScore;
                                } else {
                                  ++awayScore;
                                  isOwnGoal = true;
                                }
                              } else {
                                if (isOwnGoal != true) {
                                  ++awayScore;
                                } else {
                                  ++homeScore;
                                  isOwnGoal = true;
                                }
                              }
                            }

                            if (isOwnGoal) {
                              logEvent = OWN_GOAL;
                            } else {
                              logEvent = GOAL;
                            }

                            if (goalScorer != SELECT_PLAYER) {
                              _matchLog(logEvent, teamName, duration.inSeconds,
                                  player: goalScorer,
                                  result: '$homeScore : $awayScore');
                            }

                            if (assistMaker != SELECT_PLAYER &&
                                isOwnGoal != true) {
                              logEvent = ASSIST;
                              _matchLog(logEvent, teamName, duration.inSeconds,
                                  player: assistMaker,
                                  result: '$homeScore : $awayScore');
                            }

                            goalScorer = SELECT_PLAYER;
                            assistMaker = SELECT_PLAYER;
                            isOwnGoal = false;

                            setState(() {});

                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            // fixedSize: Size(250, 50),
                          ),
                          child: Text(
                            "Submit",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        }).then((value) {
      setState(() {});
    });
  }

  /// Get proper team (home or away) based on isHome parameter
  List<String> _getHomeAwayPlayerList(bool isHome) {
    if (isHome == true) {
      return _selectedHomePlayersName;
    }
    return _selectedAwayPlayersName;
  }

  /// construct Dialog box to register new shoot and/or save
  void _handleShootAction(String teamName, bool isHomeTeam) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              "$teamName shot",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              height: 400,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Was there a save as well?",
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _matchLog(SHOOT, teamName, duration.inSeconds);
                          // save is done by oposite team
                          _matchLog(
                              SAVE,
                              isHomeTeam ? selectedAwayTeam : selectedHomeTeam,
                              duration.inSeconds);
                          setState(() {});

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          // fixedSize: Size(250, 50),
                        ),
                        child: Text(
                          "Yes",
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _matchLog(SHOOT, teamName, duration.inSeconds);
                          /*setState(() {

                          });*/
                          _refreshScreen();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          // fixedSize: Size(250, 50),
                        ),
                        child: Text(
                          "No",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// Reset time on the semaphore. Sho all zeros
  void _reset() {
    //setState(() => duration = Duration(seconds: 0));
    duration = Duration(seconds: 0);
    _refreshScreen();
  }

  /// Start timer on the semaphore
  void _startTimer({continueTimeSecs = 1}) {
    timer =
        Timer.periodic(Duration(seconds: continueTimeSecs), (_) => _addTime());
    _refreshScreen();
  }

  /// Every second add one to the time shown on the semaphore
  void _addTime() {
    final seconds = duration.inSeconds + 1;
    duration = Duration(seconds: seconds);
    _refreshScreen();
  }

  /// Stop timer on the semaphore
  void _stopTimer({bool resets = true}) {
    if (resets) {
      _reset();
    }

    timer?.cancel();
    _refreshScreen();
  }

  /// Calculate time to be shown on the timer and show it
  Widget _buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildTimeCard(time: hours, header: 'HOURS'),
      SizedBox(
        width: 8,
      ),
      _buildTimeCard(time: minutes, header: 'MINUTES'),
      SizedBox(
        width: 8,
      ),
      _buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  /// Build semaphore part that shows time (build timer numbers)
  Widget _buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text(header, style: TextStyle(color: Colors.black45)),
        ],
      );

  /// Build start, stop buttons for timer
  Widget _buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 3600;

    return isRunning || isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  text: 'STOP',
                  onClicked: () {
                    if (isRunning) {
                      _stopTimer(resets: false);
                    }
                  }),
              SizedBox(
                width: 12,
              ),
              ButtonWidget(text: "CANCEL", onClicked: _stopTimer),
            ],
          )
        : ButtonWidget(
            text: "Start Timer!",
            color: Colors.black,
            backgroundColor: Colors.white,
            onClicked: () {
              _startTimer();
            });
  }

  /// Write each match event into a log and show it on the screen
  /// Event is considered to be shoot, save, assist and goal
  /// Assists and goals reccord the player name and score at that moment
  /// Shoot and save do not record player name or result
  void _matchLog(String logEvent, String team, int secs,
      {String player = SELECT_PLAYER, String result = 'N/A'}) {
    int time = (secs ~/ 60) + 1;
    String eventInfo = '$logEvent  $team';

    // record the event, goals and assists record game result
    if (player != SELECT_PLAYER && result != 'N/A') {
      eventInfo += ' $result';
    } else {
      eventInfo += ' ($time\')';
    }

    mLog.add(Text('-------------------------------'));
    mLog.add(Text(eventInfo));

    // if result is recorded it means it is either goal or assist
    // in that case record player name as well
    if (result != 'N/A') {
      mLog.add(Text('$player ($time\')'));
    }
  }

  /// Write shared preferences to signalize match has ended
  /// Stop the watch/timer
  /// Navigate back to the main screen
  void _handleEndMatchAction() {
    SharedPreferencesHandler pref = SharedPreferencesHandler();
    // stop timer
    _stopTimer(resets: false);
    // set match to NOT active
    pref.writeSharedPref(SharedPreferencesHandler.IS_MATCH_ACTIVE, 0);

    /* if (continueMatch) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));*/
    Navigator.pop(context);
  }

  /// Rerender the screen
  void _refreshScreen() {
    // check if widget tree is mounted, if it is not don't refresh it
    if (mounted) {
      setState(() {});
    }
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.color = Colors.white,
      this.backgroundColor = Colors.black})
      : super(key: key);
  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      onPressed: onClicked,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: color),
      ));
}
