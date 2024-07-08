// ignore_for_file: cascade_invocations

import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _FakeCubit extends Fake implements Cubit<Object> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(FlameGame.new);

  group(
    'FlameProvider',
    () {
      test('can be instantiated', () {
        expect(
          FlameProvider<bool>.value(true),
          isA<FlameProvider<bool>>(),
        );
      });

      flameTester.testGameWidget(
        'can be loaded',
        setUp: (game, _) async {
          final component = FlameProvider<bool>.value(true);
          await game.ensureAdd(component);
        },
        verify: (game, _) async {
          expect(
            game.children.whereType<FlameProvider<bool>>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'adds children',
        setUp: (game, _) async {
          final component = Component();
          final provider = FlameProvider<bool>.value(
            true,
            children: [component],
          );
          await game.ensureAdd(provider);
        },
        verify: (game, _) async {
          final provider =
              game.descendants().whereType<FlameProvider<bool>>().single;
          expect(
            provider.children.whereType<Component>().length,
            equals(1),
          );
        },
      );
    },
  );

  group('MultiFlameProvider', () {
    test('can be instantiated', () {
      expect(
        MultiFlameProvider(
          providers: [
            FlameProvider<bool>.value(true),
          ],
        ),
        isA<MultiFlameProvider>(),
      );
    });

    flameTester.testGameWidget(
      'adds multiple providers',
      setUp: (game, _) async {
        final provider1 = FlameProvider<bool>.value(true);
        final provider2 = FlameProvider<bool>.value(true);
        final providers = MultiFlameProvider(
          providers: [provider1, provider2],
        );
        await game.ensureAdd(providers);
      },
      verify: (game, _) async {
        final providers =
            game.descendants().whereType<MultiFlameProvider>().single;
        expect(
          providers.children.whereType<FlameProvider<bool>>().length,
          equals(1),
        );
        final provider1 =
            providers.children.whereType<FlameProvider<bool>>().single;
        expect(
          provider1.children.whereType<FlameProvider<bool>>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'adds children under provider',
      setUp: (game, _) async {
        final component = Component();
        final provider = FlameProvider<bool>.value(true);
        final providers = MultiFlameProvider(
          providers: [provider],
          children: [component],
        );
        await game.ensureAdd(providers);
      },
      verify: (game, _) async {
        final provider =
            game.descendants().whereType<FlameProvider<bool>>().single;
        expect(provider.children.whereType<Component>().length, equals(1));
      },
    );
  });

  group(
    'ReadFlameProvider',
    () {
      flameTester.testGameWidget(
        'loads provider',
        setUp: (game, _) async {
          final component = Component();
          final provider = FlameProvider<bool>.value(
            true,
            children: [component],
          );
          await game.ensureAdd(provider);
        },
        verify: (game, _) async {
          final component = game
              .descendants()
              .whereType<FlameProvider<bool>>()
              .single
              .children
              .first;
          expect(component.readProvider<bool>(), isTrue);
        },
      );

      flameTester.testGameWidget(
        'throws assertionError when no provider is found',
        setUp: (game, _) async {
          final component = Component();
          await game.ensureAdd(component);
          expect(
            () => component.readProvider<bool>(),
            throwsAssertionError,
          );
        },
      );
    },
  );

  group(
    'ReadFlameBlocProvider',
    () {
      flameTester.testGameWidget(
        'loads provider',
        setUp: (game, _) async {
          final component = Component();
          final bloc = _FakeCubit();
          final provider = FlameBlocProvider<_FakeCubit, Object>.value(
            value: bloc,
            children: [component],
          );
          await game.ensureAdd(provider);
        },
        verify: (game, _) async {
          final provider = game
              .descendants()
              .whereType<FlameBlocProvider<_FakeCubit, Object>>()
              .single;
          expect(
            provider.children.first.readBloc<_FakeCubit, Object>(),
            equals(provider.bloc),
          );
        },
      );

      flameTester.testGameWidget(
        'throws assertionError when no provider is found',
        setUp: (game, _) async {
          final component = Component();
          await game.ensureAdd(component);
        },
        verify: (game, _) async {
          final component = game.descendants().whereType<Component>().first;
          expect(
            () => component.readBloc<_FakeCubit, Object>(),
            throwsAssertionError,
          );
        },
      );
    },
  );
}
