import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liga_app/screens/active_match_screen.dart';
import 'package:liga_app/shared_preferences_mgr/shared_preferences_handler.dart';

import 'new_match_config_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zidić Liga',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _HomeScreen(title: 'Zidić Liga'),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  late Future<ElevatedButton> _matchButton;
  @override
  Widget build(BuildContext context) {
    _matchButton = _constructMatchButton();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*ElevatedButton(
                onPressed: _navigateNewMatchScreen, child: Text('New match')),*/
            FutureBuilder(future: _matchButton, builder: _newButtonConstructor),
            ElevatedButton(
                onPressed: _navigateLeagueTableScreen,
                child: Text('League table')),
            ElevatedButton(
                onPressed: _navigateStatsScreen, child: Text('Stats'))
          ],
        ),
      ),
    );
  }

  /// navigate to New Match screen to create new game
  void _navigateNewMatchScreen() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewMatchConfigScreen()))
        .then(_onGoBack);
  }
  
  void _navigateActiveMatchScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ActiveMatchScreen.continueMatch()))
        .then(_onGoBack);
  }

  /// navigate to League Table screen to view current league table
  void _navigateLeagueTableScreen() {}

  /// navigate to Stats screen to see league, team and individual player stats
  void _navigateStatsScreen() {}

  Future<ElevatedButton> _constructMatchButton() async {
    SharedPreferencesHandler pref = SharedPreferencesHandler();
    int isMatchActive = await pref.checkMatchActive();
    String buttonText = 'New match';
    if (isMatchActive == 1) {
      buttonText = 'View active match';
    }
    return ElevatedButton(
        onPressed: (isMatchActive == 1) ? _navigateActiveMatchScreen : _navigateNewMatchScreen, child: Text(buttonText));
  }

  /// render propper button on the screen
  Widget _newButtonConstructor(
      BuildContext context, AsyncSnapshot<ElevatedButton> snapshot) {
    if (snapshot.hasData != true || snapshot.data == null) {
      return Text('Checking for active matches');
    }

    return ElevatedButton(
        onPressed: snapshot.data?.onPressed!, child: snapshot.data?.child!);
  }

  /// This function is called when you navigate back to home_screen from some
  /// other screen
  /// It forces rerender of the home_screen. This is needed so that if you start a new
  /// match, and return to home_screen, New Match button is not available any more
  FutureOr _onGoBack(dynamic value) {
    setState(() {});
  }
}
