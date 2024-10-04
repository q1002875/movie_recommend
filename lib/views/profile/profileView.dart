import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  GoogleSignInAccount? _user; // 存储登录的用户信息
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 头像和会员等级
              _buildProfileHeader(),
              const SizedBox(height: 20),
              // 会员信息
              _buildMembershipInfo(),
              const SizedBox(height: 20),
              // 观看历史
              _buildSectionTitle('观看历史'),
              _buildWatchHistory(),
              const SizedBox(height: 20),
              // 收藏的电影
              _buildSectionTitle('收藏的电影'),
              _buildFavoriteMovies(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // 获取用户信息
  }

  Widget _buildFavoriteMovies() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6, // 假设有6部收藏的电影
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w92/sample_movie_poster.jpg', // 示例海报
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text('电影名称', textAlign: TextAlign.center),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembershipInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '会员信息',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('有效期: 2024年12月31日'),
            Text('积分: 1200'),
            Text('专属优惠: 每月两张免费电影票'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _user != null
              ? NetworkImage(_user!.photoUrl ?? '')
              : const AssetImage('assets/default_avatar.png')
                  as ImageProvider, // 默认头像
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _user != null ? _user!.displayName ?? '用户名称' : '加载中...',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              '会员等级: 黄金会员',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildWatchHistory() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // 假设有5部电影
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            'https://image.tmdb.org/t/p/w92/sample_movie_poster.jpg', // 示例海报
            width: 50,
            fit: BoxFit.cover,
          ),
          title: const Text('电影名称'),
          subtitle: const Text('观看日期: 2024年9月26日'),
        );
      },
    );
  }

  // 获取用户信息
  Future<void> _getUserInfo() async {
    _user = await _googleSignIn.signIn(); // 登录用户
    setState(() {}); // 更新界面
  }
}
