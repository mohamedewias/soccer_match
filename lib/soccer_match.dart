library soccer_match;

import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class soccer_match {
  final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final category;
  soccer_match(this.category);
 
  Future<List<SoccerMatch>> getAllMatches(
      Map<String, dynamic> queryMatches) async {
    var body;
    String tempMatches = category.toString() +
        "_" +
        queryMatches['date'].toString() +
        'matches.json';
    var tempDir = await getApplicationDocumentsDirectory();
    File fileMatches = File(tempDir.path + "/football" + tempMatches);
    try {
      Uri uri =
          Uri.https('footbal-linfo.li', '/football/$category.php', queryMatches);
      Response res = await get(uri);
      if (res.body.isNotEmpty && res.body[0].isNotEmpty) {
        if (res.statusCode == 200) {
          fileMatches.writeAsStringSync(res.body,
              flush: true, mode: FileMode.write);
          body = jsonDecode(res.body);
          List<dynamic> matchesList = body['response'];
          List<SoccerMatch> matches = matchesList
              .map((dynamic item) => SoccerMatch.fromJson(item))
              .toList();
          return matches;
        } else {
          if (fileMatches.existsSync()) {
            final data = fileMatches.readAsStringSync();
            body = jsonDecode(data);
            List<dynamic> matchesList = body['response'];
            List<SoccerMatch> matches = matchesList
                .map((dynamic item) => SoccerMatch.fromJson(item))
                .toList();
            return matches;
          } else {
            Uri uri = Uri.https(
                'footbal-linfo.li', '/football/$category.php', queryMatches);
            Response res = await get(uri);
            if (res.statusCode == 200) {
              fileMatches.writeAsStringSync(res.body,
                  flush: true, mode: FileMode.write);
              body = jsonDecode(res.body);
              List<dynamic> matchesList = body['response'];
              List<SoccerMatch> matches = matchesList
                  .map((dynamic item) => SoccerMatch.fromJson(item))
                  .toList();
              return matches;
            } else {
              List<SoccerMatch> mat = [];
              return mat;
            }
          }
        }
      } else {
        if (fileMatches.existsSync()) {
          final data = fileMatches.readAsStringSync();
          body = jsonDecode(data);
          List<dynamic> matchesList = body['response'];
          List<SoccerMatch> matches = matchesList
              .map((dynamic item) => SoccerMatch.fromJson(item))
              .toList();
          return matches;
        } else {
          Uri uri = Uri.https(
              'footbal-linfo.li', '/football/$category.php', queryMatches);
          Response res = await get(uri);
          if (res.statusCode == 200) {
            fileMatches.writeAsStringSync(res.body,
                flush: true, mode: FileMode.write);
            body = jsonDecode(res.body);
            List<dynamic> matchesList = body['response'];
            List<SoccerMatch> matches = matchesList
                .map((dynamic item) => SoccerMatch.fromJson(item))
                .toList();
            return matches;
          } else {
            List<SoccerMatch> mat = [];
            return mat;
          }
        }
      }
    } on SocketException catch (_) {
      if (fileMatches.existsSync()) {
        final data = fileMatches.readAsStringSync();
        body = jsonDecode(data);
        List<dynamic> matchesList = body['response'];
        List<SoccerMatch> matches = matchesList
            .map((dynamic item) => SoccerMatch.fromJson(item))
            .toList();
        return matches;
      } else {
        Uri uri =
            Uri.https('footbal-linfo.li', '/football/$category.php', queryMatches);
        Response res = await get(uri);
        if (res.statusCode == 200) {
          fileMatches.writeAsStringSync(res.body,
              flush: true, mode: FileMode.write);
          body = jsonDecode(res.body);
          List<dynamic> matchesList = body['response'];
          List<SoccerMatch> matches = matchesList
              .map((dynamic item) => SoccerMatch.fromJson(item))
              .toList();
          return matches;
        } else {
          List<SoccerMatch> mat = [];
          return mat;
        }
      }
    }
  }
}

