// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/dash_nest_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockDashNestBumperCubit extends Mock implements DashNestBumperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashNestBumper', () {
    final assets = [
      Assets.images.dash.bumper.main.active.keyName,
      Assets.images.dash.bumper.main.inactive.keyName,
      Assets.images.dash.bumper.a.active.keyName,
      Assets.images.dash.bumper.a.inactive.keyName,
      Assets.images.dash.bumper.b.active.keyName,
      Assets.images.dash.bumper.b.inactive.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.test('"main" loads correctly', (game) async {
      final bumper = DashNestBumper.main();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"a" loads correctly', (game) async {
      final bumper = DashNestBumper.a();
      await game.ensureAdd(bumper);

      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final bumper = DashNestBumper.b();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockDashNestBumperCubit();
      whenListen(
        bloc,
        const Stream<DashNestBumperState>.empty(),
        initialState: DashNestBumperState.inactive,
      );
      when(bloc.close).thenAnswer((_) async {});
      final dashNestBumper = DashNestBumper.test(bloc: bloc);

      await game.ensureAdd(dashNestBumper);
      game.remove(dashNestBumper);
      await game.ready();

      verify(bloc.close).called(1);
    });

    flameTester.test('adds a DashNestBumperBallContactBehavior', (game) async {
      final dashNestBumper = DashNestBumper.a();
      await game.ensureAdd(dashNestBumper);
      expect(
        dashNestBumper.children
            .whereType<DashNestBumperBallContactBehavior>()
            .single,
        isNotNull,
      );
    });

    group("'main' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final dashNestBumper = DashNestBumper.main(
          children: [component],
        );
        await game.ensureAdd(dashNestBumper);
        expect(dashNestBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final dashNestBumper = DashNestBumper.main();
        await game.ensureAdd(dashNestBumper);
        expect(
          dashNestBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'a' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final dashNestBumper = DashNestBumper.a(
          children: [component],
        );
        await game.ensureAdd(dashNestBumper);
        expect(dashNestBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final dashNestBumper = DashNestBumper.a();
        await game.ensureAdd(dashNestBumper);
        expect(
          dashNestBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'b' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final dashNestBumper = DashNestBumper.b(
          children: [component],
        );
        await game.ensureAdd(dashNestBumper);
        expect(dashNestBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final dashNestBumper = DashNestBumper.b();
        await game.ensureAdd(dashNestBumper);
        expect(
          dashNestBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
