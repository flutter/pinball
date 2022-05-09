// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final asset = Assets.images.plunger.plunger.keyName;
  final flameTester = FlameTester(() => TestGame([asset]));

  group('Plunger', () {
    test('can be instantiated', () {
      expect(Plunger(), isA<Plunger>());
    });

    flameTester.test(
      'loads correctly',
      (game) async {
        final plunger = Plunger();
        await game.ensureAdd(plunger);
        expect(game.children, contains(plunger));
      },
    );

    group('adds', () {
      flameTester.test(
        'a PlungerReleasingBehavior',
        (game) async {
          final plunger = Plunger();
          await game.ensureAdd(plunger);
          expect(
            game.descendants().whereType<PlungerReleasingBehavior>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a PlungerJointingBehavior',
        (game) async {
          final plunger = Plunger();
          await game.ensureAdd(plunger);
          expect(
            game.descendants().whereType<PlungerJointingBehavior>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a PlungerNoiseBehavior',
        (game) async {
          final plunger = Plunger();
          await game.ensureAdd(plunger);
          expect(
            game.descendants().whereType<PlungerNoiseBehavior>().length,
            equals(1),
          );
        },
      );
    });

    group('renders correctly', () {
      const goldenPath = '../golden/plunger/';
      flameTester.testGameWidget(
        'pulling',
        setUp: (game, tester) async {
          await game.images.load(asset);
          await game.ensureAdd(Plunger());
          game.camera.followVector2(Vector2.zero());
          game.camera.zoom = 4.1;
        },
        verify: (game, tester) async {
          final plunger = game.descendants().whereType<Plunger>().first;
          final bloc = plunger
              .descendants()
              .whereType<FlameBlocProvider<PlungerCubit, PlungerState>>()
              .single
              .bloc;
          bloc.pulled();
          await tester.pump();
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenPath}pull.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'releasing',
        setUp: (game, tester) async {
          await game.images.load(asset);
          await game.ensureAdd(Plunger());
          game.camera.followVector2(Vector2.zero());
          game.camera.zoom = 4.1;
        },
        verify: (game, tester) async {
          final plunger = game.descendants().whereType<Plunger>().first;
          final bloc = plunger
              .descendants()
              .whereType<FlameBlocProvider<PlungerCubit, PlungerState>>()
              .single
              .bloc;
          bloc.released();
          await tester.pump();
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenPath}release.png'),
          );
        },
      );
    });
  });
}
