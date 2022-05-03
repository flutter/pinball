// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

class _MockSignpostCubit extends Mock implements SignpostCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('Signpost', () {
    const goldenPath = '../golden/signpost/';

    flameTester.test(
      'loads correctly',
      (game) async {
        final signpost = Signpost();
        await game.ensureAdd(signpost);
        expect(game.contains(signpost), isTrue);
      },
    );

    group('renders correctly', () {
      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final signpost = Signpost();
          await game.ensureAdd(signpost);
          await tester.pump();

          expect(
            signpost.bloc.state,
            equals(SignpostState.inactive),
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenPath}inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final signpost = Signpost();
          await game.ensureAdd(signpost);
          signpost.bloc.onProgressed();
          await tester.pump();

          expect(
            signpost.bloc.state,
            equals(SignpostState.active1),
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenPath}active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final signpost = Signpost();
          await game.ensureAdd(signpost);
          signpost.bloc
            ..onProgressed()
            ..onProgressed();
          await tester.pump();

          expect(
            signpost.bloc.state,
            equals(SignpostState.active2),
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenPath}active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final signpost = Signpost();
          await game.ensureAdd(signpost);

          signpost.bloc
            ..onProgressed()
            ..onProgressed()
            ..onProgressed();
          await tester.pump();

          expect(
            signpost.bloc.state,
            equals(SignpostState.active3),
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenPath}active3.png'),
          );
        },
      );
    });

    flameTester.test('adds new children', (game) async {
      final component = Component();
      final signpost = Signpost(
        children: [component],
      );
      await game.ensureAdd(signpost);
      expect(signpost.children, contains(component));
    });

    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockSignpostCubit();
      whenListen(
        bloc,
        const Stream<SignpostCubit>.empty(),
        initialState: SignpostState.inactive,
      );
      when(bloc.close).thenAnswer((_) async {});
      final component = Signpost.test(bloc: bloc);

      await game.ensureAdd(component);
      game.remove(component);
      await game.ready();

      verify(bloc.close).called(1);
    });
  });
}
