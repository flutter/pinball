// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/app/app.dart';
import 'package:pinball/landing/landing.dart';

class MockLeaderboardRepository extends Mock implements LeaderboardRepository {}

void main() {
  group('App', () {
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      leaderboardRepository = MockLeaderboardRepository();
    });

    testWidgets('renders LandingPage', (tester) async {
      await tester.pumpWidget(
        App(leaderboardRepository: leaderboardRepository),
      );
      expect(find.byType(LandingPage), findsOneWidget);
    });
  });
}
