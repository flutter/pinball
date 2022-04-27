// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.dash.animatronic.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('FlutterForest', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final flutterForest = FlutterForest();
        await game.ensureAdd(flutterForest);
        expect(game.contains(flutterForest), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'a Signpost',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.descendants().whereType<Signpost>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a DashAnimatronic',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.firstChild<DashAnimatronic>(),
            isNotNull,
          );
        },
      );

      flameTester.test(
        'three DashNestBumper',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.descendants().whereType<DashNestBumper>().length,
            equals(3),
          );
        },
      );
    });

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = MockFlutterForestCubit();
      whenListen(
        bloc,
        const Stream<FlutterForestState>.empty(),
        initialState: const FlutterForestState.initial(),
      );
      when(bloc.close).thenAnswer((_) async {});
      final flutterForest = FlutterForest.test(bloc: bloc);

      await game.ensureAdd(flutterForest);
      game.remove(flutterForest);
      await game.ready();

      verify(bloc.close).called(1);
    });
  });
}
