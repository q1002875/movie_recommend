import 'package:flutter/material.dart';
import 'package:movie_recommend/model/movie.dart';
import 'package:movie_recommend/server/movie_service.dart';

enum MovieCategory {
  popular, // 热门电影
  upcoming, // 即将上映电影
}

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<Movie> get movies => _movies;

  Future<void> fetchMovies(MovieCategory category) async {
    _isLoading = true;
    notifyListeners();

    MovieService movieService = MovieService();

    if (category == MovieCategory.popular) {
      _movies = (await movieService.fetchPopularMovies()).movies;
    } else {
      _movies = (await movieService.fetchUpcomingMovies()).movies;
    }

    _isLoading = false;
    notifyListeners();
  }
}
