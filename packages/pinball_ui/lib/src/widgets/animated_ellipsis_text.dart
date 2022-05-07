import 'dart:async';

import 'package:flutter/material.dart';

/// {@template animated_ellipsis_text}
/// Every 500 milliseconds, it will add a new `.` at the end of the given
/// [text]. Once 3 `.` have been added (e.g. `Loading...`), it will reset to
/// zero ellipsis and start over again.
/// {@endtemplate}
class AnimatedEllipsisText extends StatefulWidget {
  /// {@macro animated_ellipsis_text}
  const AnimatedEllipsisText(
    this.text, {
    Key? key,
    this.style,
  }) : super(key: key);

  /// The text that will be animated.
  final String text;

  /// Optional [TextStyle] of the given [text].
  final TextStyle? style;

  @override
  State<StatefulWidget> createState() => _AnimatedEllipsisText();
}

class _AnimatedEllipsisText extends State<AnimatedEllipsisText>
    with SingleTickerProviderStateMixin {
  late final Timer timer;
  var _numberOfEllipsis = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _numberOfEllipsis++;
        _numberOfEllipsis = _numberOfEllipsis % 4;
      });
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.text}${_numberOfEllipsis.toEllipsis()}',
      style: widget.style,
    );
  }
}

extension on int {
  String toEllipsis() => '.' * this;
}
