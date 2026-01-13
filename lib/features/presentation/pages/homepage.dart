import 'package:flutter/material.dart';
import 'package:progress/features/presentation/pages/addtrack.dart';
import 'package:progress/features/presentation/pages/progresspage.dart';
import 'package:progress/features/presentation/pages/settingpage.dart';
import 'package:progress/core/widgets/customcon.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // each track is a map returned from Addtrack (name, option, from, to)
  final List<Map<String, dynamic>> tracks = [];
  final List<bool> _selectedFlags = [];
  bool _selectionMode = false;

  void _enterSelectionMode() {
    setState(() {
      _selectionMode = true;
      while (_selectedFlags.length < tracks.length) {
        _selectedFlags.add(false);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      for (var i = 0; i < _selectedFlags.length; i++) {
        _selectedFlags[i] = false;
      }
    });
  }

  void _toggleSelectAll() {
    final allSelected =
        _selectedFlags.isNotEmpty && _selectedFlags.every((e) => e);
    setState(() {
      for (var i = 0; i < _selectedFlags.length; i++) {
        _selectedFlags[i] = !allSelected;
      }
    });
  }

  Future<void> _deleteSelected() async {
    final anySelected = _selectedFlags.any((e) => e);
    if (!anySelected) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete selected'),
        content: const Text('Are you sure you want to delete selected items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() {
      for (var i = _selectedFlags.length - 1; i >= 0; i--) {
        if (_selectedFlags[i]) {
          tracks.removeAt(i);
          _selectedFlags.removeAt(i);
        }
      }
      if (tracks.isEmpty) _selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.8, 1.4);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: (50.0 * scale),
        title: Text(
          "Progress Tracker",
          style: TextStyle(fontSize: 20 * scale, color: Colors.white),
        ),
        actions: _selectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: _toggleSelectAll,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelected,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _exitSelectionMode,
                ),
              ]
            : [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'select') _enterSelectionMode();
                    if (value == 'settings') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Settingpage(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'select', child: Text('Select')),
                    PopupMenuItem(value: 'settings', child: Text('Settings')),
                  ],
                ),
              ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0 * scale),
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          if (_selectedFlags.length < tracks.length) _selectedFlags.add(false);
          final isSelected = _selectedFlags[index];
          final name = tracks[index]['name'] as String? ?? '';

          Widget content = Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0 * scale,
              vertical: 12.0 * scale,
            ),
            child: Text(name, style: TextStyle(fontSize: 18.0 * scale)),
          );

          return Padding(
            padding: EdgeInsets.only(bottom: 8.0 * scale),
            child: Row(
              children: [
                if (_selectionMode)
                  Padding(
                    padding: EdgeInsets.only(right: 8.0 * scale),
                    child: Checkbox(
                      value: isSelected,
                      fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) => states.contains(WidgetState.selected)
                            ? Colors.blueAccent
                            : null,
                      ),
                      checkColor: Colors.white,
                      onChanged: (v) =>
                          setState(() => _selectedFlags[index] = v ?? false),
                    ),
                  ),
                Expanded(
                  child: Maincus(
                    onTap: () {
                      if (_selectionMode) {
                        setState(
                          () => _selectedFlags[index] = !_selectedFlags[index],
                        );
                      } else {
                        // pass full map so Progresspage can decide calendar logic
                        final meta = tracks[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Progresspage(title: name, meta: meta),
                          ),
                        );
                      }
                    },
                    child: AnimatedOpacity(
                      opacity: isSelected ? 0.45 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: isSelected
                            ? BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2 * scale,
                                ),
                                borderRadius: BorderRadius.circular(8 * scale),
                              )
                            : null,
                        child: content,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 70 * scale,
        width: 70 * scale,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            final result = await Navigator.push<Map<String, dynamic>?>(
              context,
              MaterialPageRoute(builder: (context) => const Addtrack()),
            );
            if (result != null &&
                (result['name'] as String?)?.isNotEmpty == true) {
              setState(() {
                tracks.insert(0, result);
                _selectedFlags.insert(0, false);
              });
            }
          },
          child: Icon(Icons.add, size: 40 * scale),
        ),
      ),
    );
  }
}
