import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// [PinballGame] extension to reduce boilerplate in tests.
extension PinballGameTest on PinballGame {
  /// Create [PinballGame] with default [PinballTheme].
  static PinballGame create() => PinballGame(
        theme: const PinballTheme(
          characterTheme: DashTheme(),
        ),
      )..images.prefix = '';
}

/// [DebugPinballGame] extension to reduce boilerplate in tests.
extension DebugPinballGameTest on DebugPinballGame {
  /// Create [PinballGame] with default [PinballTheme].
  static DebugPinballGame create() => DebugPinballGame(
        theme: const PinballTheme(
          characterTheme: DashTheme(),
        ),
      );
}

extension ComponentX on Component {
  T findNestedChild<T extends Component>({
    bool Function(T)? condition,
  }) {
    T? nestedChild;
    propagateToChildren<T>((child) {
      final foundChild = (condition ?? (_) => true)(child);
      if (foundChild) {
        nestedChild = child;
      }

      return !foundChild;
    });

    if (nestedChild == null) {
      throw Exception('No child of type $T found.');
    } else {
      return nestedChild!;
    }
  }

  List<T> findNestedChildren<T extends Component>({
    bool Function(T)? condition,
  }) {
    final nestedChildren = <T>[];
    propagateToChildren<T>((child) {
      final foundChild = (condition ?? (_) => true)(child);
      if (foundChild) {
        nestedChildren.add(child);
      }

      return true;
    });

    return nestedChildren;
  }
}
