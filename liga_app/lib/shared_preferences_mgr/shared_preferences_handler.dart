import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  static const IS_MATCH_ACTIVE = 'IS_MATCH_ACTIVE';

  /// If shared preference is null or 0 it means match was NOT started
  /// If shared preference is NOT null or 0 it means match was started.
  /// In this case shared preference has value of match ID in database
  Future<int> checkMatchActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? action = prefs.getInt(IS_MATCH_ACTIVE);

    if (action == null || action == 0) {
      // render New Match button
      return 0;
    } else {
      // render View active match button
      return action;
    }
  }

  /// Write a value "value" into a shared preference named "prefName"
  void writeSharedPref(String prefName, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefName, value);
  }
}
