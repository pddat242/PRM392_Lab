import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,

        itemBuilder: (context, index) {
          final movie = movies[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),

            child: ListTile(
              contentPadding: const EdgeInsets.all(12),

              leading: Image.network(
                movie.posterUrl,
                width: 70,
                height: 90,
                fit: BoxFit.cover,
              ),

              title: Text(
                movie.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text('⭐ ${movie.rating} · ${movie.genres.join(", ")}'),

              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MovieDetailScreen(movie: movie);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
