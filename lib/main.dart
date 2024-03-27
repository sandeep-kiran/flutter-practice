import 'package:flutter/material.dart';
import 'web_app/web_material_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const WebHome());
  // runApp(const MyApp());
}
