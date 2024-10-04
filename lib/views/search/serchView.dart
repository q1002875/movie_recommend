import 'package:movie_recommend/common_imports.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _movies = [];
  List<dynamic> _genres = [];
  bool _isLoading = false;
  bool _isSearching = false;
  final MovieService movieService = MovieService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          '發現電影',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // 搜索框部分
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  print("TextField is focused");
                }
              },
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '搜尋你喜歡的電影',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (value) {
                  _searchMovies(value);
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),

          // 主要内容区域
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _isSearching && _movies.isNotEmpty
                    ? _buildSearchResults()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              '探索類型',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _buildGenreGrid(),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Widget _buildGenreGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _genres.length,
      itemBuilder: (context, index) {
        final genre = _genres[index];
        final genreName =
            movieService.genreIdToChinese[genre['id']] ?? genre['name'];

        // 創建漸變色
        List<List<Color>> gradients = [
          [const Color(0xFF6448FE), const Color(0xFF5FC6FF)],
          [const Color(0xFFFE6197), const Color(0xFFFF8867)],
          [const Color(0xFF61A3FE), const Color(0xFF63FFD5)],
          [const Color(0xFFFFA738), const Color(0xFFFFE130)],
          [const Color(0xFFFF71FF), const Color(0xFF8C52FF)],
        ];

        final gradient = gradients[index % gradients.length];

        return GestureDetector(
          onTap: () => _searchMoviesByGenre(genre['id']),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 背景圖案
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.movie_outlined,
                    size: 100,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                // 文字
                Center(
                  child: Text(
                    genreName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        final movie = _movies[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movieId: movie['id']),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // 海報
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: movie['poster_path'] != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie),
                          ),
                  ),
                  const SizedBox(width: 16),
                  // 電影信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie['title'] ?? '無標題',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie['release_date'] ?? '無發布日期',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchGenres() async {
    try {
      final genres = await movieService.fetchGenres();
      setState(() {
        _genres = genres;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      _movies = await movieService.searchMovies(query);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchMoviesByGenre(int genreId) async {
    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      _movies = await movieService.fetchMoviesByGenre(genreId);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
