// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.androidBumper.a.lit.keyName,
    Assets.images.androidBumper.a.dimmed.keyName,
    Assets.images.androidBumper.b.lit.keyName,
    Assets.images.androidBumper.b.dimmed.keyName,
    Assets.images.androidBumper.cow.lit.keyName,
    Assets.images.androidBumper.cow.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('AndroidBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final androidBumper = AndroidBumper.a();
      await game.ensureAdd(androidBumper);
      expect(game.contains(androidBumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final androidBumper = AndroidBumper.b();
      await game.ensureAdd(androidBumper);
      expect(game.contains(androidBumper), isTrue);
    });

    flameTester.test('"cow" loads correctly', (game) async {
      final androidBumper = AndroidBumper.cow();
      await game.ensureAdd(androidBumper);
      expect(game.contains(androidBumper), isTrue);
    });

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = MockAndroidBumperCubit();
      whenListen(
        bloc,
        const Stream<AndroidBumperState>.empty(),
        initialState: AndroidBumperState.lit,
      );
      when(bloc.close).thenAnswer((_) async {});
      final androidBumper = AndroidBumper.test(bloc: bloc);

      await game.ensureAdd(androidBumper);
      game.remove(androidBumper);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final androidBumper = AndroidBumper.a(
          children: [component],
        );
        await game.ensureAdd(androidBumper);
        expect(androidBumper.children, contains(component));
      });

      flameTester.test('an AndroidBumperBallContactBehavior', (game) async {
        final androidBumper = AndroidBumper.a();
        await game.ensureAdd(androidBumper);
        expect(
          androidBumper.children
              .whereType<AndroidBumperBallContactBehavior>()
              .single,
          isNotNull,
        );
      });
    });
  });
}
