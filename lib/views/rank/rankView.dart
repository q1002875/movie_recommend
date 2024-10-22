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
            // Tab(text: '評分', icon: Icon(Icons.star_rounded)),
            Tab(text: '票房', icon: Icon(Icons.attach_money_rounded)),
          ],
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return _buildShimmerList();
          } else if (movieProvider.movies.isEmpty) {
            return const Center(child: Text('無法加載排行榜'));
          } else {
            return _buildMovieList(movieProvider.movies);
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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged();
      }
    });
    _loadInitialData();
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

  Widget _buildMovieList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final rating = movies[index].voteAverage;
        final revenue = _movieRevenues[movie.id];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
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
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Arbitrary number of shimmer items
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ShimmerBox(
            width: double.infinity,
            height: 174, // Adjust this to match your movie item height
          ),
        );
      },
    );
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchSortedMovies(_currentSortOption);
    });
  }

  void _onTabChanged() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _currentSortOption = 'popularity.desc';
          break;
        case 1:
          _currentSortOption = 'revenue.desc';
          break;
      }
      context.read<MovieProvider>().fetchSortedMovies(_currentSortOption);
    });
  }
}
