import 'package:flutter/material.dart';

class Aboutpage extends StatelessWidget {
  const Aboutpage({super.key});

  static const String _appName = 'Progress Tracker';
  static const String _version = '1.0.0';
  static const String _developer = 'Joel Jacob';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // base width 390; clamp scale for small/large screens
    final double scale = (size.width / 390).clamp(0.8, 1.4);

    final double avatarRadius = (36.0 * scale).clamp(28.0, 60.0);
    final double avatarTextSize = (24.0 * scale).clamp(18.0, 36.0);
    final double headingSize = (18.0 * scale).clamp(14.0, 28.0);
    final double bodySize = (14.0 * scale).clamp(12.0, 20.0);
    final double iconSize = (28.0 * scale).clamp(20.0, 36.0);
    final double verticalSpacing = 12.0 * scale;
    final EdgeInsetsGeometry pagePadding = EdgeInsets.all(16.0 * scale);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(fontSize: (20.0 * scale).clamp(16.0, 28.0)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: avatarRadius,
                child: Text(
                  _appName.split(' ').map((e) => e[0]).take(2).join(),
                  style: TextStyle(fontSize: avatarTextSize),
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),
            ListTile(
              leading: Icon(Icons.app_registration, size: iconSize),
              title: Text('App', style: TextStyle(fontSize: headingSize)),
              subtitle: Text(_appName, style: TextStyle(fontSize: bodySize)),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.history_edu, size: iconSize),
              title: Text('Version', style: TextStyle(fontSize: headingSize)),
              subtitle: Text(_version, style: TextStyle(fontSize: bodySize)),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.person, size: iconSize),
              title: Text('Developer', style: TextStyle(fontSize: headingSize)),
              subtitle: Text(_developer, style: TextStyle(fontSize: bodySize)),
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: verticalSpacing),
            Text(
              'About the app',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalSpacing / 2),
            Text(
              'Progress Tracker helps you create and monitor progress tracks, set durations, '
              'and keep notes. Data is stored locally on your device.',
              style: TextStyle(fontSize: bodySize),
            ),
          ],
        ),
      ),
    );
  }
}
