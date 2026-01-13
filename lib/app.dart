import 'package:flutter/material.dart';
import 'package:progress/features/presentation/pages/homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = Colors.grey[900]!;
    final Color scaffoldBg = Colors.grey[800]!;

    return MaterialApp(
      title: 'Progress Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: appBarColor,
        scaffoldBackgroundColor: scaffoldBg,
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 15.0),
        ),
      ),
      // keep builder so MediaQuery changes are passed through (we will use MediaQuery inside pages)
      builder: (context, child) {
        return MediaQuery(
          // pass through existing MediaQuery but do not alter textScaleFactor here;
          data: MediaQuery.of(context),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const Homepage(),
    );
  }
}
