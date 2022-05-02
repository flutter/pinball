import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

bool tapTextSpan(RichText richText, String text) {
  final isTapped = !richText.text.visitChildren(
    (visitor) => _findTextAndTap(visitor, text),
  );
  return isTapped;
}

bool _findTextAndTap(InlineSpan visitor, String text) {
  if (visitor is TextSpan && visitor.text == text) {
    (visitor.recognizer as TapGestureRecognizer?)?.onTap?.call();
    return false;
  }
  return true;
}
