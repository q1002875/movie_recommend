class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final double popularity;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
    required this.popularity,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      popularity: json['popularity'].toDouble(),
      voteAverage: json['vote_average'].toDouble(),
    );
  }
}

class MovieResponse {
  final List<Movie> movies;
  final int totalResults;
  final int totalPages;

  MovieResponse({
    required this.movies,
    required this.totalResults,
    required this.totalPages,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    var movieList = json['results'] as List;
    List<Movie> movies = movieList.map((i) => Movie.fromJson(i)).toList();
    return MovieResponse(
      movies: movies,
      totalResults: json['total_results'],
      totalPages: json['total_pages'],
    );
  }
}
