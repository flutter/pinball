import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/app/app.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockPinballPlayer extends Mock implements PinballPlayer {}

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;
    late LeaderboardRepository leaderboardRepository;
    late PinballPlayer pinballPlayer;

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      leaderboardRepository = _MockLeaderboardRepository();
      pinballPlayer = _MockPinballPlayer();
      when(pinballPlayer.load).thenAnswer((_) => [Future.value()]);
    });

    testWidgets('renders PinballGamePage', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: authenticationRepository,
          leaderboardRepository: leaderboardRepository,
          pinballPlayer: pinballPlayer,
        ),
      );
      expect(find.byType(PinballGamePage), findsOneWidget);
    });
  });
}
