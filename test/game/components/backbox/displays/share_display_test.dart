// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/bloc/game_bloc.dart';
import 'package:pinball/game/components/backbox/displays/share_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame with HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = '';
    await images.loadAll(
      [
        Assets.images.backbox.button.facebook.keyName,
        Assets.images.backbox.button.twitter.keyName,
      ],
    );
  }

  Future<void> pump(ShareDisplay component) {
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
  String get letEveryone => '';

  @override
  String get bySharingYourScore => '';

  @override
  String get socialMediaAccount => '';
}

class _MockTapUpInfo extends Mock implements TapUpInfo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('ShareDisplay', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final component = ShareDisplay();
        await game.pump(component);
        expect(game.descendants(), contains(component));
      },
    );

    flameTester.test(
      'calls onShare when Facebook button is tapped',
      (game) async {
        var tapped = false;

        final tapUpInfo = _MockTapUpInfo();
        final component = ShareDisplay(
          onShare: (_) => tapped = true,
        );
        await game.pump(component);

        final facebookButton =
            component.descendants().whereType<FacebookButtonComponent>().first;

        facebookButton.onTapUp(tapUpInfo);

        expect(tapped, isTrue);
      },
    );

    flameTester.test(
      'calls onShare when Twitter button is tapped',
      (game) async {
        var tapped = false;

        final tapUpInfo = _MockTapUpInfo();
        final component = ShareDisplay(
          onShare: (_) => tapped = true,
        );
        await game.pump(component);

        final twitterButton =
            component.descendants().whereType<TwitterButtonComponent>().first;

        twitterButton.onTapUp(tapUpInfo);

        expect(tapped, isTrue);
      },
    );
  });
}
