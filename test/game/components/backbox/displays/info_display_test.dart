// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/bloc/game_bloc.dart';
import 'package:pinball/game/components/backbox/displays/info_display.dart';
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
        Assets.images.backbox.button.share.keyName,
      ],
    );
  }

  Future<void> pump(InfoDisplay component) {
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
  String get shareYourScore => '';

  @override
  String get andChallengeYourFriends => '';

  @override
  String get share => '';

  @override
  String get gotoIO => '';

  @override
  String get learnMore => '';

  @override
  String get firebaseOrOpenSource => '';
}

class _MockTapDownInfo extends Mock implements TapDownInfo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('InfoDisplay', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final component = InfoDisplay();
        await game.pump(component);
        expect(game.descendants(), contains(component));
      },
    );

    flameTester.testGameWidget(
      'calls onShare when tap on Share link',
      setUp: (game, tester) async {
        var tapped = false;

        final tapDownInfo = _MockTapDownInfo();
        final component = InfoDisplay(
          onShare: () => tapped = true,
        );
        await game.pump(component);

        final shareLink =
            component.descendants().whereType<ShareLinkComponent>().first;

        shareLink.onTapDown(tapDownInfo);

        expect(tapped, isTrue);
      },
    );

    flameTester.testGameWidget(
      'calls onNavigate when Go to IO link is tapped',
      setUp: (game, tester) async {
        var tapped = false;

        final tapDownInfo = _MockTapDownInfo();
        final component = InfoDisplay(
          onNavigate: () => tapped = true,
        );
        await game.pump(component);

        final gotoLink =
            component.descendants().whereType<GotoIOLinkComponent>().first;

        gotoLink.onTapDown(tapDownInfo);

        expect(tapped, isTrue);
      },
    );
  });
}
