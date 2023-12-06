import 'package:liga_app/database_mgr/player.dart';

import 'game_log_entry.dart';

const String SELECT_GOAL_SCORRER = 'Select goal scorrer';
const String SELECT_ASSIST_MAKER = 'Select assist maker';
const String SELECT_PLAYER = 'Select player';

class ContinueMatchData {

  static late List<Player> homeTeamPlayersList;
  static late List<Player> awayTeamPlayersList;

  static late List<MatchLogEvent> matchLogHistory;

  static const String homeTeam = 'Home Team_0';
  static const String awayTeam = 'Away Team_0';

  static const int homeScore = 5;

  static const int awayScore = 3;

  static late int matchTime;


  ContinueMatchData() {
    homeTeamPlayersList = <Player>[];
    awayTeamPlayersList = <Player>[];
    matchLogHistory = <MatchLogEvent>[];
    matchTime = 2200;
    initializePlayerList();
    initializeMatchLogHistory();
  }

  void initializePlayerList()  {
    for (int i = 0; i < 7; i++) {
      homeTeamPlayersList.add(Player(i, 'Home Player_$i'));
      awayTeamPlayersList.add(Player(i, 'Away Player_$i'));
    }
  }

  void initializeMatchLogHistory() {
    matchLogHistory.add(MatchLogEvent(GOAL, homeTeam, 123, homeTeamPlayersList[2], '1 : 0'));
    matchLogHistory.add(MatchLogEvent(ASSIST, homeTeam, 123, homeTeamPlayersList[0], '1 : 0'));
    matchLogHistory.add(MatchLogEvent.noPlayer(SHOOT, awayTeam, 2000));
    matchLogHistory.add(MatchLogEvent.noPlayer(SAVE, awayTeam, 2000));
  }
}