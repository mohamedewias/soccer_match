library soccer_match;

import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SoccerMatchs {
  final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final category;
  SoccerMatchs(this.category);

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
      Uri uri = Uri.https(
          'footbal-linfo.li', '/football/$category.php', queryMatches);
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
  }
}

class SoccerMatch {
  Fixture fixture;
  Team home;
  Team away;
  Goal goal;
  League league;
  // Score score;
  SoccerMatch(this.fixture, this.home, this.away, this.goal, this.league);

  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    return SoccerMatch(
      Fixture.fromJson(json['fixture']),
      Team.fromJson(json['teams']['home']),
      Team.fromJson(json['teams']['away']),
      Goal.fromJson(json['goals']),
      League.fromJson(json['league']),
      // Score.fromJson(json['score']),
    );
  }
}

class Score {
  Halftime halftime;
  Fulltime fulltime;
  Extratime extratime;
  Penalty penalty;
  Score(this.extratime, this.fulltime, this.halftime, this.penalty);
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      Extratime.fromJson(json['extratime']),
      Fulltime.fromJson(json['fulltime']),
      Halftime.fromJson(json['halftime']),
      Penalty.fromJson(json['Penalty']),
    );
  }
}

class Penalty {
  int home;
  int away;
  Penalty(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(json['home'], json['away']);
  }
}

class Extratime {
  int home;
  int away;
  Extratime(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory Extratime.fromJson(Map<String, dynamic> json) {
    return Extratime(json['home'], json['away']);
  }
}

class Fulltime {
  int home;
  int away;
  Fulltime(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory Fulltime.fromJson(Map<String, dynamic> json) {
    return Fulltime(json['home'], json['away']);
  }
}

class Halftime {
  int home;
  int away;
  Halftime(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory Halftime.fromJson(Map<String, dynamic> json) {
    return Halftime(json['home'], json['away']);
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
  Fixture(this.id, this.date, this.referee, this.timezone, this.timestamp,
      this.status, this.periods, this.venue);

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      json['id'],
      json['date'],
      json['referee'],
      json['timezone'],
      json['timestamp'],
      Status.fromJson(json['status']),
      Periods.fromJson(json['periods']),
      Venue.fromJson(json['venue']),
    );
  }
}

class Team {
  int id;
  String name;
  String logoUrl;
  bool winner;
  Team(this.id, this.name, this.logoUrl, this.winner);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(json['id'], json['name'], json['logo'], json['winner']);
  }
}

//here we will store the Goal data
class Goal {
  int home;
  int away;
  Goal(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(json['home'], json['away']);
  }
}

class Periods {
  int first;
  int second;
  Periods(this.first, this.second);

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(json['first'], json['second']);
  }
}

class Venue {
  int id;
  String name;
  String city;
  Venue(
    this.id,
    this.name,
    this.city,
  );

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(json['id'], json['name'], json['city']);
  }
}

//here we will store the Status
class Status {
  int elapsedTime;
  String long;
  String short;
  Status(this.elapsedTime, this.long, this.short);

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(json['elapsed'], json['long'], json['short']);
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
  League(this.id, this.name, this.country, this.logo, this.flag, this.season,
      this.round);
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      json['id'],
      json['name'],
      json['country'],
      json['logo'],
      json['flag'],
      json['season'],
      json['round'],
    );
  }
}
