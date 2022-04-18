import 'package:intl/intl.dart';

final _numberFormat = NumberFormat('#,###');

/// Adds score related extensions to int
extension ScoreX on int {
  /// Formats this number as a score value
  String formatScore() {
    return _numberFormat.format(this);
  }
}
