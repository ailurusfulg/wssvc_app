// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_GetWarehouse.dart';
import '../../model/models.dart';

class TZA0200 extends StatefulWidget {
  const TZA0200({Key? key}) : super(key: key);

  @override
  _TZA0200 createState() => _TZA0200();
}

class _TZA0200 extends State<TZA0200> with SingleTickerProviderStateMixin {
  // # 레이아웃 관련 변수
  final String _fontFamily = 'NotoSansKR';

  // # API 관련 변수
  List<WarehouseResponseModel> getWarehouse = [];

  // # API 호출(야드 리스트)
  Future<void> get_Warehouse(String sCorpCD) async {
    APIGetWarehouse apiGetWarehouse = APIGetWarehouse();
    List<String> sParam = [sCorpCD];
     apiGetWarehouse.getSelect("USP_GET_WAREHOUSE", sParam).then((value) {
      setState(() {
        if (value.warehouse.isNotEmpty) {
          getWarehouse = value.warehouse;
          Get.log('야드');
        } else {
          getWarehouse = [];
        }
      });
    });
  }

  // # 캐시 관련 변수
  String sWorkCenter = '';
  String shareWorkCenter = '';
  String sCorp_CD = '';

  // # 캐시 호출(DB)
  Future<void> _loadDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD = prefs.getString('CorpCD')!;
    if (sCorp_CD.isEmpty) {
      Get.toNamed('/signin');
    }
    get_Warehouse(sCorp_CD);
  }

  // # 캐시 호출
  Future<void> _loadCounter(shareWorkCenter, defaultBlock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD = prefs.getString('CorpCD')!;
     prefs.setString('WC', shareWorkCenter);
     prefs.setString('dBLOCK', defaultBlock);
    sWorkCenter = prefs.getString('WC')!;
    Get.toNamed('/load');
  }

  @override
  void initState() {
    super.initState();
    _loadDB();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // # 종료버튼
  Future<bool> _onBackPressed() async {
    return await showDialog(
      context: context,
      builder: (context) =>
          Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                height: 250,
                width: 500,
                margin: const EdgeInsets.only(
                  left: 35,
                  right: 35,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 130,
                      margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        image: DecorationImage(
                          image: AssetImage('resources/image/title.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(),
                      child: const AutoSizeText(
                        '앱을 종료하시겠습니까?',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                              ),
                            ),
                            height: 50,
                            child: TextButton(
                              child: const Text(
                                "취소",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'NotoSansKR',
                                ),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(121, 102, 254, 1.0),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            height: 50,
                            child: TextButton(
                              child: const Text(
                                "확인",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'NotoSansKR',
                                ),
                              ),
                              onPressed: () => SystemNavigator.pop(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // # 레이아웃 사이즈 관련 변수
    final _height = Get.height;
    final _width = Get.width;
    final _screenHeight = _height * 0.95;
    final _screenWidth = _width * 0.95;

    // # 스캐폴드
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Center(
                child: SizedBox(
                  height: _height,
                  width: _width,
                  child: Row(
                    children: [
                      SizedBox(
                        height: _height,
                        width: _width / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(top: _height * 0.1),
                                child: AutoSizeText(
                                  '야 드   선 택',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 45,
                                      color: Colors.black,
                                      fontFamily: _fontFamily,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: _height * 0.03),
                            FittedBox(
                              fit: BoxFit.fill,
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 200),
                                height: _height * 0.8,
                                width: _width / 4,
                                child: Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: getWarehouse.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _loadCounter(getWarehouse
                                                .elementAt(index)
                                                .sWH_CD, getWarehouse
                                                .elementAt(index)
                                                .sBLOCK_CD,);
                                          });
                                        },
                                        child: Container(
                                          height: getWarehouse.length == 1
                                              ? _height * 0.2
                                              : _height *
                                              0.7 /
                                              getWarehouse.length,
                                          width: _width * 0.1,
                                          margin: EdgeInsets.only(
                                              bottom: _height *
                                                  0.1 /
                                                  getWarehouse.length),
                                          decoration: BoxDecoration(
                                              color: colorList[index],
                                              borderRadius:
                                              BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[700]!,
                                                  offset: const Offset(4, 4),
                                                  blurRadius: 12,
                                                )
                                              ]),
                                          child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.layers_sharp,
                                                    color: Colors.white,
                                                    size: 50,
                                                  ),
                                                  Flexible(
                                                    child: AutoSizeText(
                                                      getWarehouse
                                                          .elementAt(index)
                                                          .sWH_NM,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          letterSpacing: getWarehouse
                                                              .elementAt(index)
                                                              .sWH_NM
                                                              .length <
                                                              6
                                                              ? 40
                                                              : 20,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontFamily: _fontFamily,
                                                          fontSize: 50,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _height,
                        width: _width / 2,
                        child: FittedBox(
                          child: Image.asset('resources/image/bg_login.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Color> colorList = [
  const Color.fromRGBO(12, 130, 240, 1),
  const Color.fromRGBO(246, 154, 9, 1),
  const Color.fromRGBO(12, 184, 154, 1),
  const Color.fromRGBO(182, 54, 29, 1),
];
