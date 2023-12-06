import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liga_app/shared_preferences_mgr/shared_preferences_handler.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../database_mgr/player.dart';
import '../server_communication/new_match_data.dart';
import 'active_match_screen.dart';

class NewMatchConfigScreen extends StatelessWidget {
  const NewMatchConfigScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zidić Liga',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _NewMatchConfigScreen(title: 'Zidić Liga'),
    );
  }
}

class _NewMatchConfigScreen extends StatefulWidget {
  const _NewMatchConfigScreen({Key? key, required this.title})
      : super(key: key);

  final String title;
  @override
  State<_NewMatchConfigScreen> createState() => _NewMatchConfigScreenState();
}

class _NewMatchConfigScreenState extends State<_NewMatchConfigScreen> {
  NewMatchData matchData = NewMatchData();
  String selectedHomeTeam = NewMatchData.defaultHomeTeam;
  String selectedAwayTeam = NewMatchData.defaultAwayTeam;

  final _homePlayers = NewMatchData.homeTeamPlayersList
      .map((player) => MultiSelectItem<Player>(player!, player!.name))
      .toList();
  final _awayPlayers = NewMatchData.awayTeamPlayersList
      .map((player) => MultiSelectItem<Player>(player!, player!.name))
      .toList();
  List<Player?> _selectedHomePlayers = <Player?>[];
  List<Player?> _selectedAwayPlayers = <Player?>[];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
              // Initial Value
              value: selectedHomeTeam,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: matchData.HomeTeamList.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  selectedHomeTeam = newValue!;
                });
              },
            ),
            DropdownButton(
              // Initial Value
              value: selectedAwayTeam,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: matchData.AwayTeamList.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  selectedAwayTeam = newValue!;
                });
              },
            ),
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    //################################################################################################
                    // Select home players
                    //################################################################################################
                    MultiSelectDialogField(
                      items: _homePlayers,
                      title: Text("Players"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      buttonText: Text(
                        "Home Team Players",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                        ),
                      ),
                      onConfirm: (results) {
                        _selectedHomePlayers.clear();
                        for (int i = 0; i < results.length; i++) {
                          _selectedHomePlayers.add(results[i] as Player);
                        }
                      },
                    ),
                    SizedBox(height: 40),
                    //################################################################################################
                    // Select away players
                    //################################################################################################
                    MultiSelectDialogField(
                      items: _awayPlayers,
                      title: Text("Players"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      buttonText: Text(
                        "Away Team Players",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                        ),
                      ),
                      onConfirm: (results) {
                        _selectedAwayPlayers.clear();
                        for (int i = 0; i < results.length; i++) {
                          _selectedAwayPlayers.add(results[i] as Player);
                        }
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (item) {
                          Player p = item as Player;
                          for (int i = 0;
                              i < _selectedAwayPlayers.length;
                              i++) {
                            if (p.id == _selectedAwayPlayers[i]!.id) {
                              _selectedAwayPlayers.removeAt(i);
                              break;
                            }
                          }
                          print(p.name);
                          setState(() {});
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _navigateNewMatchScreen,
                        child: Text('Start match'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// navigate to New Match screen to create new game
  void _navigateNewMatchScreen() {
    SharedPreferencesHandler pref = SharedPreferencesHandler();
    // set match to active
    pref.writeSharedPref(SharedPreferencesHandler.IS_MATCH_ACTIVE, 1);

    if (selectedHomeTeam == NewMatchData.defaultHomeTeam ||
        selectedAwayTeam == NewMatchData.defaultAwayTeam ||
        _selectedHomePlayers.length == 0 ||
        _selectedAwayPlayers.length == 0) {
      return;
    }

    // Once you navigate to the Match screen, remove current screen from stack
    // Pressing back button will get you back to Home Screen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ActiveMatchScreen(selectedHomeTeam,
                selectedAwayTeam, _selectedHomePlayers, _selectedAwayPlayers, false)));
  }
}
