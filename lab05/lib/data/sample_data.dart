import '../models/movie.dart';

const List<Movie> movies = [
  Movie(
    id: 1,
    title: 'Dune: Part Two',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg',
    overview:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: [
      'Official Trailer #1',
      'IMAX Sneak Peek',
    ],
  ),

  Movie(
    id: 2,
    title: 'Deadpool & Wolverine',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg',
    overview:
        'The multiverse gets messy when Wade Wilson teams up with Wolverine.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: [
      'Red Band Trailer',
      'Behind the Scenes',
    ],
  ),
];