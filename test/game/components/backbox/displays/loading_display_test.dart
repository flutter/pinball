// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/bloc/game_bloc.dart';
import 'package:pinball/game/components/backbox/displays/loading_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(LoadingDisplay component) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [
          FlameProvider.value(
            _MockAppLocalizations(),
            children: [component],
          ),
        ],
      ),
    );
  }
}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get loading => 'Loading';
}

void main() {
  group('LoadingDisplay', () {
    final flameTester = FlameTester(_TestGame.new);

    flameTester.test('renders correctly', (game) async {
      await game.pump(LoadingDisplay());

      final component = game.descendants().whereType<TextComponent>().first;
      expect(component, isNotNull);
      expect(component.text, equals('Loading'));
    });

    flameTester.test('use ellipses as animation', (game) async {
      await game.pump(LoadingDisplay());

      final component = game.descendants().whereType<TextComponent>().first;
      expect(component.text, equals('Loading'));

      final timer = component.firstChild<TimerComponent>();

      timer?.update(1.1);
      expect(component.text, equals('Loading.'));

      timer?.update(1.1);
      expect(component.text, equals('Loading..'));

      timer?.update(1.1);
      expect(component.text, equals('Loading...'));

      timer?.update(1.1);
      expect(component.text, equals('Loading'));
    });
  });
}
