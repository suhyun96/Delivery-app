import 'package:flutter/material.dart';
import 'package:lv2/common/component/custom_text_form_field.dart';
import 'package:lv2/common/view/splash_screen.dart';
import 'package:lv2/user/view/login_screen.dart';

void main() {
  // amterial app 바로 안 쓰고 _APP으로 감쌈
  // 나중에 라우팅 할때 context필요할 수도 있어서 그럼
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 디폴트 폰트 변경
      theme: ThemeData(
        fontFamily: 'NotoSans'
      ),

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
