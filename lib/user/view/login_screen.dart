import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lv2/common/const/colors.dart';
import 'package:lv2/common/const/data.dart';
import 'package:lv2/common/layout/default_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:lv2/common/view/root_tab.dart';
import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    final emulatorIp = '10.0.2.2:3000';
    final simulatorIp = '127.0.0.1:3000';
    final ip;
    // 에뮬마다 로컬호스트 달라서 처리하기 위해 사용
    if (defaultTargetPlatform == TargetPlatform.android) {
      ip = emulatorIp;
    } else {
      ip = simulatorIp;
    }

    // 디폴트 레이아웃으로 감싸서 추후 유지보수 용이하도록 , 기능 추가도 한 번에
    return DefaultLayout(
        child: SafeArea(
      top: true,
      bottom: false,
      // 키보드 올라올 때 화면 크기가 정해져 있으니 키보드가 화면 침범 스크롤로 방지
      child: SingleChildScrollView(
        //드래그 했을 때 키보드 안 보임
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(),
              const SizedBox(
                height: 16,
              ),
              _SubTitle(),
              Image.asset(
                'asset/img/misc/logo.png',
                //height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 3 * 2,
              ),
              CustomTextFormField(
                hintText: '이메일을 입력해주세요',
                // 텍스트 필드에 입력될 때마다 호출되며 value는 입력된 값
                onChanged: (String value) {
                  username = value;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextFormField(
                hintText: '비밀번호를 입력해주세요',
                onChanged: (String value) {
                  password = value;
                },
                obscureText: true,
              ),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  // id, password
                  final rawString = '$username:$password';
                  print(rawString);
                  //base64 incode 일반 스트링을 암호화 시킬 수 있음 어떻게 인코딩 할지 정리한것
                  Codec<String, String> stringToBase64 = utf8.fuse(base64);
                  // 인코딩할 거 반환해서 토큰으로 사용ㅇ
                  String token = stringToBase64.encode(rawString);

                  //로컬호스트 에뮬 기본세팅 ip 에뮬기준

                  final resp = await dio.post(
                    'http://$ip/auth/login',
                    options: Options(headers: {
                      'authorization': 'Basic $token',
                    }),
                  );
                  // 응답받은 바디값  refreshtoken과 accesstoken이 있을 예정
                  print(resp.data);

                  // 바디 부분의 키값으로 벨류 추출
                  final refreshToken = resp.data['refreshToken'];
                  final accessToken = resp.data['accessToken'];

                  // 스토리지에 값을 저장
                  await storage.write(
                      key: REFRESH_TOKEN_KEY, value: refreshToken);
                  await storage.write(
                      key: ACCESS_TOKEN_KEY, value: accessToken);
                  print(await storage.read(key: REFRESH_TOKEN_KEY));
                  print(await storage.read(key: ACCESS_TOKEN_KEY));

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RootTab(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                child: Text('로그인'),
              ),
              TextButton(
                onPressed: () async {
                  final refreshToken =
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY3NTE2NTU4MCwiZXhwIjoxNjc1MjUxOTgwfQ.XkcNmLtYBsWFemWcvefKSaOx4aAqL-r2Um6S6E1tIPQ';
                  final resp = await dio.post(
                    'http://$ip/auth/token',
                    options: Options(headers: {
                      'authorization': 'Bearer $refreshToken',
                    }),
                  );

                  //액세스 토큰이 나옴
                  print(resp.data);
                },
                child: Text('회원가입'),
                style: TextButton.styleFrom(foregroundColor: Colors.black),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다.',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요 !\n오늘도 성공적인 주문이 되길 :).',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
