// ignore_for_file: prefer_const_constructors, cascade_invocations

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class _MockStream extends Mock implements Stream<void> {}

class _MockStreamSubscription extends Mock implements StreamSubscription<void> {
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('BlinkingBehavior', () {
    flameTester.testGameWidget(
      'loops for the given loops and loopDuration '
      'and calls onLoop after each loop',
      setUp: (game, tester) async {
        const loopDuration = 0.1;
        var loopCount = 0;
        final behavior = BlinkingBehavior<void>(
          loopDuration: loopDuration,
          loops: 2,
          onLoop: () => loopCount++,
        );
        final component = Component();
        await component.add(behavior);
        await game.ensureAdd(component);

        await tester.pump();
        game.update(loopDuration);

        expect(loopCount, equals(1));

        await tester.pump();
        game.update(loopDuration);

        expect(loopCount, equals(2));
      },
    );

    flameTester.testGameWidget(
      'calls onFinished after all loops',
      setUp: (game, tester) async {
        const loopDuration = 0.1;
        var onFinishedCalled = false;
        final behavior = BlinkingBehavior<void>(
          loopDuration: loopDuration,
          loops: 2,
          onFinished: () => onFinishedCalled = true,
        );
        final component = Component();
        await component.add(behavior);
        await game.ensureAdd(component);

        await tester.pump();
        game.update(loopDuration);

        await tester.pump();
        game.update(loopDuration);

        expect(onFinishedCalled, isTrue);
      },
    );

    flameTester.test(
      'adds a LoopableTimerComponent when stream and listenWhen '
      'are not provided',
      (game) async {
        const loopDuration = 0.1;
        final behavior = BlinkingBehavior<void>(
          loopDuration: loopDuration,
        );
        final component = Component();
        await component.add(behavior);
        await game.ensureAdd(component);

        expect(
          behavior.firstChild<LoopableTimerComponent>(),
          isA<LoopableTimerComponent>(),
        );
      },
    );

    flameTester.testGameWidget(
      'adds a LoopableTimerComponent only when the stream emits '
      'a state satisfying listenWhen',
      setUp: (game, tester) async {
        const loopDuration = 0.1;
        final streamController = StreamController<bool>();
        final behavior = BlinkingBehavior<bool>(
          loopDuration: loopDuration,
          stream: streamController.stream,
          listenWhen: (previousState, newState) => previousState != newState,
        );
        final component = Component();
        await component.add(behavior);
        await game.ensureAdd(component);

        streamController.add(true);
        await game.ready();
        await tester.pump();

        expect(
          behavior.firstChild<LoopableTimerComponent>(),
          isA<LoopableTimerComponent>(),
        );

        game.update(loopDuration);
        streamController.add(true);
        await game.ready();
        await tester.pump();

        expect(
          behavior.firstChild<LoopableTimerComponent>(),
          isNull,
        );

        streamController.add(false);
        await game.ready();
        await tester.pump();

        expect(
          behavior.firstChild<LoopableTimerComponent>(),
          isA<LoopableTimerComponent>(),
        );
      },
    );

    flameTester.testGameWidget(
      'closes stream subscription when behavior is removed',
      setUp: (game, tester) async {
        const loopDuration = 0.1;
        final stream = _MockStream();
        final streamSubscription = _MockStreamSubscription();
        when(() => stream.listen(any())).thenReturn(streamSubscription);
        when(streamSubscription.cancel).thenAnswer((_) async {});
        final behavior = BlinkingBehavior<void>(
          loopDuration: loopDuration,
          stream: stream,
          listenWhen: (_, __) => false,
        );
        final component = Component();
        await component.add(behavior);
        await game.ensureAdd(component);

        behavior.shouldRemove = true;
        await tester.pump();

        expect(component.contains(behavior), isFalse);
        verify(streamSubscription.cancel).called(1);
      },
    );
  });
}
