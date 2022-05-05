// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/loading_display.dart';
import 'package:pinball/l10n/l10n.dart';

import '../../../../helpers/helpers.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get loading => 'Loading';
}

void main() {
  group('LoadingDisplay', () {
    final flameTester = FlameTester(
      () => EmptyPinballTestGame(
        l10n: _MockAppLocalizations(),
      ),
    );

    flameTester.test('renders correctly', (game) async {
      await game.ensureAdd(LoadingDisplay());

      final component = game.firstChild<TextComponent>();
      expect(component, isNotNull);
      expect(component?.text, equals('Loading'));
    });

    flameTester.test('use ellipses as animation', (game) async {
      await game.ensureAdd(LoadingDisplay());

      final component = game.firstChild<TextComponent>();
      expect(component?.text, equals('Loading'));

      final timer = component?.firstChild<TimerComponent>();

      timer?.update(1.1);
      expect(component?.text, equals('Loading.'));

      timer?.update(1.1);
      expect(component?.text, equals('Loading..'));

      timer?.update(1.1);
      expect(component?.text, equals('Loading...'));

      timer?.update(1.1);
      expect(component?.text, equals('Loading'));
    });
  });
}
