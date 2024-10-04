import 'package:movie_recommend/main.dart';

import 'common_imports.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MyApp());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/mainpage':
        return MaterialPageRoute(builder: (_) => const MainPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchView());
      case '/details':
        return MaterialPageRoute(builder: (_) => const RankView());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileView());
      default:
        return MaterialPageRoute(builder: (_) => const MyApp());
    }
  }
}
