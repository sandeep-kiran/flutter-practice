import 'package:first_app/web_app/core/routes.dart';
import 'package:first_app/web_app/core/theme/system_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class WebHome extends StatelessWidget {
  const WebHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'First App',
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      themeMode: ThemeMode.system,
      theme: theme(),
      routerConfig: routes,
    );
  }
}
