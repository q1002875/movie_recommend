import 'common_imports.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSecure = true;
  bool signUp = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double horizontalPadding = width * 0.1;
    double verticalPadding = height * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 点击空白处关闭键盘
        },
        child: Container(
          width: width,
          height: height,
          decoration: AppDecoration.instance.decoration,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 应用标志
                Icon(
                  Icons.person,
                  size: width * 0.25,
                  color: Colors.white,
                ),
                SizedBox(height: verticalPadding),

                // 电子邮件输入框
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: verticalPadding),

                // 密码输入框
                Stack(
                  children: [
                    TextField(
                      controller: _passwordController,
                      obscureText: _isSecure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isSecure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSecure = !_isSecure;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: verticalPadding),

                // 登录按钮
                ElevatedButton(
                  onPressed: () {
                    // 处理登录逻辑
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: signUp == false
                      ? const Text('Login')
                      : const Text('Sign Up'),
                ),

                SizedBox(height: verticalPadding),
                signUp
                    ? SizedBox(height: verticalPadding)
                    : ElevatedButton.icon(
                        onPressed: _loginWithGoogle,
                        icon: const Icon(Icons.earbuds_battery_sharp,
                            color: Colors.black), // Google 图标
                        label: const Text('Google'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                      ),
                // Google 和 Facebook 登录按钮
                SizedBox(height: verticalPadding * 0.4),

                // 注册及忘记密码链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 处理注册逻辑
                        // EasyLoading.showError("status");
                        setState(() {
                          signUp = !signUp;
                        });
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // 处理忘记密码逻辑
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkSignup(bool signup) async {
    // signup ? print("傳送給firebase確認") : _setLoginStatus(true); // 假设登录成功
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const MainPage()),
    // );
  }

  void _loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signIn();
      _setLoginStatus(true);
      Navigator.pushReplacementNamed(context, '/mainpage');

      EasyLoading.showSuccess("登入成功");
    } catch (error) {
      print(error);
    }
  }

  Future<void> _setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }
}
