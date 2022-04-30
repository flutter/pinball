// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiplier.x2.lit.keyName,
    Assets.images.multiplier.x2.dimmed.keyName,
    Assets.images.multiplier.x3.lit.keyName,
    Assets.images.multiplier.x3.dimmed.keyName,
    Assets.images.multiplier.x4.lit.keyName,
    Assets.images.multiplier.x4.dimmed.keyName,
    Assets.images.multiplier.x5.lit.keyName,
    Assets.images.multiplier.x5.dimmed.keyName,
    Assets.images.multiplier.x6.lit.keyName,
    Assets.images.multiplier.x6.dimmed.keyName,
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

  group('Multipliers', () {
    flameBlocTester.testGameWidget(
      'loads correctly',
      setUp: (game, tester) async {
        final multipliersGroup = Multipliers();
        await game.ensureAdd(multipliersGroup);

        expect(game.contains(multipliersGroup), isTrue);
      },
    );

    group('loads', () {
      flameBlocTester.testGameWidget(
        'five Multiplier',
        setUp: (game, tester) async {
          final multipliersGroup = Multipliers();
          await game.ensureAdd(multipliersGroup);

          expect(
            multipliersGroup.descendants().whereType<Multiplier>().length,
            equals(5),
          );
        },
      );
    });
  });
}
