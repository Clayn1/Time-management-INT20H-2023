import 'package:url_launcher/url_launcher.dart';

abstract class ExternalLaunchers {
  static Future<void> openUrl({required String url}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
