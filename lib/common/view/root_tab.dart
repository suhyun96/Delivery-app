import 'package:flutter/material.dart';
import 'package:lv2/common/const/colors.dart';
import 'package:lv2/common/layout/default_layout.dart';
import 'package:lv2/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

// 탭바 컨트롤러의 this 사용하려면 필요 무조건 필요한가보네 with SingleTickerProviderStateMixin
class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{
  int index = 0 ;
  // 탭바뷰 제어용
  // late 나중에 값을 초기화할 텐데 호출할 때 이미 초기화 준비가 끝났을 때 언젠가 세팅을 하는데 사용할 땐 이미 초기화 끝났을 경우
  // 그래서 initState에 넣음
  late TabController controller;

  @override
  void initState() {
    super.initState();
    // 탭바뷰에 포함된 아이템 갯수
    // vsync 는 this .. 랜더링 엔진에서 필요 컨트롤러를 선언한 현재 스테이트 혹은 스테이트풀 위젯
    // 다만 this기능이 필요
    controller=TabController(length: 4, vsync: this);

    //컨트롤러로 화면을 이동시키니까 네비게이션바의 index가 안 움직임
    controller.addListener(tabListener);
  }
  // 탭바의 움직임을 리스너로 추적하고 그 때마다 setState로 컨트롤러의 인덱스를 네비게이션 인덱스로 넣어줌
  void tabListener(){
    setState(() {
      index=controller.index;
    });
  }

  @override
  void dispose() {
    // super보다 위에 선언했네
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '딜리버리',
      //
      child: TabBarView(
        // 탭바뷰에서 가로로 스크롤 못하도록!
        physics: NeverScrollableScrollPhysics(),
        //컨트롤러 없으면 에러 뜸
        controller: controller,
        children: [
          RestaurantScreen(),
          Center(child: Container(child: Text('food'),)),
          Center(child: Container(child: Text('order'),)),
          Center(child: Container(child: Text('profile'),)),
        ],
      ),
      bottomNavigataionBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // 클릭했을 때 타입
        type: BottomNavigationBarType.fixed,
        // 클릭한 탭의 인덱스가 들어감
        onTap: (int index){
          /*setState(() {
            // this.index 는 위에 변수인 index
            this.index=index;
          });*/
          // setState로 가는게 아니라 컨트롤러 쪽 뷰로 이동시키는 거네
          controller.animateTo(index);

        },
        //현재 인덱스
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined),
              label: 'food'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'receipt'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'profile'
          ),
        ],
      ),
    );
  }
}
