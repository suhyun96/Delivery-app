import 'package:flutter/material.dart';
// 디폴트 레이아웃으로 감싸서 여기에 로직 추가하면 모든 스크린에 영향을 받도록
class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  const DefaultLayout({required this.child, this.backgroundColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor가 널이면 흰색
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
    );
  }
}
