import 'package:share_repository/share_repository.dart';

/// {@template share_repository}
/// Repository to facilitate sharing scores.
/// {@endtemplate}
class ShareRepository {
  /// {@macro share_repository}
  const ShareRepository();

  // TODO(jonathandaniels-vgv): Change to prod url.
  static const _shareUrl = 'https://ashehwkdkdjruejdnensjsjdne.web.app/#/';

  /// Returns a url to share the [shareText] on the given [platform].
  ///
  /// The returned url can be opened using the [url_launcher](https://pub.dev/packages/url_launcher) package.
  ///
  /// The [shareText] must have the score embedded.
  String shareScore({
    required String shareText,
    required SharePlatform platform,
  }) {
    final encodedUrl = Uri.encodeComponent(_shareUrl);
    final encodedShareText = Uri.encodeComponent(shareText);
    switch (platform) {
      case SharePlatform.twitter:
        return 'https://twitter.com/intent/tweet?url=$encodedUrl&text=$encodedShareText';
      case SharePlatform.facebook:
        return 'https://www.facebook.com/sharer.php?u=$encodedUrl&quote=$encodedShareText';
    }
  }
}
