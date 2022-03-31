import 'dart:math' as math;
import 'package:flame/components.dart';

/// Helper methods to change the [priority] of a [Component].
extension ComponentPriorityX on Component {
  static const _lowestPriority = 0;

  /// Changes the priority to a specific one.
  void sendTo(int destinationPriority) {
    if (priority != destinationPriority) {
      priority = math.max(destinationPriority, _lowestPriority);
      reorderChildren();
    }
  }

  /// Changes the priority to the lowest possible.
  void sendToBack() {
    if (priority != _lowestPriority) {
      priority = _lowestPriority;
      reorderChildren();
    }
  }

  /// Decreases the priority to be lower than another [Component].
  void showBehindOf(Component other) {
    if (priority >= other.priority) {
      priority = math.max(other.priority - 1, _lowestPriority);
      reorderChildren();
    }
  }

  /// Increases the priority to be higher than another [Component].
  void showInFrontOf(Component other) {
    if (priority <= other.priority) {
      priority = other.priority + 1;
      reorderChildren();
    }
  }
}
