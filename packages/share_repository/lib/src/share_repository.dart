import 'package:share_repository/share_repository.dart';

/// {@template share_repository}
/// Repository to facilitate sharing scores.
/// {@endtemplate}
class ShareRepository {
  /// {@macro share_repository}
  const ShareRepository({
    required String appUrl,
  }) : _appUrl = appUrl;

  final String _appUrl;

  /// Url to the Github Open Source Pinball project.
  static const openSourceCode = 'https://github.com/VGVentures/pinball';

  /// Url to the Google IO Event.
  static const googleIOEvent = 'https://events.google.com/io/';

  /// Url to the Pinball game.
  static const pinballGameUrl = 'https://ashehwkdkdjruejdnensjsjdne.web.app/#/';

  /// Returns a url to share the [value] on the given [platform].
  ///
  /// The returned url can be opened using the [url_launcher](https://pub.dev/packages/url_launcher) package.
  String shareText({
    required String value,
    required SharePlatform platform,
  }) {
    final encodedUrl = Uri.encodeComponent(_appUrl);
    final encodedShareText = Uri.encodeComponent(value);
    switch (platform) {
      case SharePlatform.twitter:
        return 'https://twitter.com/intent/tweet?url=$encodedUrl&text=$encodedShareText';
      case SharePlatform.facebook:
        return 'https://www.facebook.com/sharer.php?u=$encodedUrl&quote=$encodedShareText';
    }
  }
}
