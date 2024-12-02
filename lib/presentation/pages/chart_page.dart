import 'package:enpal_challenge/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  // Create a DateFormat instance
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the selected date
    String formattedDate = _selectedDate != null
        ? _dateFormatter.format(_selectedDate!)
        : 'No date selected';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Text('Select Date'),
          ),
          const SizedBox(height: 20),
          Text(
            'Selected Date: $formattedDate',
            style: const TextStyle(fontSize: 18),
          ),
          Visibility(
            visible: _selectedDate != null,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Wrapper();
                  }));
                },
                child: const Text('Show Data')),
          )
        ],
      ),
    );
  }
}
