import 'package:movie_recommend/common_imports.dart';

class RankView extends StatefulWidget {
  const RankView({super.key});

  @override
  _RankViewState createState() => _RankViewState();
}

class _RankViewState extends State<RankView> {
  late Future<List<Movie>> movieRankings;
  final MovieService movieService = MovieService();
  final Map<int, double> _movieRatings = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('電影排行榜'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: movieRankings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('无法加载排行榜'));
          } else if (snapshot.hasData) {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final rating = _movieRatings[movie.id];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Stack(
                    children: [
                      // 排名標籤

                      // 主卡片
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movieId: movie.id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 海報
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: movie.posterPath != null
                                      ? Image.network(
                                          'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : const SizedBox(
                                          width: 100,
                                          height: 150,
                                          child: Icon(Icons.movie, size: 50),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                // 電影信息
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              rating != null
                                                  ? '${rating.toStringAsFixed(1)} / 10'
                                                  : '加载中...',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('没有数据'));
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    movieRankings = movieService.fetchPopularMovies().then((response) {
      return _fetchAllMovieRatings(response);
    });
  }

  Future<List<Movie>> _fetchAllMovieRatings(MovieResponse response) async {
    final List<Future<void>> ratingFutures = [];

    for (var movie in response.movies) {
      ratingFutures.add(_fetchMovieRating(movie.id));
    }

    await Future.wait(ratingFutures);

    response.movies.sort((a, b) {
      final ratingA = _movieRatings[a.id] ?? 0;
      final ratingB = _movieRatings[b.id] ?? 0;
      return ratingB.compareTo(ratingA);
    });

    return response.movies;
  }

  Future<void> _fetchMovieRating(int movieId) async {
    if (_movieRatings.containsKey(movieId)) return;

    try {
      final movieDetail = await movieService.fetchMovieDetail(movieId);
      setState(() {
        _movieRatings[movieId] = movieDetail.voteAverage;
      });
    } catch (e) {
      print('Failed to load movie detail: $e');
    }
  }
}
