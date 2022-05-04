import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('ScoreX', () {
    test('formatScore correctly formats int', () {
      expect(1000000.formatScore(), '1,000,000');
    });
  });
}
