import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lv2/restaurant/component/restaurant_card.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  //futurebuilder쓰기 위해 함수 생성 일단 data값만 가져오도록
  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await dio.get('http://$ip/restaurant',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    // 실제 바디
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              // 데이터 없는 경우
              if (!snapshot.hasData) {
                return Container();
              }
              return ListView.separated(
                  /*인덱스 아이템별로 렌더링 */
                  itemBuilder: (_, index) {
                    // 0-20번 아이템 선택되서 보임
                    final item = snapshot.data![index];
                     return RestaurantCard(
                      image: Image.network('http://$ip${item['thumbUrl']}',fit: BoxFit.cover,),
                      name: item['name'],
                      // item['tags']가 List<String> 아니라 List<dynamic>형태라서 값 넣는 것도 다름
                       // List<String>으로 바꾸기 위해 from사용 어떤거로부터 List<String>을 만들겠다
                      tags: List<String>.from(item['tags']),
                      ratingsCount: item['ratingsCount'],
                      deliveryTime: item['deliveryTime'],
                      deliveryFee: item['deliveryFee'],
                      ratings: item['ratings'],
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(
                      height: 8.0,
                    );
                  },
                  itemCount: snapshot.data!.length);
              print('${snapshot.data}');
              print('${snapshot.error}');
              return RestaurantCard(
                image: Image.asset(
                  'asset/img/food/ddeok_bok_gi.jpg',
                  // 이렇게 해야 화면에 꽉참
                  fit: BoxFit.cover,
                ),
                name: '불타는 떡볶이',
                tags: ['떡복이', '치즈', '매운맛'],
                ratingsCount: 100,
                deliveryTime: 15,
                deliveryFee: 2000,
                ratings: 4.52,
              );
            }),
      ),
    ));
  }
}