class SoccerMatch {
  //here we will see the different data
  //you will find every thing you need in the doc
  //I'm not going to use every data, just few ones

  Fixture fixture;
  Team home;
  Team away;
  Goal goal;
  League league;
  Score score;
  SoccerMatch(
      this.fixture, this.home, this.away, this.goal, this.league, this.score);

  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    return SoccerMatch(
      Fixture.fromJson(json['fixture']),
      Team.fromJson(json['teams']['home']),
      Team.fromJson(json['teams']['away']),
      Goal.fromJson(json['goals']),
      League.fromJson(json['league']),
      Score.fromJson(json['league']),
    );
  }
}

class Score {
  Halftime halftime;
  Fulltime fulltime;
  Extratime extratime;
  Penalty penalty;
  Score(
      {required this.extratime,
      required this.fulltime,
      required this.halftime,
      required this.penalty});
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      halftime: Halftime.fromJson(json['halftime']),
      fulltime: Fulltime.fromJson(json['fulltime']),
      extratime: Extratime.fromJson(json['extratime']),
      penalty: Penalty.fromJson(json['Penalty']),
    );
  }
}

class Penalty {
  int home;
  int away;
  Penalty({required this.home, required this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(home: json['home'], away: json['away']);
  }
}

class Extratime {
  int home;
  int away;
  Extratime({required this.home, required this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  factory Extratime.fromJson(Map<String, dynamic> json) {
    return Extratime(home: json['home'], away: json['away']);
  }
}

class Fulltime {
  int home;
  int away;
  Fulltime({required this.home, required this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  factory Fulltime.fromJson(Map<String, dynamic> json) {
    return Fulltime(home: json['home'], away: json['away']);
  }
}

class Halftime {
  int home;
  int away;
  Halftime({required this.home, required this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  factory Halftime.fromJson(Map<String, dynamic> json) {
    return Halftime(home: json['home'], away: json['away']);
  }
}

class Fixture {
  int id;
  String date;
  String referee;
  String timezone;
  int timestamp;
  Status status;
  Periods periods;
  Venue venue;
  Fixture(
      {required this.id,
      required this.date,
      required this.referee,
      required this.timezone,
      required this.timestamp,
      required this.status,
      required this.periods,
      required this.venue});

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      id: json['id'],
      date: json['date'],
      referee: json['referee'],
      timezone: json['timezone'],
      timestamp: json['timestamp'],
      status: Status.fromJson(json['status']),
      periods: Periods.fromJson(json['periods']),
      venue: Venue.fromJson(json['venue']),
    );
  }
}

class Team {
  int id;
  String name;
  String logoUrl;
  bool winner;
  Team(
      {required this.id,
      required this.name,
      required this.logoUrl,
      required this.winner});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        id: json['id'],
        name: json['name'],
        logoUrl: json['logo'],
        winner: json['winner']);
  }
}

//here we will store the Goal data
class Goal {
  int home;
  int away;
  Goal({required this.home, required this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(home: json['home'], away: json['away']);
  }
}

class Periods {
  int first;
  int second;
  Periods({required this.first, required this.second});

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(first: json['first'], second: json['second']);
  }
}

class Venue {
  int id;
  String name;
  String city;
  Venue({
    required this.id,
    required this.name,
    required this.city,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(id: json['id'], name: json['name'], city: json['city']);
  }
}

//here we will store the Status
class Status {
  int elapsedTime;
  String long;
  String short;
  Status({required this.elapsedTime, required this.long, required this.short});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
        elapsedTime: json['elapsed'], long: json['long'], short: json['short']);
  }
}

class League {
  int id;
  String name;
  String country;
  String logo;
  String flag;
  int season;
  String round;
  League(
      {required this.id,
      required this.name,
      required this.logo,
      required this.flag,
      required this.country,
      required this.round,
      required this.season});
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      logo: json['logo'],
      flag: json['flag'],
      season: json['season'],
      round: json['round'],
    );
  }
}
