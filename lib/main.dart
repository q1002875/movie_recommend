import 'common_imports.dart';

Future<void> main() async {
  //執行異步操作需要
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: const MyApp(),
    ),
  );

  configLoading(); // 配置 EasyLoading
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskType = EasyLoadingMaskType.clear
    ..userInteractions = false
    ..dismissOnTap = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const MainPage(),

        //  FutureBuilder(
        //   future: _checkLoginStatus(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       return snapshot.data == false
        //           ? const MainPage()
        //           : const LoginView();
        //     }
        //     return const Center(child: CircularProgressIndicator()); // 加载状态
        //   },
        // ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
        builder: EasyLoading.init());
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
