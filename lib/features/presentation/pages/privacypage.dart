import 'package:flutter/material.dart';

class Privacypage extends StatelessWidget {
  const Privacypage({super.key});

  static const String _lastUpdated = 'September 17, 2025';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // base width 390; clamp scale for small/large screens
    final double scale = (size.width / 390).clamp(0.8, 1.4);

    final EdgeInsetsGeometry pagePadding = EdgeInsets.all(16.0 * scale);
    final double titleSize = (20.0 * scale).clamp(16.0, 28.0);
    final double metaSize = (12.0 * scale).clamp(10.0, 16.0);
    final double headingSize = (16.0 * scale).clamp(14.0, 22.0);
    final double bodySize = (14.0 * scale).clamp(12.0, 20.0);
    final double verticalGap = 12.0 * scale;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(fontSize: (18.0 * scale).clamp(16.0, 24.0)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: (56.0 * scale).clamp(48.0, 80.0),
      ),
      body: SingleChildScrollView(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy statement',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalGap),
            Text(
              'Last updated: $_lastUpdated',
              style: TextStyle(fontSize: metaSize, color: Colors.grey),
            ),
            SizedBox(height: verticalGap),
            Text(
              'Summary',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              'This app helps you track progress and stores only the data you enter (e.g. track names, durations, and local settings). The app does not collect personal data automatically.',
              style: TextStyle(fontSize: bodySize),
            ),
            SizedBox(height: verticalGap),
            Text(
              'What we collect',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              '• User-provided data: track names, durations, notes you enter.\n'
              '• Local preferences: notification settings, UI preferences.\n'
              '• No analytics or third-party tracking is enabled by default.',
              style: TextStyle(fontSize: bodySize),
            ),
            SizedBox(height: verticalGap),
            Text(
              'How data is used',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              'Data is stored locally on your device to provide the app features. It is used only to display and manage your tracks and preferences.',
              style: TextStyle(fontSize: bodySize),
            ),
            SizedBox(height: verticalGap),
            Text(
              'Third parties and sharing',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              'The app does not send your data to external servers or share it with third parties. If you enable export or sync features in the future, those will be explained and require your consent.',
              style: TextStyle(fontSize: bodySize),
            ),
            SizedBox(height: verticalGap),
            Text(
              'Security',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              'We take reasonable measures to keep local data safe on your device. No guarantee of absolute security is made; please keep your device protected.',
              style: TextStyle(fontSize: bodySize),
            ),
            SizedBox(height: verticalGap),
            Text(
              'Your choices',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              'You can delete individual tracks or clear all data from the app. You can also disable notifications in the settings page.',
              style: TextStyle(fontSize: bodySize),
            ),
            SizedBox(height: verticalGap),
            Text(
              'Changes to this statement',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              'We may update this privacy statement. Significant changes will be indicated with an updated "Last updated" date.',
              style: TextStyle(fontSize: bodySize),
            ),
            SizedBox(height: verticalGap),
            Text(
              'Contact',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: verticalGap / 2),
            Text(
              'If you have questions about this privacy statement, please contact the app developer or use the app support channel.',
              style: TextStyle(fontSize: bodySize),
            ),
          ],
        ),
      ),
    );
  }
}
