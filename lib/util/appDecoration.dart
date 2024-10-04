import 'package:flutter/material.dart';

class AppDecoration {
  // 静态实例
  static final AppDecoration _instance = AppDecoration._();

  // 提供静态方法来获取实例
  static AppDecoration get instance => _instance;

  // 定义一个可修改的 BoxDecoration
  BoxDecoration decoration = const BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // 私有构造函数
  AppDecoration._();

  // 提供方法来更新装饰配置
  void updateDecoration(LinearGradient gradient) {
    decoration = BoxDecoration(
      gradient: gradient,
    );
  }
}
