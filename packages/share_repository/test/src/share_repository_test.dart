// ignore_for_file: prefer_const_constructors
import 'package:share_repository/share_repository.dart';
import 'package:test/test.dart';

void main() {
  group('ShareRepository', () {
    late ShareRepository shareRepository;

    setUp(() {
      shareRepository = ShareRepository();
    });

    group('constructor', () {
      test('creates new ShareRepository instance', () {
        expect(ShareRepository(), isNotNull);
      });
    });

    group('shareScore', () {
      const shareText = 'hello world!';
      test('returns the correct share url for twitter', () async {
        expect(
          shareRepository.shareScore(
            shareText: shareText,
            platform: SharePlatform.twitter,
          ),
          equals(
            'https://twitter.com/intent/tweet?url=https%3A%2F%2Fashehwkdkdjruejdnensjsjdne.web.app%2F%23%2F&text=hello%20world!',
          ),
        );
      });

      test('returns the correct share url for facebook', () async {
        expect(
          shareRepository.shareScore(
            shareText: shareText,
            platform: SharePlatform.facebook,
          ),
          equals(
            'https://www.facebook.com/sharer.php?u=https%3A%2F%2Fashehwkdkdjruejdnensjsjdne.web.app%2F%23%2F&quote=hello%20world!',
          ),
        );
      });
    });
  });
}
