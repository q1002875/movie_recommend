import 'package:movie_recommend/common_imports.dart';

class MovieGridScreen extends StatefulWidget {
  const MovieGridScreen({super.key});

  @override
  _MovieGridScreenState createState() => _MovieGridScreenState();
}

class _MovieGridScreenState extends State<MovieGridScreen> {
  double _opacity = 1.0;
  double _height = 400; // 增加輪播圖高度
  MovieCategory currentCategory = MovieCategory.popular;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    Future<void> fetchMovies(MovieCategory category) async {
      try {
        await movieProvider.fetchMovies(category);
      } catch (e) {
        print('Error fetching movies: $e');
      }
    }

    Widget buildCategoryButton(String title, MovieCategory category) {
      bool isSelected = currentCategory == category;
      return GestureDetector(
        onTap: () {
          setState(() {
            currentCategory = category;
            fetchMovies(category);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          await movieProvider.fetchMovies(MovieCategory.popular);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels <= 0) {
              setState(() {
                _opacity = 1.0;
                _height = 400;
              });
            } else if (scrollInfo.metrics.pixels > 0 &&
                scrollInfo.metrics.pixels <= 400) {
              setState(() {
                _opacity = 1 - (scrollInfo.metrics.pixels / 400);
                _height = 400 - scrollInfo.metrics.pixels;
              });
            }
            return true;
          },
          child: CustomScrollView(
            slivers: [
              // 自定義 App Bar
              const SliverAppBar(
                expandedHeight: 0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Text(
                      //   '電影速推',
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.black87,
                      //   ),
                      // ),
                      // 輪播圖
                      // AnimatedOpacity(
                      //   opacity: _opacity,
                      //   duration: const Duration(milliseconds: 300),
                      //   child: movieProvider.isLoading
                      //       ? const Center(child: ShimmerBox())
                      //       : movieProvider.movies.isNotEmpty
                      //           ? PageView.builder(
                      //               controller: _pageController,
                      //               onPageChanged: (index) {
                      //                 setState(() {
                      //                   _currentPage = index;
                      //                 });
                      //               },
                      //               itemCount: movieProvider.movies.length > 5
                      //                   ? 5
                      //                   : movieProvider.movies.length,
                      //               itemBuilder: (context, index) {
                      //                 final movie = movieProvider.movies[index];
                      //                 return Stack(
                      //                   fit: StackFit.expand,
                      //                   children: [
                      //                     Image.network(
                      //                       'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      //                       fit: BoxFit.cover,
                      //                     ),
                      //                     // 漸層遮罩
                      //                     Container(
                      //                       decoration: BoxDecoration(
                      //                         gradient: LinearGradient(
                      //                           begin: Alignment.topCenter,
                      //                           end: Alignment.bottomCenter,
                      //                           colors: [
                      //                             Colors.transparent,
                      //                             Colors.black.withOpacity(0.7),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     // 電影標題
                      //                     Positioned(
                      //                       bottom: 40,
                      //                       left: 20,
                      //                       right: 20,
                      //                       child: Text(
                      //                         movie.title,
                      //                         style: const TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize: 24,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 );
                      //               },
                      //             )
                      //           : Container(color: Colors.grey),
                      // ),
                      // // 頁面指示器
                      // Positioned(
                      //   bottom: 20,
                      //   left: 0,
                      //   right: 0,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: List.generate(
                      //       movieProvider.movies.length > 5
                      //           ? 5
                      //           : movieProvider.movies.length,
                      //       (index) => Container(
                      //         margin: const EdgeInsets.symmetric(horizontal: 4),
                      //         width: 8,
                      //         height: 8,
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: _currentPage == index
                      //               ? Colors.white
                      //               : Colors.white.withOpacity(0.5),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              // 分類按鈕
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 100.0,
                  maxHeight: 100.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCategoryButton('熱門電影', MovieCategory.popular),
                        buildCategoryButton('近期上映', MovieCategory.upcoming),
                      ],
                    ),
                  ),
                ),
              ),

              // 電影網格
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (movieProvider.isLoading) {
                        return const ShimmerBox();
                      }
                      final movie = movieProvider.movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movieId: movie.id),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Hero(
                                    tag: 'movie_${movie.id}',
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: movieProvider.movies.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 4) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
