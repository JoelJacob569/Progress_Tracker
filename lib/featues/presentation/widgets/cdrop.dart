import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String initialValue;
  final List<String> options;
  final Function(String) onSelected;

  const CustomDropdown({
    super.key,
    required this.initialValue,
    required this.options,
    required this.onSelected,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String _selectedValue = '';
  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  void _onOptionSelected(String value) {
    setState(() {
      _selectedValue = value;
    });
    widget.onSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      constraints: const BoxConstraints(
        maxWidth: 200.0, // Adjust width as needed
        maxHeight: 300.0, // Adjust height as needed
      ),
      onSelected: _onOptionSelected,
      initialValue: _selectedValue,
      child: Container(
        width: 150,
        height: 50,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(_selectedValue), const Icon(Icons.arrow_drop_down)],
        ),
      ),
      itemBuilder: (context) => widget.options
          .map(
            (String option) => PopupMenuItem<String>(
              value: option,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 150.0, // Adjust width as needed
                  maxHeight: 50.0, // Adjust height as needed
                ),
                child: Text(option),
              ),
            ),
          )
          .toList(),
    );
  }
}
