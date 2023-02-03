import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lv2/common/const/colors.dart';
import 'package:lv2/common/const/data.dart';
import 'package:lv2/common/layout/default_layout.dart';
import 'package:lv2/common/view/root_tab.dart';
import 'package:lv2/user/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 스토리지에 있는 거 가져오려면 await해야하는데 initState()에서는 못함
    //deleteToken();
    checkToken();
  }

  void checkToken() async {
    // 스토리지에서 키값을 통해 값을 받아오기
    // test@codefactory.ai
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    //상태코드가 200 이외면 에러니까 예외처리
    try {
      // 리프레시 토큰 발급
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(headers: {
          'authorization': 'Bearer $refreshToken',
        }),
      );
      // 정상적으로 발급 받았으면 루트탭 이동
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RootTab(),
          ),
              (route) => false);

      // 에러가 나면 토큰이 문제든 머가 문제가 생긴거임 -> 로그인으로 이동
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
              (route) => false);
    }

/*    // 둘 중 하나가 널인 경우 로그인 화면으로 감
    if (refreshToken == null || accessToken == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RootTab(),
          ),
          (route) => false);
    }*/
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      // sizedBox로 가로길이를 최대로 가지도록 정렬
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16.0,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
