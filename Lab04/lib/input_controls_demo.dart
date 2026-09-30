import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});
  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double rating = 50;
  bool isActive = false;
  String? selectedGender;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EX2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Rating (Slider)'),
            Slider(
              value: rating,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            Text('Cullent value:${rating.round()}'),
            const SizedBox(height: 20),
            const Text('Active (Switch)'),
            SwitchListTile(
              title: const Text('Is more active?'),
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),
            const SizedBox(height: 20),


            Text('Gender (Radio Buttons)'),
            RadioGroup<String>(
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              child: Column(
                children: [
                  const RadioListTile<String>(
                    title: Text('Action'),
                    value: 'Action',
                  ),

                  const RadioListTile<String>(
                    title: Text('Comedy'),
                    value: 'Comedy',
                  ),
                ],
              ),
            ),

            Text('Selected gender: ${selectedGender ?? "None"}'),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                );

                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: const Text('Open Date Picker'),
            ),

            const SizedBox(height: 10),

            Text(
              selectedDate == null
                  ? 'No date selected'
                  : 'Selected date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            ),
          ],
        ),
      ),
    );
  }
}
