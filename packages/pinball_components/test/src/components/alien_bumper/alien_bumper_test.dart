// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/alien_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.alienBumper.a.active.keyName,
    Assets.images.alienBumper.a.inactive.keyName,
    Assets.images.alienBumper.b.active.keyName,
    Assets.images.alienBumper.b.inactive.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('AlienBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final alienBumper = AlienBumper.a();
      await game.ensureAdd(alienBumper);
      expect(game.contains(alienBumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final alienBumper = AlienBumper.b();
      await game.ensureAdd(alienBumper);
      expect(game.contains(alienBumper), isTrue);
    });

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = MockAlienBumperCubit();
      whenListen(
        bloc,
        const Stream<AlienBumperState>.empty(),
        initialState: AlienBumperState.active,
      );
      when(bloc.close).thenAnswer((_) async {});
      final alienBumper = AlienBumper.test(bloc: bloc);

      await game.ensureAdd(alienBumper);
      game.remove(alienBumper);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final alienBumper = AlienBumper.a(
          children: [component],
        );
        await game.ensureAdd(alienBumper);
        expect(alienBumper.children, contains(component));
      });

      flameTester.test('an AlienBumperBallContactBehavior', (game) async {
        final alienBumper = AlienBumper.a();
        await game.ensureAdd(alienBumper);
        expect(
          alienBumper.children
              .whereType<AlienBumperBallContactBehavior>()
              .single,
          isNotNull,
        );
      });
    });
  });
}
