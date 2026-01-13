import 'package:flutter/material.dart';

class Progresspage extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? meta;
  const Progresspage({super.key, required this.title, this.meta});

  @override
  State<Progresspage> createState() => _ProgresspageState();
}

class _ProgresspageState extends State<Progresspage> {
  // return only current weekday and day (e.g. "Wednesday, 24")
  String _weekdayAndDay(DateTime now) {
    const List<String> weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final String weekday = weekdayNames[now.weekday - 1];
    return '$weekday, ${now.day}';
  }

  // store notes for this track: each item has 'date' (DateTime) and 'text' (String)
  final List<Map<String, dynamic>> _notes = [];

  // store done dates (normalized to year,month,day)
  final Set<DateTime> _doneDates = {};

  // helper to normalize to date-only (no time)
  DateTime _norm(DateTime d) => DateTime(d.year, d.month, d.day);

  // helper to format a date for dialogs/snackbars
  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  late final DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    _createdAt = DateTime.now();
  }

  List<DateTime> _generateRange(DateTime start, DateTime end) {
    final List<DateTime> days = [];
    DateTime cur = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    while (!cur.isAfter(last)) {
      days.add(cur);
      cur = cur.add(const Duration(days: 1));
    }
    return days;
  }

  int? _tryParseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  List<DateTime>? _buildRangeFromMeta() {
    final meta = widget.meta;
    final now = DateTime.now();

    if (meta == null) return null;

    final option = (meta['option'] as String?)?.toLowerCase() ?? '';

    // Date option: expect ISO strings for 'from' and 'to'
    if (option == 'date') {
      final fStr = meta['from'] as String?;
      final tStr = meta['to'] as String?;
      final from = fStr != null ? DateTime.tryParse(fStr) : null;
      final to = tStr != null ? DateTime.tryParse(tStr) : null;
      if (from != null && to != null && !to.isBefore(from)) {
        return _generateRange(from, to);
      }
      return null;
    }

    // Week(s) option: 'from' contains number of weeks (or 'to')
    if (option.contains('week')) {
      final n = _tryParseInt(meta['from']) ?? _tryParseInt(meta['to']);
      if (n != null && n > 0) {
        final end = now.add(Duration(days: 7 * n - 1));
        return _generateRange(now, end);
      }
      return null;
    }

    // Month(s) option: 'from' contains number of months
    if (option.contains('month')) {
      final n = _tryParseInt(meta['from']) ?? _tryParseInt(meta['to']);
      if (n != null && n > 0) {
        final end = DateTime(now.year, now.month + n, now.day);
        return _generateRange(now, end);
      }
      return null;
    }

    // Year(s) option: 'from' contains number of years
    if (option.contains('year')) {
      final n = _tryParseInt(meta['from']) ?? _tryParseInt(meta['to']);
      if (n != null && n > 0) {
        final end = DateTime(now.year + n, now.month, now.day);
        return _generateRange(now, end);
      }
      return null;
    }

    return null;
  }

  // calendar state
  late PageController _pageController;
  int _initialPage = 0;
  int _currentPage = 0;
  List<DateTime>? _months; // first-day-of-month entries
  DateTime? _selectedDate;

  void _prepareMonths(List<DateTime> range) {
    if (range.isEmpty) {
      _months = null;
      return;
    }
    final first = DateTime(range.first.year, range.first.month, 1);
    final last = DateTime(range.last.year, range.last.month, 1);
    final months = <DateTime>[];
    DateTime cur = first;
    while (!cur.isAfter(last)) {
      months.add(cur);
      cur = DateTime(cur.year, cur.month + 1, 1);
    }
    _months = months;
    // set initial page to the month that contains today, or first
    final today = DateTime.now();
    final idx = months.indexWhere(
      (m) => m.year == today.year && m.month == today.month,
    );
    _initialPage = idx >= 0 ? idx : 0;
    _currentPage = _initialPage;
    _pageController = PageController(initialPage: _initialPage);
    // default selected date is today if in range, otherwise first day in range
    _selectedDate = range.firstWhere((d) {
      final today = DateTime.now();
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    }, orElse: () => range.first);
  }

  @override
  void dispose() {
    try {
      _pageController.dispose();
    } catch (_) {}
    super.dispose();
  }

  bool _isSelectableDate(DateTime date, List<DateTime>? range) {
    final today = DateTime.now();

    final normDate = DateTime(date.year, date.month, date.day);
    final normToday = DateTime(today.year, today.month, today.day);
    final normCreated = DateTime(
      _createdAt.year,
      _createdAt.month,
      _createdAt.day,
    );

    // ❌ never allow future dates
    if (normDate.isAfter(normToday)) return false;

    // ❌ outside duration range
    if (range != null &&
        (normDate.isBefore(range.first) || normDate.isAfter(range.last))) {
      return false;
    }

    // ✅ allow backdating ONLY on creation day
    if (normCreated.isAtSameMomentAs(normToday)) {
      return true; // any past date in range is allowed
    }

    // ✅ otherwise only today
    return normDate.isAtSameMomentAs(normToday);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.8, 1.4);
    final double containerHeightSmall = (90.0 * scale).clamp(80.0, 220.0);
    final double containerHeightLarge = (420.0 * scale).clamp(220.0, 900.0);

    final DateTime now = DateTime.now();
    final String weekdayDay = _weekdayAndDay(now);

    final range = _buildRangeFromMeta();

    if (range != null && (_months == null || _months!.isEmpty)) {
      _prepareMonths(range);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title.isNotEmpty ? widget.title : 'Progress',
          style: TextStyle(fontSize: 20.0 * scale),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0 * scale),
        child: ListView(
          children: [
            Container(
              height: containerHeightSmall,
              width: double.infinity,
              color: Colors.grey[700],
              child: Padding(
                padding: EdgeInsets.all(8.0 * scale),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(weekdayDay, style: TextStyle(fontSize: 16.0 * scale)),
                    ElevatedButton(
                      onPressed: () async {
                        // choose date to mark: selected date if any, otherwise today
                        final dateToMark = _selectedDate ?? now;

                        // ensure only current date can be marked
                        if (!_isSelectableDate(dateToMark, range)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Only the current date can be marked as done.',
                              ),
                            ),
                          );
                          return;
                        }

                        // if we have a defined range, ensure dateToMark is inside it
                        if (range != null &&
                            (dateToMark.isBefore(range.first) ||
                                dateToMark.isAfter(range.last))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Selected date ${_formatDate(dateToMark)} is outside the track duration.',
                              ),
                            ),
                          );
                          return;
                        }

                        // show dialog with textarea for notes; returns the note text or null
                        final TextEditingController noteCtrl =
                            TextEditingController();
                        final String? entered = await showDialog<String?>(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Mark as done'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Mark progress as done for ${_formatDate(dateToMark)}?',
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: noteCtrl,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      hintText: 'Add a note (optional)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(null),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(
                                    ctx,
                                  ).pop(noteCtrl.text.trim()),
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );

                        if (entered != null) {
                          // user pressed Save (entered may be empty string) — record note with date
                          final normDate = _norm(dateToMark);
                          setState(() {
                            _notes.insert(0, {
                              'date': normDate,
                              'text': entered,
                            });
                            // mark date as done (change color)
                            _doneDates.add(normDate);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Marked done for ${_formatDate(dateToMark)}${entered.isNotEmpty ? ' — note saved' : ''}',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text(
                        "Mark as done",
                        style: TextStyle(
                          fontSize: 14.0 * scale,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0 * scale),
            // Calendar section - real month calendar with horizontal month pages
            Container(
              // fixed height to allow internal scrolling for month content if needed
              height: containerHeightLarge,
              width: double.infinity,
              color: Colors.grey[700],
              padding: EdgeInsets.all(12.0 * scale),
              child: range == null || range.isEmpty
                  ? Center(
                      child: Text(
                        "No duration set for this track.",
                        style: TextStyle(
                          fontSize: 16.0 * scale,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header with month navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_months == null) return;
                                final prev = (_currentPage - 1).clamp(
                                  0,
                                  _months!.length - 1,
                                );
                                _pageController.animateToPage(
                                  prev,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                              icon: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 28.0 * scale,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _months != null && _months!.isNotEmpty
                                      ? '${_monthName(_months![_currentPage].month)} ${_months![_currentPage].year}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 18.0 * scale,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (_months == null) return;
                                final next = (_currentPage + 1).clamp(
                                  0,
                                  _months!.length - 1,
                                );
                                _pageController.animateToPage(
                                  next,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                              icon: Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 28.0 * scale,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0 * scale),
                        // weekday header
                        Row(
                          children:
                              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                  .map(
                                    (d) => Expanded(
                                      child: Center(
                                        child: Text(
                                          d,
                                          style: TextStyle(
                                            fontSize: 12.0 * scale,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        SizedBox(height: 8.0 * scale),
                        // month pages
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _months!.length,
                            onPageChanged: (p) =>
                                setState(() => _currentPage = p),
                            itemBuilder: (context, pageIndex) {
                              final monthFirst = _months![pageIndex];
                              final year = monthFirst.year;
                              final month = monthFirst.month;
                              final daysInMonth = DateTime(
                                year,
                                month + 1,
                                0,
                              ).day;
                              final firstWeekday = DateTime(
                                year,
                                month,
                                1,
                              ).weekday; // Mon=1..Sun=7
                              final offset = firstWeekday - 1; // Mon->0
                              final totalCells =
                                  ((offset + daysInMonth) / 7).ceil() * 7;

                              return GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: totalCells,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      mainAxisSpacing: 6.0 * scale,
                                      crossAxisSpacing: 6.0 * scale,
                                      childAspectRatio: 1.0,
                                    ),
                                itemBuilder: (context, cellIndex) {
                                  final dayNumber = cellIndex - offset + 1;
                                  if (dayNumber < 1 ||
                                      dayNumber > daysInMonth) {
                                    return const SizedBox.shrink();
                                  }
                                  final date = DateTime(year, month, dayNumber);
                                  final inRange =
                                      !(date.isBefore(range.first) ||
                                          date.isAfter(range.last));
                                  final isSelected =
                                      _selectedDate != null &&
                                      _selectedDate!.year == date.year &&
                                      _selectedDate!.month == date.month &&
                                      _selectedDate!.day == date.day;
                                  final isToday =
                                      date.year == now.year &&
                                      date.month == now.month &&
                                      date.day == now.day;
                                  final isDone = _doneDates.contains(
                                    _norm(date),
                                  );

                                  Color bg;
                                  Color fg;
                                  if (!inRange) {
                                    bg = Colors.transparent;
                                    fg = Colors.white24;
                                  } else if (isDone) {
                                    bg = Colors.blueAccent;
                                    fg = Colors.white;
                                  } else if (isSelected) {
                                    bg = Colors.white;
                                    fg = Colors.black;
                                  } else if (isToday) {
                                    bg = Colors.white70;
                                    fg = Colors.black;
                                  } else {
                                    bg = Colors.white24;
                                    fg = Colors.white;
                                  }

                                  return GestureDetector(
                                    onTap: inRange
                                        ? () {
                                            // allow selection only for current date
                                            if (!_isSelectableDate(
                                              date,
                                              range,
                                            )) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Only the current date can be selected.',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            setState(
                                              () => _selectedDate = date,
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Selected ${date.day}/${date.month}/${date.year}',
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: bg,
                                        borderRadius: BorderRadius.circular(
                                          6.0 * scale,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$dayNumber',
                                        style: TextStyle(
                                          fontSize: 14.0 * scale,
                                          fontWeight: FontWeight.w700,
                                          color: fg,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 20.0 * scale),
            // Notes Section — show saved notes with their dates
            Container(
              // reuse containerHeightLarge so notes area is visible
              height: containerHeightLarge,
              width: double.infinity,
              color: Colors.grey[700],
              padding: EdgeInsets.all(12.0 * scale),
              child: _notes.isEmpty
                  ? Center(
                      child: Text(
                        "No notes yet. Mark a day as done and add a note.",
                        style: TextStyle(fontSize: 16.0 * scale),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 18.0 * scale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0 * scale),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _notes.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 8.0 * scale),
                            itemBuilder: (context, i) {
                              final item = _notes[i];
                              final DateTime d = item['date'] as DateTime;
                              final String text = item['text'] as String;
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  _formatDate(d),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  text.isNotEmpty ? text : '(no note)',
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, size: 20.0 * scale),
                                  onPressed: () {
                                    final removedDate = _norm(
                                      item['date'] as DateTime,
                                    );
                                    setState(() {
                                      _notes.removeAt(i);
                                      // if no more notes for this date, remove done mark
                                      final stillExists = _notes.any(
                                        (n) =>
                                            _norm(n['date'] as DateTime) ==
                                            removedDate,
                                      );
                                      if (!stillExists) {
                                        _doneDates.remove(removedDate);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[m - 1];
  }
}
