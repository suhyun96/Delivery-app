import 'package:flutter/material.dart';
// 디폴트 레이아웃으로 감싸서 여기에 로직 추가하면 모든 스크린에 영향을 받도록
class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  // 바텀 네비게이션 안 쓰는 곳도 있으니
  final Widget? bottomNavigataionBar;
  const DefaultLayout({required this.child, this.backgroundColor,this.title, this.bottomNavigataionBar, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      // backgroundColor가 널이면 흰색
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
      // 네비게이션 바 생성
      bottomNavigationBar: bottomNavigataionBar,
    );
  }

  AppBar? renderAppBar(){
    // 화면에 앱바 안 나오도록
    if(title == null){
      return null;
    }else{
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        // 앱바가 나오는 정도 요즘은 없는게 대세
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
