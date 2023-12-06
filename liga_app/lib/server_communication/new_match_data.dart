import 'package:liga_app/database_mgr/player.dart';

class NewMatchData {
  late List<String> _homeTeamList;
  late List<String> _awayTeamList;

  static late List<Player> homeTeamPlayersList;
  static late List<Player> awayTeamPlayersList;

  static const String defaultHomeTeam = 'Select Home Team';
  static const String defaultAwayTeam = 'Select Away Team';

  List<String> get HomeTeamList {
    return _homeTeamList;
  }

  List<String> get AwayTeamList {
    return _awayTeamList;
  }


  NewMatchData() {
    _homeTeamList = <String>[];
    _awayTeamList = <String>[];
    homeTeamPlayersList = <Player>[];
    awayTeamPlayersList = <Player>[];
    initializeTeamList();
    initializePlayerList();
  }

  void initializePlayerList()  {
    for (int i = 0; i < 20; i++) {
      homeTeamPlayersList.add(Player(i, 'Home Player_$i'));
      awayTeamPlayersList.add(Player(i, 'Away Player_$i'));
    }
  }

  void initializeTeamList() {
    _homeTeamList.add('Select Home Team');
    _awayTeamList.add('Select Away Team');
    for (int i = 0; i < 20; i++) {
      _homeTeamList.add('Home Team_$i');
      _awayTeamList.add('Away Team_$i');
    }
  }
}


