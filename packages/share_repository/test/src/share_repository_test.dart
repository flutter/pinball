// ignore_for_file: prefer_const_constructors
import 'package:share_repository/share_repository.dart';
import 'package:test/test.dart';

void main() {
  group('ShareRepository', () {
    const appUrl = 'https://fakeurl.com/';
    late ShareRepository shareRepository;

    setUp(() {
      shareRepository = ShareRepository(appUrl: appUrl);
    });

    test('can be instantiated', () {
      expect(ShareRepository(appUrl: appUrl), isNotNull);
    });

    group('shareText', () {
      const shareText = 'hello world!';
      test('returns the correct share url for twitter', () async {
        const shareScoreUrl =
            'https://twitter.com/intent/tweet?url=https%3A%2F%2Ffakeurl.com%2F&text=hello%20world!';
        final shareScoreResult = shareRepository.shareText(
          value: shareText,
          platform: SharePlatform.twitter,
        );
        expect(shareScoreResult, equals(shareScoreUrl));
      });

      test('returns the correct share url for facebook', () async {
        const shareScoreUrl =
            'https://www.facebook.com/sharer.php?u=https%3A%2F%2Ffakeurl.com%2F&quote=hello%20world!';
        final shareScoreResult = shareRepository.shareText(
          value: shareText,
          platform: SharePlatform.facebook,
        );
        expect(shareScoreResult, equals(shareScoreUrl));
      });
    });
  });
}
