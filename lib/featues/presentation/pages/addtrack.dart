import 'package:flutter/material.dart';
import 'package:progress/featues/presentation/widgets/cdrop.dart';
import 'package:progress/featues/presentation/widgets/textformfield.dart';

class Addtrack extends StatefulWidget {
  const Addtrack({super.key});

  @override
  State<Addtrack> createState() => _AddtrackState();
}

class _AddtrackState extends State<Addtrack> {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  String selectedopt = "Option";

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void dispose() {
    namecontroller.dispose();
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext ctx, bool isFrom, double scale) async {
    final now = DateTime.now();
    final first = DateTime(now.year - 5);
    final last = DateTime(now.year + 5);
    final picked = await showDatePicker(
      context: ctx,
      initialDate: isFrom ? (fromDate ?? now) : (toDate ?? now),
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          fromController.text = '${picked.day}/${picked.month}/${picked.year}';
        } else {
          toDate = picked;
          toController.text = '${picked.day}/${picked.month}/${picked.year}';
        }
      });
    }
  }

  // helper to build a duration row; label can be "From" or "To"
  Widget _buildDurationRow(String label, double scale) {
    final controller = label == 'From' ? fromController : toController;
    final isDateMode = selectedopt == "Date";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0 * scale),
      child: Row(
        children: [
          if (isDateMode) Text(label, style: TextStyle(fontSize: 16.0 * scale)),
          if (isDateMode) SizedBox(width: 8.0 * scale),
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: isDateMode,
              onTap: isDateMode
                  ? () => _pickDate(context, label == 'From', scale)
                  : null,
              decoration: InputDecoration(
                hintText: isDateMode
                    ? (label == 'From'
                          ? (fromDate == null
                                ? 'Select date'
                                : fromController.text)
                          : (toDate == null
                                ? 'Select date'
                                : toController.text))
                    : 'Enter value',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0 * scale,
                  horizontal: 12.0 * scale,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(fontSize: 14.0 * scale),
            ),
          ),
          SizedBox(width: 8.0 * scale),
          CustomDropdown(
            initialValue: selectedopt == "Option" ? "Select" : selectedopt,
            options: ["Select", "Date", "Week(s)", "Month(s)", "Year(s)"],
            onSelected: (value) => setState(() {
              selectedopt = value;
              // clear dates when switching away from Date; also clear controllers if switching
              if (value != 'Date') {
                fromDate = null;
                toDate = null;
                fromController.text = '';
                toController.text = '';
              }
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.8, 1.4);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Track", style: TextStyle(fontSize: 20.0 * scale)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0 * scale),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add your tracking details here.",
                style: TextStyle(fontSize: 16.0 * scale),
              ),
              SizedBox(height: 8.0 * scale),
              CustomTextfield(text: "Name", control: namecontroller),
              SizedBox(height: 12.0 * scale),
              Text("Duration", style: TextStyle(fontSize: 16.0 * scale)),
              _buildDurationRow("From", scale),
              if (selectedopt == "Date") _buildDurationRow("To", scale),
              SizedBox(height: 16.0 * scale),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = namecontroller.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a name')),
                      );
                      return;
                    }
                    // return a map with name and optional dates/option.
                    // for non-date options from/to will contain manual text values if provided.
                    Navigator.pop(context, <String, dynamic>{
                      'name': name,
                      'option': selectedopt,
                      'from':
                          fromDate?.toIso8601String() ??
                          (fromController.text.isNotEmpty
                              ? fromController.text
                              : null),
                      'to':
                          toDate?.toIso8601String() ??
                          (toController.text.isNotEmpty
                              ? toController.text
                              : null),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    fixedSize: Size(160 * scale, 48 * scale),
                  ),
                  child: Text(
                    "Track",
                    style: TextStyle(
                      fontSize: 16.0 * scale,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
