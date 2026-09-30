import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh phim
            Image.network(
              movie.posterUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên phim
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Thể loại phim
                  Wrap(
                    spacing: 8,
                    children: movie.genres.map((genre) {
                      return Chip(
                        label: Text(genre),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Nội dung phim
                  Text(
                    movie.overview,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Các nút chức năng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        Icons.favorite,
                        'Favorite',
                      ),
                      _buildActionButton(
                        Icons.star,
                        'Rate',
                      ),
                      _buildActionButton(
                        Icons.share,
                        'Share',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Trailers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Danh sách trailer
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.play_circle_fill,
                        ),
                        title: Text(
                          movie.trailers[index],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon),
        ),
        Text(label),
      ],
    );
  }
}