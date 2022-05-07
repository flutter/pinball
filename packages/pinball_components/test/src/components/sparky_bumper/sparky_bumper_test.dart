// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/sparky_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockSparkyBumperCubit extends Mock implements SparkyBumperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.sparky.bumper.a.lit.keyName,
    Assets.images.sparky.bumper.a.dimmed.keyName,
    Assets.images.sparky.bumper.b.lit.keyName,
    Assets.images.sparky.bumper.b.dimmed.keyName,
    Assets.images.sparky.bumper.c.lit.keyName,
    Assets.images.sparky.bumper.c.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SparkyBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final sparkyBumper = SparkyBumper.a();
      await game.ensureAdd(sparkyBumper);
      expect(game.contains(sparkyBumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final sparkyBumper = SparkyBumper.b();
      await game.ensureAdd(sparkyBumper);
      expect(game.contains(sparkyBumper), isTrue);
    });

    flameTester.test('"c" loads correctly', (game) async {
      final sparkyBumper = SparkyBumper.c();
      await game.ensureAdd(sparkyBumper);
      expect(game.contains(sparkyBumper), isTrue);
    });

    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockSparkyBumperCubit();
      whenListen(
        bloc,
        const Stream<SparkyBumperState>.empty(),
        initialState: SparkyBumperState.lit,
      );
      when(bloc.close).thenAnswer((_) async {});
      final sparkyBumper = SparkyBumper.test(bloc: bloc);

      await game.ensureAdd(sparkyBumper);
      game.remove(sparkyBumper);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('a SparkyBumperBallContactBehavior', (game) async {
        final sparkyBumper = SparkyBumper.a();
        await game.ensureAdd(sparkyBumper);
        expect(
          sparkyBumper.children
              .whereType<SparkyBumperBallContactBehavior>()
              .single,
          isNotNull,
        );
      });

      flameTester.test('a SparkyBumperBlinkingBehavior', (game) async {
        final sparkyBumper = SparkyBumper.a();
        await game.ensureAdd(sparkyBumper);
        expect(
          sparkyBumper.children
              .whereType<SparkyBumperBlinkingBehavior>()
              .single,
          isNotNull,
        );
      });
    });

    group("'a' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final sparkyBumper = SparkyBumper.a(
          children: [component],
        );
        await game.ensureAdd(sparkyBumper);
        expect(sparkyBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final sparkyBumper = SparkyBumper.a();
        await game.ensureAdd(sparkyBumper);
        expect(
          sparkyBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'b' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final sparkyBumper = SparkyBumper.b(
          children: [component],
        );
        await game.ensureAdd(sparkyBumper);
        expect(sparkyBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final sparkyBumper = SparkyBumper.b();
        await game.ensureAdd(sparkyBumper);
        expect(
          sparkyBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });

      group("'c' adds", () {
        flameTester.test('new children', (game) async {
          final component = Component();
          final sparkyBumper = SparkyBumper.c(
            children: [component],
          );
          await game.ensureAdd(sparkyBumper);
          expect(sparkyBumper.children, contains(component));
        });

        flameTester.test('a BumpingBehavior', (game) async {
          final sparkyBumper = SparkyBumper.c();
          await game.ensureAdd(sparkyBumper);
          expect(
            sparkyBumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        });
      });
    });
  });
}
