import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('GameOverDialog', () {
    testWidgets('renders GameOverDialogView', (tester) async {
      await tester.pumpApp(
        GameOverDialog(
          score: 1000,
          theme: DashTheme(),
        ),
      );

      expect(find.byType(LeaderboardView), findsOneWidget);
    });

    testWidgets('route returns a valid navigation route', (tester) async {
      await expectNavigatesToRoute<LeaderboardPage>(
        tester,
        LeaderboardPage.route(
          theme: DashTheme(),
        ),
      );
    });
  });
}
