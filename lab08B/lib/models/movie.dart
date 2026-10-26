class Movie {
  final int id;
  final String title;
  final String summary;
  final String posterUrl;
  final double rating;
  final String premiered;

  Movie({
    required this.id,
    required this.title,
    required this.summary,
    required this.posterUrl,
    required this.rating,
    required this.premiered,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['name'] ?? 'Unknown',
      summary: json['summary'] ?? '',
      posterUrl: json['image']?['medium'] ?? '',
      rating: (json['rating']?['average'] as num?)?.toDouble() ?? 0.0,
      premiered: json['premiered'] ?? 'Unknown',
    );
  }
}