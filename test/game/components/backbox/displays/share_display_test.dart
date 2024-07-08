// ignore_for_file: cascade_invocations

import 'package:flame/events.dart';
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

class _TestGame extends Forge2DGame with TapCallbacks {
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

class _MockTapUpEvent extends Mock implements TapUpEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('ShareDisplay', () {
    var tapped = false;
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = ShareDisplay();
        await game.pump(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<ShareDisplay>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'calls onShare when Facebook button is tapped',
      setUp: (game, _) async {
        tapped = false;
        final component = ShareDisplay(
          onShare: (_) => tapped = true,
        );
        await game.pump(component);
      },
      verify: (game, _) async {
        final tapUpEvent = _MockTapUpEvent();
        final component = game.descendants().whereType<ShareDisplay>().single;
        final facebookButton =
            component.descendants().whereType<FacebookButtonComponent>().first;

        facebookButton.onTapUp(tapUpEvent);

        expect(tapped, isTrue);
      },
    );

    flameTester.testGameWidget(
      'calls onShare when Twitter button is tapped',
      setUp: (game, _) async {
        final component = ShareDisplay(
          onShare: (_) => tapped = true,
        );
        await game.pump(component);
      },
      verify: (game, _) async {
        final tapUpInfo = _MockTapUpEvent();
        final component = game.descendants().whereType<ShareDisplay>().single;
        final twitterButton =
            component.descendants().whereType<TwitterButtonComponent>().first;

        twitterButton.onTapUp(tapUpInfo);

        expect(tapped, isTrue);
      },
    );
  });
}
