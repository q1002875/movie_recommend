// class MovieDetailProvider with ChangeNotifier {
//   MovieDetail? movieDetail;
//   bool isLoading = false;

//   Future<void> fetchMovieDetail(int movieId) async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       // 假设已经配置好 API 调用方法
//       final response = await ApiService.getMovieDetail(movieId);
//       movieDetail = MovieDetail.fromJson(response.data);
//     } catch (e) {
//       // 处理错误
//     }

//     isLoading = false;
//     notifyListeners();
//   }
// }
