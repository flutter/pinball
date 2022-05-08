// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/dash_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockDashBumperCubit extends Mock implements DashBumperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashBumper', () {
    final flameTester = FlameTester(
      () => TestGame(
        [
          Assets.images.dash.bumper.main.active.keyName,
          Assets.images.dash.bumper.main.inactive.keyName,
          Assets.images.dash.bumper.a.active.keyName,
          Assets.images.dash.bumper.a.inactive.keyName,
          Assets.images.dash.bumper.b.active.keyName,
          Assets.images.dash.bumper.b.inactive.keyName,
        ],
      ),
    );

    flameTester.test('"main" loads correctly', (game) async {
      final bumper = DashBumper.main();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"a" loads correctly', (game) async {
      final bumper = DashBumper.a();
      await game.ensureAdd(bumper);

      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final bumper = DashBumper.b();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockDashBumperCubit();
      whenListen(
        bloc,
        const Stream<DashBumperState>.empty(),
        initialState: DashBumperState.inactive,
      );
      when(bloc.close).thenAnswer((_) async {});
      final bumper = DashBumper.test(bloc: bloc);

      await game.ensureAdd(bumper);
      game.remove(bumper);
      await game.ready();

      verify(bloc.close).called(1);
    });

    flameTester.test('adds a bumperBallContactBehavior', (game) async {
      final bumper = DashBumper.a();
      await game.ensureAdd(bumper);
      expect(
        bumper.children.whereType<DashBumperBallContactBehavior>().single,
        isNotNull,
      );
    });

    group("'main' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final bumper = DashBumper.main(
          children: [component],
        );
        await game.ensureAdd(bumper);
        expect(bumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final bumper = DashBumper.main();
        await game.ensureAdd(bumper);
        expect(
          bumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'a' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final bumper = DashBumper.a(
          children: [component],
        );
        await game.ensureAdd(bumper);
        expect(bumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final bumper = DashBumper.a();
        await game.ensureAdd(bumper);
        expect(
          bumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'b' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final bumper = DashBumper.b(
          children: [component],
        );
        await game.ensureAdd(bumper);
        expect(bumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final bumper = DashBumper.b();
        await game.ensureAdd(bumper);
        expect(
          bumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
