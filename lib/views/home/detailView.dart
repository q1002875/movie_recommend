import 'package:movie_recommend/common_imports.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId; // 传入电影ID

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetail> movieDetailFuture;
  late Future<List<Trailer>> trailersFuture; // 添加预告片的未来对象
  late Future<List<Review>> reviewsFuture; // 添加评论的未来对象
  final MovieService movieService = MovieService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('電影詳情'),
      ),
      body: FutureBuilder<MovieDetail>(
        future: movieDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('无法加载电影详情'));
          } else if (snapshot.hasData) {
            final movieDetail = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 电影详情
                  _buildMovieInfo(movieDetail),

                  // 预告片部分
                  const SizedBox(height: 16),
                  const Text(
                    '預告片',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildTrailers(),

                  // 评论部分
                  const SizedBox(height: 16),
                  const Text(
                    '評論',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildReviews(),
                ],
              ),
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
    movieDetailFuture = movieService.fetchMovieDetail(widget.movieId);
    trailersFuture = movieService.fetchMovieTrailers(widget.movieId); // 获取预告片
    reviewsFuture = movieService.fetchMovieReviews(widget.movieId); // 获取评论
  }

  Widget _buildMovieInfo(MovieDetail movieDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        movieDetail.posterPath != null
            ? Image.network(
                'https://image.tmdb.org/t/p/w500${movieDetail.posterPath}',
                fit: BoxFit.cover,
              )
            : Container(
                height: 300,
                color: Colors.grey,
              ),
        const SizedBox(height: 16),
        Text(
          movieDetail.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '評分: ${movieDetail.voteAverage}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Text(
          '上映日期: ${movieDetail.releaseDate}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: movieDetail.genres
              .map((genre) => Chip(label: Text(genre.name)))
              .toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          '簡介',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          movieDetail.overview,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return FutureBuilder<List<Review>>(
      future: reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('无法加载评论'));
        } else if (snapshot.hasData) {
          final reviews = snapshot.data!;
          return Column(
            children: reviews.map((review) {
              return ListTile(
                title: Text(review.author),
                subtitle: Text(review.content),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('没有评论'));
        }
      },
    );
  }

  Widget _buildTrailers() {
    return FutureBuilder<List<Trailer>>(
      future: trailersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('无法加载预告片'));
        } else if (snapshot.hasData) {
          final trailers = snapshot.data!;
          return Column(
            children: trailers.map((trailer) {
              return ListTile(
                title: Text(trailer.name),
                trailing: const Icon(Icons.play_arrow),
                onTap: () {
                  final url = Uri.parse(
                      'https://www.youtube.com/watch?v=${trailer.key}');
                  launchUrl(url);
                },
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('没有预告片'));
        }
      },
    );
  }
}
