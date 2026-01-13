import 'package:flutter/material.dart';
import 'package:progress/core/widgets/cdrop.dart';
import 'package:progress/core/widgets/textformfield.dart';
import 'package:intl/intl.dart';

class Addtrack extends StatefulWidget {
  const Addtrack({super.key});

  @override
  State<Addtrack> createState() => _AddtrackState();
}

class _AddtrackState extends State<Addtrack> {
  bool useCustomTime = false;
  DateTime? customStartDate;
  DateTime? customEndDate;
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  String selectedopt = "Option";

  @override
  void dispose() {
    namecontroller.dispose();
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  // helper to build a duration row; label can be "From" or "To"
  Widget _buildDurationRow(String label, double scale) {
    final controller = label == 'From' ? fromController : toController;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0 * scale),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 16.0 * scale)),
          SizedBox(width: 8.0 * scale),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter value',
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
            options: ["Select", "Week(s)", "Month(s)", "Year(s)"],
            onSelected: (value) => setState(() {
              selectedopt = value;
              fromController.clear();
              toController.clear();
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate2({required bool isStart}) async {
    final initialDate = isStart
        ? (customStartDate ?? DateTime.now())
        : (customEndDate ?? customStartDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted || picked == null) return;

    if (!isStart && customStartDate != null) {
      if (picked.isBefore(customStartDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("End date cannot be before start date")),
        );
        return;
      }
    }

    setState(() {
      if (isStart) {
        customStartDate = picked;

        // Reset end date if invalid
        if (customEndDate != null && customEndDate!.isBefore(picked)) {
          customEndDate = null;
        }
      } else {
        customEndDate = picked;
      }
    });
  }

  Widget _timeTile({
    required String label,
    required String value,
    required double scale,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12 * scale),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Row(
              children: [
                Text(value, style: const TextStyle(color: Colors.white70)),
                SizedBox(width: 8 * scale),
                const Icon(Icons.access_time, color: Colors.white70, size: 18),
              ],
            ),
          ],
        ),
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
              _buildDurationRow("", scale),
              // if (selectedopt == "Date") _buildDurationRow("To", scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Use custom time",
                    style: TextStyle(
                      fontSize: 16.0 * scale,
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    value: useCustomTime,
                    onChanged: (value) {
                      setState(() {
                        useCustomTime = value;
                      });
                    },
                  ),
                ],
              ),

              if (useCustomTime) ...[
                SizedBox(height: 8.0 * scale),

                GestureDetector(
                  onTap: () => _pickDate2(isStart: true),
                  child: _timeTile(
                    label: "Start Date",
                    value: customStartDate == null
                        ? "--/--/----"
                        : DateFormat.yMMMd().format(customStartDate!),
                    scale: scale,
                    onTap: () => _pickDate2(isStart: true),
                  ),
                ),

                SizedBox(height: 8.0 * scale),

                GestureDetector(
                  onTap: () => _pickDate2(isStart: false),
                  child: _timeTile(
                    label: "End Date",
                    value: customEndDate == null
                        ? "--/--/----"
                        : DateFormat.yMMMd().format(customEndDate!),

                    scale: scale,
                    onTap: () => _pickDate2(isStart: false),
                  ),
                ),
              ],
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

                    final bool isCustomDateRange =
                        customStartDate != null && customEndDate != null;

                    Navigator.pop(context, <String, dynamic>{
                      'name': name,
                      'option': isCustomDateRange ? 'Date' : selectedopt,
                      'from': isCustomDateRange
                          ? customStartDate!.toIso8601String()
                          : (fromController.text.isNotEmpty
                                ? fromController.text
                                : null),
                      'to': isCustomDateRange
                          ? customEndDate!.toIso8601String()
                          : (toController.text.isNotEmpty
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
