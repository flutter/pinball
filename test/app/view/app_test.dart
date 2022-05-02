import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/app/app.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';

import '../../helpers/mocks.dart';

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;
    late LeaderboardRepository leaderboardRepository;
    late PinballAudio pinballAudio;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      leaderboardRepository = MockLeaderboardRepository();
      pinballAudio = MockPinballAudio();
      when(pinballAudio.load).thenAnswer((_) => Future.value());
    });

    testWidgets('renders PinballGamePage', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: authenticationRepository,
          leaderboardRepository: leaderboardRepository,
          pinballAudio: pinballAudio,
        ),
      );
      expect(find.byType(PinballGamePage), findsOneWidget);
    });
  });
}
