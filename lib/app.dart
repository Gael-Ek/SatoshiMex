import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/router/app_router.dart';
import 'package:satoshimex/core/config/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SatoshiMex',
      routerConfig: approuter,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
