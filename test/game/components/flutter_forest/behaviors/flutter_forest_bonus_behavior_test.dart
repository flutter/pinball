// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/flutter_forest/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('FlutterForestBonusBehavior', () {
    late GameBloc gameBloc;
    final assets = [Assets.images.dash.animatronic.keyName];

    setUp(() {
      gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
    );

    void _contactedBumper(DashNestBumper bumper) =>
        bumper.bloc.onBallContacted();

    flameBlocTester.testGameWidget(
      'adds GameBonus.dashNest to the game '
      'when bumpers are activated three times',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        final animatronic = DashAnimatronic();
        final signpost = Signpost.test(bloc: SignpostCubit());
        await game.ensureAdd(ZCanvasComponent(children: [parent]));
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

    flameBlocTester.testGameWidget(
      'adds a new Ball to the game '
      'when bumpers are activated three times',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        final animatronic = DashAnimatronic();
        final signpost = Signpost.test(bloc: SignpostCubit());
        await game.ensureAdd(ZCanvasComponent(children: [parent]));
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
          game.descendants().whereType<Ball>().length,
          equals(1),
        );
      },
    );

    flameBlocTester.testGameWidget(
      'progress the signpost '
      'when bumpers are activated',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        final animatronic = DashAnimatronic();
        final signpost = Signpost.test(bloc: SignpostCubit());
        await game.ensureAdd(ZCanvasComponent(children: [parent]));
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
