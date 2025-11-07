import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This class is used as a sentinel value to indicate "Cancel" was pressed.
class _CancelToken {
  const _CancelToken();
}

/// Shows a custom date picker dialog.
///
/// Returns a [DateTime] if a date is saved.
/// Returns `null` if "No date" is saved.
/// Returns a [_CancelToken] if the dialog is cancelled.
Future<dynamic> showCustomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  required Function onSave,
  // required Function onCancel,
  DateTime? startDate,
  required bool isStart,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      // 1. Calculate max width based on screen size
      final screenWidth = MediaQuery.of(dialogContext).size.width;
      // Set the max width to 360 (standard size) or 80% of the screen width, whichever is smaller.
      final double maxWidth = screenWidth > 360 ? 360 : screenWidth * 0.8;

      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        // Apply constraints here to ensure the AlertDialog itself respects the max width.
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Builder(
            builder: (innerContext) {
              return _DatePickerDialogContent(
                initialDate: initialDate,
                startDate: startDate,
                isStart: isStart,
                onCancel: () {
                  // onCancel;
                  Navigator.of(dialogContext).pop(const _CancelToken());
                },
                onSave: (DateTime? newDate) {
                  onSave(newDate);
                  Navigator.of(dialogContext).pop(newDate);
                },
              );
            },
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );
    },
  );
}

/// The stateful widget that contains the dialog's content.
class _DatePickerDialogContent extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? startDate;
  final VoidCallback onCancel;
  final ValueChanged<DateTime?> onSave;
  final bool isStart;

  const _DatePickerDialogContent({
    required this.initialDate,
    required this.startDate,
    required this.onCancel,
    required this.onSave,
    required this.isStart,
  });

  @override
  State<_DatePickerDialogContent> createState() =>
      _DatePickerDialogContentState();
}

class _DatePickerDialogContentState extends State<_DatePickerDialogContent> {
  DateTime? _selectedDate;
  DateTime? _startDate;
  bool _isTodaySelected = false;
  bool _isStart = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _startDate = widget.startDate;
    _isStart = widget.isStart;
    if (_selectedDate != null) {
      _isTodaySelected = _isSameDay(_selectedDate!, DateTime.now());
    }
  }

  // --- Helper Functions ---

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getBottomBarText() {
    if (_selectedDate == null) {
      return "No date";
    }
    return DateFormat.yMMMd().format(_selectedDate!);
  }

  // --- Top Toggle Button Builder ---

  Widget _buildTopToggle(bool isStart) {
    final bool noDateSelected = _selectedDate == null;
    final bool todaySelected = _isTodaySelected;
    DateTime dayAfterTomorrow = DateTime.now().add(Duration(days: 2));
    DateTime nextDay = DateTime.now().add(Duration(days: 1));
    DateTime afterWeek = DateTime.now().add(Duration(days: 7));

    if (isStart) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    text: "Today",
                    isSelected: _selectedDate != null && todaySelected,
                    onPressed: () {
                      final now = DateTime.now();
                      setState(() {
                        _selectedDate = now;
                        _isTodaySelected = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildToggleButton(
                    text: DateFormat('EEEE').format(nextDay),
                    isSelected:
                        _selectedDate != null &&
                        _isSameDay(_selectedDate!, nextDay),
                    onPressed: () {
                      setState(() {
                        _selectedDate = nextDay;
                        _isTodaySelected =
                            false; // "Today" is no longer selected
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    text: DateFormat('EEEE').format(dayAfterTomorrow),
                    isSelected:
                        _selectedDate != null &&
                        _isSameDay(_selectedDate!, dayAfterTomorrow),
                    onPressed: () {
                      setState(() {
                        _selectedDate = dayAfterTomorrow;
                        _isTodaySelected =
                            false; // "Today" is no longer selected
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildToggleButton(
                    text: "After 1 week",
                    isSelected:
                        _selectedDate != null &&
                        _isSameDay(_selectedDate!, afterWeek),
                    onPressed: () {
                      setState(() {
                        _selectedDate = afterWeek;
                        _isTodaySelected = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                text: "No date",
                isSelected: noDateSelected,
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                    _isTodaySelected = false; // "Today" is no longer selected
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleButton(
                text: "Today",
                isSelected: todaySelected,
                onPressed: () {
                  final now = DateTime.now();
                  setState(() {
                    _selectedDate = now;
                    _isTodaySelected = true;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return isSelected
        ? FilledButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(text),
          )
        : FilledButton.tonal(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(text),
          );
  }

  // --- Core Calendar Picker (Built-in Widget) ---
  Widget _buildCalendarPicker(BuildContext context) {
    // Determine the date to show when the picker first opens.
    final dateToHighlight = _selectedDate == null
        ? DateTime.now()
        : _selectedDate == null && !_isStart
        ? DateTime.now().add(Duration(days: 1))
        : _selectedDate!;

    // Custom Theme wrapper to ensure the CalendarDatePicker uses the desired colors
    return Theme(
      data: Theme.of(context).copyWith(
        // Set colors for the picker itself
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Theme.of(
            context,
          ).primaryColor, // Header background, selection bubble
          onPrimary: Colors.white, // Text on primary background
          surface: Colors.white, // Picker background
          onSurface: Colors.black87, // Text color for dates
        ),
        // Set text button style (used for month/year navigation buttons)
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: CalendarDatePicker(
        initialDate: _isStart
            ? dateToHighlight
            : _startDate!.add(Duration(days: 1)), // Use the selected date here for highlighting
        // Define the acceptable date range
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        // This is the core callback for date changes
        onDateChanged: (DateTime newDate) {
          setState(() {
            _selectedDate = newDate;
            _isTodaySelected = _isSameDay(newDate, DateTime.now());
          });
        },
        selectableDayPredicate: (date) {
          print('init: $dateToHighlight');
          print(' _startDate: $_startDate');
          if (_startDate != null) {
            return date.isAfter(_startDate!);
          } else {
            return true;
          }
        },
      ),
    );
  }

  // --- Bottom Action Bar Builder ---

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Selected Date
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getBottomBarText(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Ensures text fits cleanly
                  ),
                ),
              ],
            ),
          ),
          // Right Side: Action Buttons
          Row(
            // We use mainAxisSize.min here so the Row only takes up the space needed for the buttons
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  widget.onCancel();
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => widget.onSave(_selectedDate),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height and width from the context
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate dynamic height for the CalendarDatePicker
    // - On small screens (e.g., mobile portrait), use 50% of screen height, but
    //   limit it to a maximum of 350.
    // - On large screens, the maximum of 350 will apply.
    final double calendarHeight = (screenHeight * 0.50).clamp(300.0, 350.0);

    // Calculate dynamic width for the CalendarDatePicker
    // Use the available width minus padding (32.0 total padding)
    // We use the full dialog width minus padding because the ConstrainedBox
    // in the AlertDialog wrapper has already determined the max width.
    final double calendarWidth = screenWidth > 360
        ? 360 - 32
        : screenWidth * 0.8 - 32;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Toggle: "No date" / "Today"
          _buildTopToggle(_isStart),

          // 2. The Standard CalendarDatePicker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              // Apply dynamic height and width here
              height: calendarHeight,
              width: calendarWidth,
              child: _buildCalendarPicker(context),
            ),
          ),

          // 3. Bottom Action Bar
          _buildBottomBar(),
        ],
      ),
    );
  }
}
