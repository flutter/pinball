// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

extension _IterableX on Iterable<Component> {
  int countTexts(String value) {
    return where(
      (component) => component is TextComponent && component.text == value,
    ).length;
  }
}

void main() {
  group('ErrorComponent', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.errorBackground.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, _) async {
        await game.ensureAdd(ErrorComponent(label: 'Error Message'));
      },
      verify: (game, _) async {
        final count = game.descendants().countTexts('Error Message');
        expect(count, equals(1));
      },
    );

    group('when the text is longer than one line', () {
      flameTester.testGameWidget(
        'renders correctly',
        setUp: (game, _) async {
          await game.ensureAdd(
            ErrorComponent(
              label: 'Error With A Longer Message',
            ),
          );
        },
        verify: (game, _) async {
          final count1 = game.descendants().countTexts('Error With A');
          final count2 = game.descendants().countTexts('Longer Message');

          expect(count1, equals(1));
          expect(count2, equals(1));
        },
      );
    });

    group('when using the bold font', () {
      flameTester.testGameWidget(
        'renders correctly',
        setUp: (game, _) async {
          await game.ensureAdd(ErrorComponent.bold(label: 'Error Message'));
        },
        verify: (game, _) async {
          final count = game.descendants().countTexts('Error Message');

          expect(count, equals(1));
        },
      );
    });
  });
}
