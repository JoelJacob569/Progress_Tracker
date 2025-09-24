import 'package:flutter/material.dart';
import 'package:progress/featues/presentation/pages/aboutpage.dart';
import 'package:progress/featues/presentation/pages/notifipage.dart';
import 'package:progress/featues/presentation/pages/privacypage.dart';

class Settingpage extends StatefulWidget {
  const Settingpage({super.key});

  @override
  State<Settingpage> createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.8, 1.4);

    final EdgeInsetsGeometry pagePadding = EdgeInsets.all(16.0 * scale);
    final double toolbarH = (56.0 * scale).clamp(48.0, 80.0);
    final double iconSize = (28.0 * scale).clamp(20.0, 36.0);
    final double titleSize = (16.0 * scale).clamp(14.0, 22.0);
    final double subtitleSize = (13.0 * scale).clamp(11.0, 18.0);
    final double gap = 8.0 * scale;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: (18.0 * scale).clamp(16.0, 28.0)),
        ),
        toolbarHeight: toolbarH,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: pagePadding,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: gap, horizontal: 0),
            leading: Icon(Icons.notifications, size: iconSize),
            title: Text('Notifications', style: TextStyle(fontSize: titleSize)),
            subtitle: Text(
              'Manage notification preferences',
              style: TextStyle(fontSize: subtitleSize),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifipage()),
              );
            },
          ),
          Divider(height: gap * 2, thickness: 1.0 * scale),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: gap, horizontal: 0),
            leading: Icon(Icons.lock, size: iconSize),
            title: Text('Privacy', style: TextStyle(fontSize: titleSize)),
            subtitle: Text(
              'View privacy policy',
              style: TextStyle(fontSize: subtitleSize),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Privacypage()),
              );
            },
          ),
          Divider(height: gap * 2, thickness: 1.0 * scale),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: gap, horizontal: 0),
            leading: Icon(Icons.info, size: iconSize),
            title: Text('About', style: TextStyle(fontSize: titleSize)),
            subtitle: Text(
              'App and developer information',
              style: TextStyle(fontSize: subtitleSize),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Aboutpage()),
              );
            },
          ),
          SizedBox(height: 12.0 * scale),
        ],
      ),
    );
  }
}
