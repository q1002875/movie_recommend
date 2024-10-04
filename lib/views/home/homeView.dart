import 'package:movie_recommend/common_imports.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hot Movie',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MovieGridScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    // 在初始化时调用 fetchMovies
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      await movieProvider.fetchMovies(MovieCategory.popular); // 只在第一次加载时请求数据
    });
  }
}
