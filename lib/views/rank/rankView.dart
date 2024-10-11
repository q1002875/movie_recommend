import 'package:movie_recommend/common_imports.dart';

class RankView extends StatefulWidget {
  const RankView({super.key});

  @override
  _RankViewState createState() => _RankViewState();
}

class _RankViewState extends State<RankView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MovieService movieService = MovieService();
  final Map<int, double> _movieRatings = {};
  final Map<int, double> _movieRevenues = {};
  String _currentSortOption = 'popularity.desc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('電影排行榜'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '熱門程度', icon: Icon(Icons.local_fire_department_rounded)),
            Tab(text: '評分', icon: Icon(Icons.star_rounded)),
            Tab(text: '票房', icon: Icon(Icons.attach_money_rounded)),
          ],
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _loadSortedMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('無法加載排行榜: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final rating = _movieRatings[movie.id];
                final revenue = _movieRevenues[movie.id];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Stack(
                    children: [
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
                                      _buildInfoRow(
                                        icon: Icons.star_rounded,
                                        text: rating != null
                                            ? '${rating.toStringAsFixed(1)} / 10'
                                            : '加載中...',
                                        color: Colors.amber,
                                      ),
                                      if (revenue != null)
                                        _buildInfoRow(
                                          icon: Icons.attach_money_rounded,
                                          text:
                                              '\$${(revenue / 1000000).toStringAsFixed(1)}M',
                                          color: Colors.green,
                                        ),
                                      _buildInfoRow(
                                        icon: Icons.calendar_today_rounded,
                                        text: movie.releaseDate,
                                        color: Colors.blue,
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
                          width: 30,
                          height: 30,
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
            return const Center(child: Text('沒有數據'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged();
      }
    });
  }

  Widget _buildInfoRow(
      {required IconData icon, required String text, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchAllMovieDetails(List<Movie> movies) async {
    final List<Future<void>> detailFutures = [];

    for (var movie in movies) {
      detailFutures.add(_fetchMovieDetail(movie.id));
    }

    await Future.wait(detailFutures);
  }

  Future<void> _fetchMovieDetail(int movieId) async {
    if (_movieRatings.containsKey(movieId) &&
        _movieRevenues.containsKey(movieId)) return;

    try {
      final movieDetail = await movieService.fetchMovieDetail(movieId);
      final revenue = await movieService.fetchMovieRevenue(movieId);
      setState(() {
        _movieRatings[movieId] = movieDetail.voteAverage;
        _movieRevenues[movieId] = revenue;
      });
    } catch (e) {
      print('Failed to load movie detail: $e');
    }
  }

  Future<List<Movie>> _loadSortedMovies() async {
    final movies = await movieService.fetchSortedMovies(_currentSortOption);
    await _fetchAllMovieDetails(movies);
    return movies;
  }

  void _onTabChanged() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _currentSortOption = 'popularity.desc';
          break;
        case 1:
          _currentSortOption = 'vote_average.desc';
          break;
        case 2:
          _currentSortOption = 'revenue.desc';
          break;
      }
    });
  }
}
