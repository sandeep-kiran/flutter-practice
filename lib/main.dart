import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'presigned_url/presigned_url.dart';

void main() {
  usePathUrlStrategy();
  // runApp(const AdaptiveLayoutPractice());
  // runApp(const WebHome());
  // runApp(const MyApp());
  // runApp(const MultipartUploadHome());
  runApp(const PresignedURL());
}
