//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class LeaguesApi {
  LeaguesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Returns a list of all leagues
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiLeaguesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/leagues';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns a list of all leagues
  Future<List<League>?> apiLeaguesGet() async {
    final response = await apiLeaguesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<League>') as List)
        .cast<League>()
        .toList();

    }
    return null;
  }

  /// Returns match details for active season of a league
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  ///
  /// * [int] matchId (required):
  Future<Response> apiLeaguesLeagueIdMatchesMatchIdGetWithHttpInfo(int leagueId, int matchId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/leagues/{leagueId}/matches/{matchId}'
      .replaceAll('{leagueId}', leagueId.toString())
      .replaceAll('{matchId}', matchId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns match details for active season of a league
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  ///
  /// * [int] matchId (required):
  Future<Match?> apiLeaguesLeagueIdMatchesMatchIdGet(int leagueId, int matchId,) async {
    final response = await apiLeaguesLeagueIdMatchesMatchIdGetWithHttpInfo(leagueId, matchId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Match',) as Match;
    
    }
    return null;
  }

  /// Returns list of players for active season of a league, default sorted by goals
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  ///
  /// * [String] orderBy:
  Future<Response> apiLeaguesLeagueIdPlayersGetWithHttpInfo(int leagueId, { String? orderBy, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/leagues/{leagueId}/players'
      .replaceAll('{leagueId}', leagueId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (orderBy != null) {
      queryParams.addAll(_queryParams('', 'orderBy', orderBy));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns list of players for active season of a league, default sorted by goals
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  ///
  /// * [String] orderBy:
  Future<void> apiLeaguesLeagueIdPlayersGet(int leagueId, { String? orderBy, }) async {
    final response = await apiLeaguesLeagueIdPlayersGetWithHttpInfo(leagueId,  orderBy: orderBy, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Returns standings for active season of a league
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  Future<Response> apiLeaguesLeagueIdStandingsGetWithHttpInfo(int leagueId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/leagues/{leagueId}/standings'
      .replaceAll('{leagueId}', leagueId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns standings for active season of a league
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  Future<List<Standing>?> apiLeaguesLeagueIdStandingsGet(int leagueId,) async {
    final response = await apiLeaguesLeagueIdStandingsGetWithHttpInfo(leagueId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Standing>') as List)
        .cast<Standing>()
        .toList();

    }
    return null;
  }

  /// Returns list of teams sorted by appearances for active season of a league
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  Future<Response> apiLeaguesLeagueIdStatisticsAppearancesByTeamGetWithHttpInfo(int leagueId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/leagues/{leagueId}/statistics/appearances-by-team'
      .replaceAll('{leagueId}', leagueId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns list of teams sorted by appearances for active season of a league
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  Future<AppearancesByTeam?> apiLeaguesLeagueIdStatisticsAppearancesByTeamGet(int leagueId,) async {
    final response = await apiLeaguesLeagueIdStatisticsAppearancesByTeamGetWithHttpInfo(leagueId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppearancesByTeam',) as AppearancesByTeam;
    
    }
    return null;
  }

  /// Returns team details for active season of a league
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  ///
  /// * [int] teamId (required):
  Future<Response> apiLeaguesLeagueIdTeamsTeamIdGetWithHttpInfo(int leagueId, int teamId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/leagues/{leagueId}/teams/{teamId}'
      .replaceAll('{leagueId}', leagueId.toString())
      .replaceAll('{teamId}', teamId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns team details for active season of a league
  ///
  /// Parameters:
  ///
  /// * [int] leagueId (required):
  ///
  /// * [int] teamId (required):
  Future<LeagueSeasonTeam?> apiLeaguesLeagueIdTeamsTeamIdGet(int leagueId, int teamId,) async {
    final response = await apiLeaguesLeagueIdTeamsTeamIdGetWithHttpInfo(leagueId, teamId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LeagueSeasonTeam',) as LeagueSeasonTeam;
    
    }
    return null;
  }
}
