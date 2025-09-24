import 'package:flutter/material.dart';

class Notifipage extends StatefulWidget {
  const Notifipage({super.key});

  @override
  State<Notifipage> createState() => _NotifipageState();
}

class _NotifipageState extends State<Notifipage> {
  // master switch controls whether notifications are enabled at all
  bool _notificationsEnabled = true;

  // individual notification toggles
  final Map<String, bool> _items = {
    'Reminders': true,
    'Daily summary': true,
    'Goal achieved': true,
    'Streak alerts': false,
    'Promotions & tips': false,
  };

  void _setAll(bool value) {
    for (var key in _items.keys) {
      _items[key] = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // responsive scale based on device width (base 390)
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.8, 1.4);

    final double titleSize = (18.0 * scale).clamp(14.0, 24.0);
    final double subtitleSize = (13.0 * scale).clamp(11.0, 18.0);
    final double iconSize = (26.0 * scale).clamp(20.0, 36.0);
    final EdgeInsetsGeometry pagePadding = EdgeInsets.all(16.0 * scale);
    final double gap = 12.0 * scale;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: (20.0 * scale).clamp(16.0, 28.0)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: pagePadding,
        children: [
          SwitchListTile(
            title: Text(
              'Notifications enabled',
              style: TextStyle(fontSize: titleSize),
            ),
            subtitle: Text(
              'Turn off to disable all notifications',
              style: TextStyle(fontSize: subtitleSize),
            ),
            value: _notificationsEnabled,
            onChanged: (v) => setState(() {
              _notificationsEnabled = v;
              if (!v) _setAll(false);
            }),
            secondary: Icon(Icons.notifications_active, size: iconSize),
            contentPadding: EdgeInsets.symmetric(vertical: 4.0 * scale),
          ),
          Divider(thickness: 1.0 * scale, height: gap),
          // individual notification options
          ..._items.keys.map((key) {
            return SwitchListTile(
              title: Text(key, style: TextStyle(fontSize: titleSize)),
              value: _items[key]!,
              onChanged: _notificationsEnabled
                  ? (val) => setState(() {
                      _items[key] = val;
                    })
                  : null, // disabled when master switch is off
              secondary: Icon(Icons.notifications, size: iconSize),
              contentPadding: EdgeInsets.symmetric(vertical: 2.0 * scale),
              subtitle: !_notificationsEnabled
                  ? Text(
                      'Disabled',
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            );
          }),
          SizedBox(height: 16.0 * scale),
          ElevatedButton.icon(
            icon: Icon(Icons.save, size: iconSize * 0.8),
            label: Text('Apply', style: TextStyle(fontSize: titleSize)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 12.0 * scale,
                horizontal: 16.0 * scale,
              ),
            ),
            onPressed: () {
              // currently in-memory only; hook persistence here if needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification preferences updated'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
