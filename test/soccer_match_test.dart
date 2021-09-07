import 'package:flutter_test/flutter_test.dart';

import 'package:soccer_match/soccer_match.dart';

void main() {
  test('adds one to input values', () {
    var matchs = SoccerMatchs('fixtures').getAllMatches({'date': '2021-7-7'});
    print(matchs.toString());
  });
}
