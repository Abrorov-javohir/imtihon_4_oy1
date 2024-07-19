import 'package:flutter/material.dart';
import 'package:imtihon_4_oy1/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderDialog extends StatefulWidget {
  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _setReminder() {
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      if (selectedDateTime.isAfter(now)) {
        final scheduledDate = tz.TZDateTime.from(selectedDateTime, tz.local);
        NotificationService().scheduleNotification(scheduledDate);
        NotificationService()
            .schedulePushNotification(selectedDateTime, "You have a reminder");
        print(
            'Reminder set for: ${DateFormat('dd MM yyyy').format(_selectedDate!)} at ${_selectedTime!.format(context)}');
      } else {
        print('Selected date and time must be in the future.');
      }
    } else {
      print('Please select both a date and a time for the reminder.');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Reminder",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Eslatma kuni: ${_selectedDate != null ? DateFormat('dd MM yyyy').format(_selectedDate!) : 'Tanlanmagan'}",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Eslatma vaqti: ${_selectedTime != null ? _selectedTime!.format(context) : 'Tanlanmagan'}",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _setReminder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Eslatish",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

void showReminderDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ReminderDialog();
    },
  );
}
