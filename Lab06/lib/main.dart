import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// ==================== MOVIE MODEL ====================

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// ==================== SAMPLE DATA ====================

const List<Movie> allMovies = [
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl: 'https://picsum.photos/200/300?1',
    rating: 8.7,
  ),
  Movie(
    title: 'Avengers',
    year: 2012,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/200/300?2',
    rating: 8.0,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/200/300?3',
    rating: 7.7,
  ),
  Movie(
    title: 'Titanic',
    year: 1997,
    genres: ['Drama', 'Romance'],
    posterUrl: 'https://picsum.photos/200/300?4',
    rating: 7.9,
  ),
];

// ==================== APP ====================

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browser',
      home: const GenreScreen(),
    );
  }
}

// ==================== GENRE SCREEN ====================

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Nội dung người dùng nhập vào ô tìm kiếm
  String searchQuery = '';

  // Danh sách thể loại
  final List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Romance',
  ];

  // Các thể loại đang được chọn
  final Set<String> selectedGenres = {};

  // Kiểu sắp xếp hiện tại
  String selectedSort = 'A-Z';

  // Các lựa chọn sắp xếp
  final List<String> sortOptions = [
    'A-Z',
    'Z-A',
    'Year',
    'Rating',
  ];

  @override
  Widget build(BuildContext context) {
    // ==================== FILTER ====================

    List<Movie> visibleMovies = allMovies.where((movie) {
      // Tìm kiếm theo tên phim
      // Không phân biệt chữ hoa và chữ thường
      final matchesSearch = movie.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      // Nếu chưa chọn genre -> hiển thị tất cả
      // Nếu đã chọn -> phim phải có ít nhất một genre được chọn
      final matchesGenre =
          selectedGenres.isEmpty ||
          movie.genres.any(
            (genre) => selectedGenres.contains(genre),
          );

      return matchesSearch && matchesGenre;
    }).toList();

    // ==================== SORT ====================

    switch (selectedSort) {
      case 'A-Z':
        visibleMovies.sort(
          (a, b) => a.title.compareTo(b.title),
        );
        break;

      case 'Z-A':
        visibleMovies.sort(
          (a, b) => b.title.compareTo(a.title),
        );
        break;

      case 'Year':
        visibleMovies.sort(
          (a, b) => b.year.compareTo(a.year),
        );
        break;

      case 'Rating':
        visibleMovies.sort(
          (a, b) => b.rating.compareTo(a.rating),
        );
        break;
    }

    // ==================== UI ====================

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== TITLE ====================

              Text(
                'Find a Movie',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 20),

              // ==================== SEARCH ====================

              TextField(
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: const Icon(Icons.search),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ==================== GENRES ====================

              const Text(
                'Genres',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Wrap giúp các chip tự động xuống dòng
              // khi màn hình không đủ chiều rộng
              Wrap(
                spacing: 8,
                runSpacing: 8,

                children: genres.map((genre) {
                  final isSelected =
                      selectedGenres.contains(genre);

                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,

                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // ==================== SORT ====================

              Row(
                children: [
                  const Text(
                    'Sort by:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 12),

                  DropdownButton<String>(
                    value: selectedSort,

                    items: sortOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSort = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==================== MOVIE LIST ====================

              // Expanded chiếm phần không gian còn lại
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // ==========================================
                    // PHONE: width < 800
                    // Hiển thị danh sách 1 cột
                    // ==========================================

                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        itemCount: visibleMovies.length,

                        itemBuilder: (context, index) {
                          final movie = visibleMovies[index];

                          return Card(
                            margin:
                                const EdgeInsets.only(bottom: 12),

                            child: ListTile(
                              leading: Image.network(
                                movie.posterUrl,
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                              ),

                              title: Text(movie.title),

                              subtitle: Text(
                                '${movie.year} • '
                                '${movie.genres.join(', ')}',
                              ),

                              trailing: Text(
                                '⭐ ${movie.rating}',
                              ),
                            ),
                          );
                        },
                      );
                    }

                    // ==========================================
                    // TABLET / WEB: width >= 800
                    // Hiển thị Grid 2 cột
                    // ==========================================

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3,
                      ),

                      itemCount: visibleMovies.length,

                      itemBuilder: (context, index) {
                        final movie = visibleMovies[index];

                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              movie.posterUrl,
                              width: 70,
                              height: 90,
                              fit: BoxFit.cover,
                            ),

                            title: Text(movie.title),

                            subtitle: Text(
                              '${movie.year} • '
                              '${movie.genres.join(', ')}',
                            ),

                            trailing: Text(
                              '⭐ ${movie.rating}',
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
      ),
    );
  }
}