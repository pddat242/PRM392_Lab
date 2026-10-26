import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late final MovieService movieService;
  late Future<List<Movie>> moviesFuture;

  final searchController = TextEditingController();
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    movieService = MovieService();
    moviesFuture = movieService.fetchMovies();
  }

  void searchMovies() {
    final query = searchController.text.trim();

    setState(() {
      currentQuery = query;

      if (query.isEmpty) {
        moviesFuture = movieService.fetchMovies();
      } else {
        moviesFuture = movieService.searchMovies(query);
      }
    });
  }

  void clearSearch() {
    searchController.clear();

    setState(() {
      currentQuery = '';
      moviesFuture = movieService.fetchMovies();
    });
  }

  void retry() {
    setState(() {
      moviesFuture = currentQuery.isEmpty
          ? movieService.fetchMovies()
          : movieService.searchMovies(currentQuery);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    movieService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Explorer')),
      body: Column(
        children: [
          // Ô tìm kiếm
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search movies...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => searchMovies(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: searchMovies,
                  child: const Text('Search'),
                ),
                IconButton(
                  onPressed: clearSearch,
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),

          // Danh sách phim
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: moviesFuture,
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Failed to load movies'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: retry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final movies = snapshot.data!;
                  if (movies.isEmpty) {
                    return const Center(child: Text('No movies found'));
                  }
                  final topMovies = List<Movie>.from(movies);
                  topMovies.sort((a, b) => b.rating.compareTo(a.rating));
                  final top5 = topMovies.take(5).toList();
                  return ListView.builder(
                    itemCount: top5.length + movies.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Top 5 Recommended Shows',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }


                      if (index == top5.length + 1) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'All Shows',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      // Xác định phim cần hiển thị
                      final Movie movie;

                      if (index <= top5.length) {
                        movie = top5[index - 1];
                      } else {
                        movie = movies[index - top5.length - 2];
                      }

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movie),
                              ),
                            );
                          },

                          leading: movie.posterUrl.isNotEmpty
                              ? Image.network(
                                  movie.posterUrl,
                                  width: 60,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.movie);
                                  },
                                )
                              : const Icon(Icons.movie),

                          title: Text(movie.title),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rating: ${movie.rating}'),
                              Text('Released: ${movie.premiered}'),
                            ],
                          ),

                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
