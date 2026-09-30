import 'package:flutter/material.dart';

class UiFixesDemo extends StatefulWidget {
  const UiFixesDemo({super.key});

  @override
  State<UiFixesDemo> createState() => _UiFixesDemoState();
}

class _UiFixesDemoState extends State<UiFixesDemo> {
  int count = 0;
  DateTime? selectedDate;

  final List<String> movies = [
    'Movie A',
    'Movie B',
    'Movie C',
    'Movie D',
  ];

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EX5'),
      ),

      body: Column(
        children: [
          // FIX 1:
          // ListView nằm trong Column phải được giới hạn kích thước
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.movie),
                  title: Text(movies[index]),
                );
              },
            ),
          ),

          // FIX 2:
          // Cho phép phần nội dung còn lại cuộn trên màn hình nhỏ
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'SingleChildScrollView prevents overflow',
                  ),

                  const SizedBox(height: 16),

                  // FIX 3: dùng setState để cập nhật UI
                  Text('Count: $count'),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        count++;
                      });
                    },
                    child: const Text('Increase'),
                  ),

                  const SizedBox(height: 16),

                  // FIX 4: DatePicker dùng context hợp lệ
                  ElevatedButton(
                    onPressed: pickDate,
                    child: const Text('Select Date'),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    selectedDate == null
                        ? 'No date selected'
                        : 'Selected: '
                            '${selectedDate!.day}/'
                            '${selectedDate!.month}/'
                            '${selectedDate!.year}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}