import 'package:movie_recommend/model/movie_Genre.dart';

class MovieDetail {
  final String title;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final String overview;
  final List<Genre> genres;

  MovieDetail({
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.genres,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['title'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'].toDouble(),
      releaseDate: json['release_date'],
      overview: json['overview'],
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
    );
  }
}
