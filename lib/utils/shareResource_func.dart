import 'package:share_plus/share_plus.dart';

Future<void> shareResource(String resourceTitle, String ResourceURL) async {
  await Share.share('Check out this resource: $resourceTitle\n$ResourceURL');
}
