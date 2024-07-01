import 'dart:async';

import 'package:flame/components.dart';

/// A mixin that ensures a parent is of the given type [T].
mixin ParentIsAOld<T extends Component> on Component {
  @override
  T get parent => super.parent! as T;

  @override
  FutureOr<void> addToParent(covariant T parent) {
    return super.addToParent(parent);
  }
}
