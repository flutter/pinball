// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.dash.bumper.main.active.keyName,
      Assets.images.dash.bumper.main.inactive.keyName,
      Assets.images.dash.bumper.a.active.keyName,
      Assets.images.dash.bumper.a.inactive.keyName,
      Assets.images.dash.bumper.b.active.keyName,
      Assets.images.dash.bumper.b.inactive.keyName,
      Assets.images.dash.animatronic.keyName,
      Assets.images.signpost.inactive.keyName,
      Assets.images.signpost.active1.keyName,
      Assets.images.signpost.active2.keyName,
      Assets.images.signpost.active3.keyName,
    ]);
  }

  Future<void> pump(FlutterForest child) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: _MockGameBloc(),
        children: [
          FlameProvider.value(
            _MockPinballAudioPlayer(),
            children: [
              ZCanvasComponent(children: [child]),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('FlutterForest', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final component = FlutterForest();
        await game.pump(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<FlutterForest>(), isNotEmpty);
      },
    );

    group('loads', () {
      flameTester.testGameWidget(
        'a Signpost',
        setUp: (game, _) async {
          await game.onLoad();
          final component = FlutterForest();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<Signpost>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'a DashAnimatronic',
        setUp: (game, _) async {
          await game.onLoad();
          final component = FlutterForest();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<DashAnimatronic>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'three DashBumper',
        setUp: (game, _) async {
          await game.onLoad();
          final component = FlutterForest();
          await game.pump(component);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<DashBumper>().length,
            equals(3),
          );
        },
      );

      flameTester.testGameWidget(
        'three DashBumpers with BumperNoiseBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final component = FlutterForest();
          await game.pump(component);
        },
        verify: (game, _) async {
          final bumpers = game.descendants().whereType<DashBumper>();
          for (final bumper in bumpers) {
            expect(
              bumper.firstChild<BumperNoiseBehavior>(),
              isNotNull,
            );
          }
        },
      );
    });
  });
}
