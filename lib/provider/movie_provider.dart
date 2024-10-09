import 'package:flutter/material.dart';
import 'package:movie_recommend/model/movie.dart';
import 'package:movie_recommend/server/movie_service.dart';

enum MovieCategory {
  popular, // 热门电影
  upcoming, // 即将上映电影
}

// 更好的性能：

// 減少不必要的網絡請求
// 快速顯示緩存數據

// 更好的用戶體驗：

// 數據加載更快
// 離線時可以查看緩存內容
// 減少加載時的閃爍

// 更穩定的應用：

// 完善的錯誤處理
// 網絡問題時的優雅降級

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = true;
  MovieCategory? _currentCategory;
  DateTime? _lastFetchTime;
  final Map<MovieCategory, List<Movie>> _cachedMovies = {};
  final Map<MovieCategory, DateTime> _cacheTimestamps = {};

  bool get isLoading => _isLoading;
  List<Movie> get movies => _movies;

  // 清除緩存
  void clearCache() {
    _cachedMovies.clear();
    _cacheTimestamps.clear();
    notifyListeners();
  }

  Future<void> fetchMovies(MovieCategory category,
      {bool forceRefresh = false}) async {
    // 如果類別相同且不是強制刷新，檢查是否需要更新
    if (category == _currentCategory &&
        !forceRefresh &&
        !_shouldRefetch(category)) {
      return;
    }

    // 如果有緩存且不是強制刷新，先加載緩存
    if (!forceRefresh && _cachedMovies.containsKey(category)) {
      _loadFromCache(category);
    }

    try {
      _isLoading = true;
      // 如果不是強制刷新且有緩存，延遲通知以避免閃爍
      if (!forceRefresh && _cachedMovies.containsKey(category)) {
        await Future.delayed(Duration.zero);
      } else {
        notifyListeners();
      }

      MovieService movieService = MovieService();
      List<Movie> newMovies;

      if (category == MovieCategory.popular) {
        final response = await movieService.fetchPopularMovies();
        newMovies = response.movies;
      } else {
        final response = await movieService.fetchUpcomingMovies();
        newMovies = response.movies;
      }

      _movies = newMovies;
      _currentCategory = category;
      _updateCache(category, newMovies);
    } catch (e) {
      print('Error fetching movies: $e');
      // 如果有緩存，使用緩存數據
      if (_cachedMovies.containsKey(category)) {
        _loadFromCache(category);
      }
      // 可以在這裡添加錯誤處理，例如顯示錯誤提示
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 從緩存加載數據
  void _loadFromCache(MovieCategory category) {
    if (_cachedMovies.containsKey(category)) {
      _movies = List.from(_cachedMovies[category]!);
      _currentCategory = category;
      _isLoading = false;
      notifyListeners();
    }
  }

  // 檢查是否需要刷新數據
  bool _shouldRefetch(MovieCategory category) {
    final lastFetch = _cacheTimestamps[category];
    if (lastFetch == null) return true;

    // 設置緩存時間為5分鐘
    const cacheExpiration = Duration(minutes: 5);
    return DateTime.now().difference(lastFetch) > cacheExpiration;
  }

  // 更新緩存
  void _updateCache(MovieCategory category, List<Movie> movies) {
    _cachedMovies[category] = List.from(movies);
    _cacheTimestamps[category] = DateTime.now();
  }
}
