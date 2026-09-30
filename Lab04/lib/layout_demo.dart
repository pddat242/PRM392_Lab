import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách phim
    final List<String> movies = [
      'Avatar',
      'Inception',
      'Interstellar',
      'Joker',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('EX3'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tiêu đề
            const Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Khoảng cách giữa tiêu đề và danh sách
            const SizedBox(height: 16),

            // ListView phải đặt trong Expanded
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          movies[index][0],
                        ),
                      ),
                      title: Text(
                        movies[index],
                      ),
                      subtitle: const Text(
                        'Sample description',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}