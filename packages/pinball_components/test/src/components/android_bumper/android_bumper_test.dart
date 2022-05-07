// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_bumper/behaviors/behaviors.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';

import '../../../helpers/helpers.dart';

class _MockAndroidBumperCubit extends Mock implements AndroidBumperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.bumper.a.lit.keyName,
    Assets.images.android.bumper.a.dimmed.keyName,
    Assets.images.android.bumper.b.lit.keyName,
    Assets.images.android.bumper.b.dimmed.keyName,
    Assets.images.android.bumper.cow.lit.keyName,
    Assets.images.android.bumper.cow.dimmed.keyName,
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

    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockAndroidBumperCubit();
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

      flameTester.test('an AndroidBumperBlinkingBehavior', (game) async {
        final androidBumper = AndroidBumper.a();
        await game.ensureAdd(androidBumper);
        expect(
          androidBumper.children
              .whereType<AndroidBumperBlinkingBehavior>()
              .single,
          isNotNull,
        );
      });
    });

    group("'a' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final androidBumper = AndroidBumper.a(
          children: [component],
        );
        await game.ensureAdd(androidBumper);
        expect(androidBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final androidBumper = AndroidBumper.a();
        await game.ensureAdd(androidBumper);
        expect(
          androidBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'b' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final androidBumper = AndroidBumper.b(
          children: [component],
        );
        await game.ensureAdd(androidBumper);
        expect(androidBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final androidBumper = AndroidBumper.b();
        await game.ensureAdd(androidBumper);
        expect(
          androidBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });

    group("'cow' adds", () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final androidBumper = AndroidBumper.cow(
          children: [component],
        );
        await game.ensureAdd(androidBumper);
        expect(androidBumper.children, contains(component));
      });

      flameTester.test('a BumpingBehavior', (game) async {
        final androidBumper = AndroidBumper.cow();
        await game.ensureAdd(androidBumper);
        expect(
          androidBumper.children.whereType<BumpingBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
