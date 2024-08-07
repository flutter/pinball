// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    PlungerReleasingBehavior behavior, {
    PlungerCubit? plungerBloc,
  }) async {
    final plunger = Plunger.test();
    await ensureAdd(plunger);
    return plunger.ensureAdd(
      FlameBlocProvider<PlungerCubit, PlungerState>.value(
        value: plungerBloc ?? PlungerCubit(),
        children: [behavior],
      ),
    );
  }
}

class _MockPlungerCubit extends Mock implements PlungerCubit {}

void main() {
  group('PlungerReleasingBehavior', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(_TestGame.new);

    test('can be instantiated', () {
      expect(
        PlungerReleasingBehavior(strength: 0),
        isA<PlungerReleasingBehavior>(),
      );
    });

    test('throws assertion error when strength is negative ', () {
      expect(
        () => PlungerReleasingBehavior(strength: -1),
        throwsAssertionError,
      );
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final behavior = PlungerReleasingBehavior(strength: 0);
        await game.pump(behavior);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<PlungerReleasingBehavior>(),
          isNotEmpty,
        );
      },
    );

    flameTester.testGameWidget(
      'applies vertical linear velocity',
      setUp: (game, _) async {
        final plungerBloc = _MockPlungerCubit();
        final streamController = StreamController<PlungerState>();
        whenListen<PlungerState>(
          plungerBloc,
          streamController.stream,
          initialState: PlungerState.pulling,
        );

        final behavior = PlungerReleasingBehavior(strength: 2);
        await game.pump(
          behavior,
          plungerBloc: plungerBloc,
        );

        streamController.add(PlungerState.releasing);
      },
      verify: (game, _) async {
        final behavior =
            game.descendants().whereType<PlungerReleasingBehavior>().single;
        game.update(0);

        final plunger = behavior.ancestors().whereType<Plunger>().single;
        expect(plunger.body.linearVelocity.x, equals(0));
        expect(plunger.body.linearVelocity.y, isNot(greaterThan(0)));
      },
    );
  });
}
