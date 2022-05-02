// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiball.lit.keyName,
    Assets.images.multiball.dimmed.keyName,
  ];
  late GameBloc gameBloc;

  setUp(() {
    gameBloc = GameBloc();
  });

  final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
    gameBuilder: EmptyPinballTestGame.new,
    blocBuilder: () => gameBloc,
    assets: assets,
  );

  group('Multiballs', () {
    flameBlocTester.testGameWidget(
      'loads correctly',
      setUp: (game, tester) async {
        final multiballs = Multiballs();
        await game.ensureAdd(multiballs);

        expect(game.contains(multiballs), isTrue);
      },
    );

    group('loads', () {
      flameBlocTester.testGameWidget(
        'four Multiball',
        setUp: (game, tester) async {
          final multiballs = Multiballs();
          await game.ensureAdd(multiballs);

          expect(
            multiballs.descendants().whereType<Multiball>().length,
            equals(4),
          );
        },
      );
    });
  });
}
