import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  group('AssetsManagerCubit', () {
    final completer1 = Completer<void>();
    final completer2 = Completer<void>();

    final future1 = completer1.future;
    final future2 = completer2.future;

    blocTest<AssetsManagerCubit, AssetsManagerState>(
      'emits the loaded on the order that they load',
      build: () => AssetsManagerCubit([future1, future2]),
      act: (cubit) {
        cubit.load();
        completer2.complete();
        completer1.complete();
      },
      expect: () => [
        AssetsManagerState(
          loadables: [future1, future2],
          loaded: [future2],
        ),
        AssetsManagerState(
          loadables: [future1, future2],
          loaded: [future2, future1],
        ),
      ],
    );
  });
}
