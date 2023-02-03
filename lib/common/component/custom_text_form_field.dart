
import 'package:flutter/material.dart';
import 'package:lv2/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final String? initText;

  // 여기서 기본값 지정을 해 줄수가 있네
  const CustomTextFormField({
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    this.initText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 텍스트 필드 테두리 속성
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      initialValue: initText,
      // 커서 색상
      cursorColor: PRIMARY_COLOR,
      // 비밀 번호 입력할때 사용 true면 가려짐
      obscureText: obscureText,
      // 자동으로 커서 넣어지는 효과
      autofocus: autofocus,

      // 텍스트 값 바뀔 때마다 호출되는 메서드
      onChanged: onChanged,
      // 패딩을 넣어서 여백을 줌 -> 커서가 더 잘 보임
      // hint랑 error추가
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),

        // 텍스트 필드 배경색 채우기 , filled 필수
        fillColor: INPUT_BG_COLOR,
        filled: true,
        // 모든 input 상태의 기본 스타일 세팅
        border: baseBorder,

        // 포커스 된 테두리 상태
        // copyWith : 해당 속성 그대로 유지하면서 편집 가능
        focusedBorder: baseBorder.copyWith(
          // borderSide의 값중 하나만 변경하려고 기본 거 끌고 온 다음 편집함
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
        // 기본값이 테두리 검정색인데 선택되지 않은 상태에서의 테두리 값
        enabledBorder: baseBorder
      ),
    );
  }
}
