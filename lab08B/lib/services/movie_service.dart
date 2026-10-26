import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  final http.Client client;

  MovieService({http.Client? client})
      : client = client ?? http.Client();

  Future<List<Movie>> fetchMovies() async {
    final url = Uri.parse(
      'https://api.tvmaze.com/shows?page=0',
    );

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data
          .map((item) => Movie.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
  final url = Uri.https(
    'api.tvmaze.com',
    '/search/shows',
    {'q': query},
  );

  final response = await client.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    return data
        .map((item) => Movie.fromJson(item['show']))
        .toList();
  } else {
    throw Exception('Failed to search movies');
  }
  }

  void dispose() {
    client.close();
  }
}