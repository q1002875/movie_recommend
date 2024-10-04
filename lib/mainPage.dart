import 'common_imports.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3, // Tab的數量
      child: Scaffold(
        // appBar: AppBar(
        //     // title: const Text('Movie Recommender'),
        //     ),
        body: TabBarView(
          children: [
            HomeView(),
            SearchView(),
            RankView(),
            // ProfileView(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Hot"),
            Tab(icon: Icon(Icons.search), text: "Search"),
            Tab(icon: Icon(Icons.density_small_sharp), text: "Rank"),
            // Tab(icon: Icon(Icons.person), text: "Profile"),
          ],
          labelColor: Colors.blue, // 當前選中的 Tab 顏色
          unselectedLabelColor: Colors.grey, // 未選中的 Tab 顏色
          indicatorSize: TabBarIndicatorSize.label, // 底部指示器與文本對齊
        ),
      ),
    );
  }
}
