import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _CancelToken {
  const _CancelToken();
}

/// Shows a custom date picker dialog.
///
/// Returns a [DateTime] if a date is saved.
/// Returns `null` if "No date" is saved.
Future<dynamic> showCustomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  required Function onSave,
  DateTime? startDate,
  required bool isStart,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      final screenWidth = MediaQuery.of(dialogContext).size.width;
      final double maxWidth = screenWidth > 360 ? 360 : screenWidth * 0.8;

      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Builder(
            builder: (innerContext) {
              return _DatePickerDialogContent(
                initialDate: initialDate,
                startDate: startDate,
                isStart: isStart,
                onCancel: () {
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
                        _isTodaySelected = false;
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
                        _isTodaySelected = false;
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
                    _isTodaySelected = false;
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

  Widget _buildCalendarPicker(BuildContext context) {
    final dateToHighlight = _selectedDate == null
        ? DateTime.now()
        : _selectedDate == null && !_isStart
        ? DateTime.now().add(Duration(days: 1))
        : _selectedDate!;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Theme.of(context).primaryColor,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: CalendarDatePicker(
        initialDate: _isStart
            ? dateToHighlight
            : _startDate!.add(Duration(days: 1)),

        firstDate: DateTime(1900),
        lastDate: DateTime(2100),

        onDateChanged: (DateTime newDate) {
          setState(() {
            _selectedDate = newDate;
            _isTodaySelected = _isSameDay(newDate, DateTime.now());
          });
        },
        selectableDayPredicate: (date) {
          if (_startDate != null) {
            return date.isAfter(_startDate!);
          } else {
            return true;
          }
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Row(
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double calendarHeight = (screenHeight * 0.50).clamp(300.0, 350.0);

    final double calendarWidth = screenWidth > 360
        ? 360 - 32
        : screenWidth * 0.8 - 32;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopToggle(_isStart),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: calendarHeight,
              width: calendarWidth,
              child: _buildCalendarPicker(context),
            ),
          ),

          _buildBottomBar(),
        ],
      ),
    );
  }
}
