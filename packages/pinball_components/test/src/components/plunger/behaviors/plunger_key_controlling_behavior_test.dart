// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    PlungerKeyControllingBehavior child, {
    PlungerCubit? plungerBloc,
  }) async {
    final plunger = Plunger.test();
    await ensureAdd(plunger);
    return plunger.ensureAdd(
      FlameBlocProvider<PlungerCubit, PlungerState>.value(
        value: plungerBloc ?? _MockPlungerCubit(),
        children: [child],
      ),
    );
  }
}

class _MockKeyDownEvent extends Mock implements KeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockKeyUpEvent extends Mock implements KeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockPlungerCubit extends Mock implements PlungerCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('PlungerKeyControllingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerKeyControllingBehavior(),
        isA<PlungerKeyControllingBehavior>(),
      );
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final behavior = PlungerKeyControllingBehavior();
        await game.pump(behavior);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<PlungerKeyControllingBehavior>(),
          isNotEmpty,
        );
      },
    );

    group('onKeyEvent', () {
      late PlungerCubit plungerBloc;

      setUp(() {
        plungerBloc = _MockPlungerCubit();
      });

      group('pulls when', () {
        flameTester.testGameWidget(
          'down arrow is pressed',
          setUp: (game, _) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<PlungerKeyControllingBehavior>()
                .single;
            final event = _MockKeyDownEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.arrowDown,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.pulled()).called(1);
          },
        );

        flameTester.testGameWidget(
          '"s" is pressed',
          setUp: (game, _) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<PlungerKeyControllingBehavior>()
                .single;

            final event = _MockKeyDownEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.keyS,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.pulled()).called(1);
          },
        );

        flameTester.testGameWidget(
          'space is pressed',
          setUp: (game, _) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<PlungerKeyControllingBehavior>()
                .single;

            final event = _MockKeyDownEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.space,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.pulled()).called(1);
          },
        );
      });

      group('releases when', () {
        flameTester.testGameWidget(
          'down arrow is released',
          setUp: (game, _) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<PlungerKeyControllingBehavior>()
                .single;

            final event = _MockKeyUpEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.arrowDown,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.released()).called(1);
          },
        );

        flameTester.testGameWidget(
          '"s" is released',
          setUp: (game, _) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<PlungerKeyControllingBehavior>()
                .single;

            final event = _MockKeyUpEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.keyS,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.released()).called(1);
          },
        );

        flameTester.testGameWidget(
          'space is released',
          setUp: (game, _) async {
            final behavior = PlungerKeyControllingBehavior();
            await game.pump(
              behavior,
              plungerBloc: plungerBloc,
            );
          },
          verify: (game, _) async {
            final behavior = game
                .descendants()
                .whereType<PlungerKeyControllingBehavior>()
                .single;

            final event = _MockKeyUpEvent();
            when(() => event.logicalKey).thenReturn(
              LogicalKeyboardKey.space,
            );

            behavior.onKeyEvent(event, {});

            verify(() => plungerBloc.released()).called(1);
          },
        );
      });
    });
  });
}
