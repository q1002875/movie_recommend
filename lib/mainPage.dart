import 'common_imports.dart';

// 主題配置示例
ThemeData buildTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF2196F3), // 使用藍色作為主題色
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    fontFamily: 'Roboto', // 使用 Roboto 字體
  );
}

// 自定義滑動物理效果
class CustomTabBarScrollPhysics extends ScrollPhysics {
  const CustomTabBarScrollPhysics({super.parent});

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 0.8,
      );

  @override
  CustomTabBarScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomTabBarScrollPhysics(parent: buildParent(ancestor));
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBody: true, // 允許內容延伸到底部導航欄的下方
        body: Stack(
          children: [
            // TabBarView with custom page transitions
            const TabBarView(
              physics: CustomTabBarScrollPhysics(), // 自定義滑動效果
              children: [
                HomeView(),
                SearchView(),
                RankView(),
              ],
            ),
            // Gradient overlay at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TabBar(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            dividerColor: Colors.transparent,
            splashBorderRadius: BorderRadius.circular(20),
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              _buildTab(Icons.local_fire_department_rounded, 'Hot'),
              _buildTab(Icons.search_rounded, 'Search'),
              _buildTab(Icons.bar_chart_rounded, 'Rank'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      height: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
