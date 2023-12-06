
import 'package:liga_app/database_mgr/player.dart';

const String OWN_GOAL = 'OWN GOAL!!!';
const String GOAL = 'GOAL!!!';
const String ASSIST = 'ASSIST!!!';
const String SHOOT = 'SHOOT!!!';
const String SAVE = 'SAVE!!!';

class MatchLogEvent {
  late int secs;
  late String teamName;
  late String eventType;
  late Player player;
  late String result;

  MatchLogEvent(this.eventType, this.teamName, this.secs, this.player, this.result);
  MatchLogEvent.noPlayer(this.eventType, this.teamName, this.secs) {
    player = Player(0, 'N/A');
    result = 'N/A';
  }
}