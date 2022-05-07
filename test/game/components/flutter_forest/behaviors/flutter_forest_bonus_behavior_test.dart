// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/flutter_forest/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.dash.animatronic.keyName,
      theme.Assets.images.dash.ball.keyName,
    ]);
  }

  Future<void> pump(
    FlutterForest child, {
    required GameBloc gameBloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc,
        children: [
          ZCanvasComponent(
            children: [child],
          ),
        ],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterForestBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    void _contactedBumper(DashNestBumper bumper) =>
        bumper.bloc.onBallContacted();

    flameTester.testGameWidget(
      'adds GameBonus.dashNest to the game '
      'when bumpers are activated three times',
      setUp: (game, tester) async {
        await game.onLoad();
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        final animatronic = DashAnimatronic();
        final signpost = Signpost.test(bloc: SignpostCubit());
        await game.pump(parent, gameBloc: gameBloc);
        await parent.ensureAddAll([...bumpers, animatronic, signpost]);
        await parent.ensureAdd(behavior);

        expect(game.descendants().whereType<DashNestBumper>(), equals(bumpers));
        bumpers.forEach(_contactedBumper);
        await tester.pump();
        bumpers.forEach(_contactedBumper);
        await tester.pump();
        bumpers.forEach(_contactedBumper);
        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.dashNest)),
        ).called(1);
      },
    );

    flameTester.testGameWidget(
      'adds BonusBallSpawningBehavior to the game '
      'when bumpers are activated three times',
      setUp: (game, tester) async {
        await game.onLoad();
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        final animatronic = DashAnimatronic();
        final signpost = Signpost.test(bloc: SignpostCubit());
        await game.pump(parent, gameBloc: gameBloc);
        await parent.ensureAddAll([...bumpers, animatronic, signpost]);
        await parent.ensureAdd(behavior);

        expect(game.descendants().whereType<DashNestBumper>(), equals(bumpers));
        bumpers.forEach(_contactedBumper);
        await tester.pump();
        bumpers.forEach(_contactedBumper);
        await tester.pump();
        bumpers.forEach(_contactedBumper);
        await tester.pump();

        await game.ready();
        expect(
          game.descendants().whereType<BonusBallSpawningBehavior>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'progress the signpost '
      'when bumpers are activated',
      setUp: (game, tester) async {
        await game.onLoad();
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        final animatronic = DashAnimatronic();
        final signpost = Signpost.test(bloc: SignpostCubit());
        await game.pump(parent, gameBloc: gameBloc);
        await parent.ensureAddAll([...bumpers, animatronic, signpost]);
        await parent.ensureAdd(behavior);

        expect(game.descendants().whereType<DashNestBumper>(), equals(bumpers));

        bumpers.forEach(_contactedBumper);
        await tester.pump();
        expect(
          signpost.bloc.state,
          equals(SignpostState.active1),
        );

        bumpers.forEach(_contactedBumper);
        await tester.pump();
        expect(
          signpost.bloc.state,
          equals(SignpostState.active2),
        );

        bumpers.forEach(_contactedBumper);
        await tester.pump();
        expect(
          signpost.bloc.state,
          equals(SignpostState.inactive),
        );
      },
    );
  });
}
