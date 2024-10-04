import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_recommend/common_imports.dart';

class MovieService {
  final String apiKey = '8b100090614b36a15f6eb799d5c2f648'; // 替换成你的API Key
  final String baseUrl = 'https://api.themoviedb.org/3';

  // 类型 ID 对应的中文名称
  final Map<int, String> genreIdToChinese = {
    28: '動作',
    12: '冒險',
    16: '動畫',
    35: '喜劇',
    80: '犯罪',
    99: '紀錄片',
    18: '劇情',
    10751: '家庭',
    14: '奇幻',
    36: '歷史',
    27: '恐怖',
    10402: '音樂',
    9648: '懸疑',
    10749: '愛情',
    878: '科幻',
    10770: '電視電影',
    53: '驚悚',
    10752: '戰爭',
    37: '西部',
  };

  // 获取所有电影类型

  Future<List<dynamic>> fetchGenres() async {
    final response =
        await http.get(Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['genres']; // 确保这是一个列表
    } else {
      throw Exception('Failed to load genres');
    }
  }

  // 获取电影详细信息
  Future<MovieDetail> fetchMovieDetail(int movieId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=zh-TW'));

    if (response.statusCode == 200) {
      return MovieDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('无法加载电影详情');
    }
  }

  // 获取电影评论
  Future<List<Review>> fetchMovieReviews(int movieId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/$movieId/reviews?api_key=$apiKey&language=zh-TW&page=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Review> reviews = (data['results'] as List)
          .map((json) => Review.fromJson(json))
          .toList();
      return reviews;
    } else {
      throw Exception('无法加载电影评论');
    }
  }

  // 根据类型搜索电影
  Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] as List<dynamic>;
    } else {
      throw Exception('无法加载该类型的电影');
    }
  }

  Future<List<Trailer>> fetchMovieTrailers(int movieId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=zh-TW'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final trailers = (data['results'] as List)
          .map((trailer) => Trailer.fromJson(trailer))
          .toList();
      return trailers;
    } else {
      throw Exception('无法加载电影预告片');
    }
  }

  // 获取热门电影
  Future<MovieResponse> fetchPopularMovies() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/popular?api_key=$apiKey&language=zh-TW&page=1'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('无法加载热门电影');
    }
  }

  // 获取即将上映的电影
  Future<MovieResponse> fetchUpcomingMovies() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/upcoming?api_key=$apiKey&language=zh-TW&page=1'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('无法加载即将上映的电影');
    }
  }

  String getMovieTitleInChinese(Map<String, dynamic> movie) {
    // 假设API返回的电影中有一个字段'stitlename'存储中文名称
    return movie['original_title'] ?? movie['title'] ?? '无标题';
  }

  // 搜索电影
  Future<List<dynamic>> searchMovies(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    // 判断查询是否为中文
    final isChinese = RegExp(r'[\u4e00-\u9fa5]').hasMatch(query);
    final language = isChinese ? 'zh-TW' : 'en-US'; // 根据输入选择语言

    final url =
        '$baseUrl/search/movie?api_key=$apiKey&query=$encodedQuery&language=$language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('无法搜索电影');
    }
  }
}
