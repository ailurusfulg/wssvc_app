// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../common/common_widget.dart';
import '../../controller/controllers.dart';
import '../../model/models.dart';

class TYA1200 extends StatefulWidget {
  const TYA1200({Key? key}) : super(key: key);

  @override
  _TYA1200 createState() => _TYA1200();
}

class _TYA1200 extends State<TYA1200> with AutomaticKeepAliveClientMixin {
  late final _moveflagA = ValueNotifier(selectFlagA);
  late final _moveflagB = ValueNotifier(selectFlagB);

  // # 캐시 저장 관련 변수
  late String shareWC = '';
  late String shareBLOCK = '';
  late String shareBAY = '';
  late String sCorp_CD = '';
  late String sUser_ID = '';

  // # 그리드 MultiScrollController
  late ScrollController _sclControllerOneA,
      _sclControllerTwoA,
      _sclControllerOneB,
      _sclControllerTwoB;

  // # 새로고침 관련 함수
  Future<void> _refresh() async {
    // refreshKey.currentState?.show(atTop: true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (_selectedObjBlockA == null || _selectedObjBlockB == null) {
        Get.defaultDialog(
            title: '알림', content: const Text('등록된 블록 및 베이가 없습니다.'));
      } else {
        get_BlockBayContrMoveA(
            sCorp_CD, shareWC, _selectedObjBlockA, _selectedObjRowA.toString());
        get_BlockBayContrMoveB(
            sCorp_CD, shareWC, _selectedObjBlockB, _selectedObjRowB.toString());
      }
    });

    return;
  }

// # 레이아웃 관련 변수
  final String _fontFamily = 'NotoSansKR';

// # 그리드 관련 변수
  var dropBlockA = [];
  var dropBayA = [];
  var dropBlockB = [];
  var dropBayB = [];
  var reContrListA = [];
  var reContrListB = [];
  bool selectFlagA = false;
  bool selectFlagB = false;
  String selectGrid = 'C';
  int allBayCountA = 60;
  int rowBayCountA = 10;
  int allBayCountB = 60;
  int rowBayCountB = 10;
  List<int> countClick = [];
  String firstClick = '';
  String SecondClick = '';
  int selectedCart = -1;
  int bay = 1;
  var _selectedObjBlockA,_selectedObjBlockB;
  var _selectedObjRowA,_selectedObjRowB;
  var tableRow = const TableRow();
  Map<String, String> mapBlock = {};

// # API 관련 변수
  List<LoadResponseModel> getLoadOrder = [];
  List<LOCResponseModel> getLocationContrA = [];
  List<LOCResponseModel> getLocationContrB = [];
  List<BlockResponseModel> getBlock = [];
  List<BayResponseModel> getBayA = [];
  List<BayResponseModel> getBayB = [];
  List<AddContrMoveResponseModel> result = [];
  List<AddContrLoadResponseModel> result_L = [];
  late String moveCode = '';
  late String moveError = '';

  // # 검색착 관련 변수
  late String search_Contr_A = '';
  late String search_Contr_B = '';

// # 캐시 호출

  Future<void> _setShareBLOCKBAY(defaultBlock, defaultBay) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dBLOCK', defaultBlock);
    await prefs.setString('dBAY', defaultBay);
  }

  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD = prefs.getString('CorpCD') ?? '';
    sUser_ID = prefs.getString('UserID') ?? '';
    shareWC = prefs.getString('WC') ?? '';
    shareBLOCK = prefs.getString('dBLOCK') ?? '';
    shareBAY = prefs.getString('dBAY') ?? '';
    var value = Get.arguments;
    String argBlock = value.toString().split('/')[0];
    String argBay = value.toString().split('/')[1];

    get_BlockInfo(sCorp_CD, shareWC);

    get_BayInfo_A(sCorp_CD, shareWC, argBlock);
    get_BayInfo_B(sCorp_CD, shareWC, shareBLOCK);

    // _refresh();
    get_BlockBayContrMoveA(sCorp_CD, shareWC, argBlock, argBay);
    get_BlockBayContrMoveB(sCorp_CD, shareWC, shareBLOCK, shareBAY);
  }

  // # API 호출(컨테이너위치 리스트)
  void get_BlockBayContrMoveA(String sCorpCD, String sWorkCenter,
      String sStockCD, String sBayCD) async {
    APIGetLocationContrMove apiGetLocationContrMove = APIGetLocationContrMove();
    List<String> sParam = [sCorpCD, sWorkCenter, sStockCD, sBayCD];
    await apiGetLocationContrMove
        .getSelect("USP_GET_BLOCKBAYCONTRMOVE", sParam)
        .then((value) {
      setState(() {
        reContrListA.clear();
        if (value.approval.isNotEmpty) {
          getLocationContrA = value.approval;
          allBayCountA = getLocationContrA.length * 6;
          rowBayCountA = getLocationContrA.length;

          for (int i = 0; i < rowBayCountA; i++) {
            reContrListA.add(getLocationContrA.elementAt(i).sTier6);
            reContrListA.add(getLocationContrA.elementAt(i).sTier5);
            reContrListA.add(getLocationContrA.elementAt(i).sTier4);
            reContrListA.add(getLocationContrA.elementAt(i).sTier3);
            reContrListA.add(getLocationContrA.elementAt(i).sTier2);
            reContrListA.add(getLocationContrA.elementAt(i).sTier1);
          }
        } else {
          getLocationContrA = [];
        }
      });
    });
  }

  // # API 호출(컨테이너위치 리스트)
  void get_BlockBayContrMoveB(String sCorpCD, String sWorkCenter,
      String sStockCD, String sBayCD) async {
    APIGetLocationContrMove apiGetLocationContrMove = APIGetLocationContrMove();
    List<String> sParam = [sCorpCD, sWorkCenter, sStockCD, sBayCD];
    await apiGetLocationContrMove
        .getSelect("USP_GET_BLOCKBAYCONTRMOVE", sParam)
        .then((value) {
      setState(() {
        reContrListB.clear();
        if (value.approval.isNotEmpty) {
          getLocationContrB = value.approval;
          allBayCountB = getLocationContrB.length * 6;
          rowBayCountB = getLocationContrB.length;

          for (int i = 0; i < rowBayCountB; i++) {
            reContrListB.add(getLocationContrB.elementAt(i).sTier6);
            reContrListB.add(getLocationContrB.elementAt(i).sTier5);
            reContrListB.add(getLocationContrB.elementAt(i).sTier4);
            reContrListB.add(getLocationContrB.elementAt(i).sTier3);
            reContrListB.add(getLocationContrB.elementAt(i).sTier2);
            reContrListB.add(getLocationContrB.elementAt(i).sTier1);
          }
          _setShareBLOCKBAY(_selectedObjBlockB, _selectedObjRowB);
        } else {
          getLocationContrB = [];
        }
      });
    });
  }

// # API 호출(블록정보 리스트)
  Future<void> get_BlockInfo(String sCorpCD, String sWorkCenter) async {
    APIGetBlockInfo apiGetBlockInfo = APIGetBlockInfo();
    List<String> sParam = [sCorpCD, sWorkCenter];
    await apiGetBlockInfo.getSelect("USP_GET_BLOCK_INFO", sParam).then((value) {
      setState(() {
        if (value.block.isNotEmpty) {
          getBlock = value.block;

          var temp = Get.arguments;
          String valBlock = temp.toString().split('/')[0];
          String valBay = temp.toString().split('/')[1];
          int dfBlockIndex = 0;
          if (selectGrid == 'L') {
            dropBlockA.clear();

            for (int i = 0; i < getBlock.length; i++) {
              mapBlock[getBlock.elementAt(i).sBlock_CD] =
                  getBlock.elementAt(i).sBlock_NM;
              dropBlockA.add(getBlock.elementAt(i).sBlock_CD);
            }
            _selectedObjBlockA = dropBlockA[0];
          } else if (selectGrid == 'R') {
            dropBlockB.clear();

            for (int i = 0; i < getBlock.length; i++) {
              mapBlock[getBlock.elementAt(i).sBlock_CD] =
                  getBlock.elementAt(i).sBlock_NM;
              dropBlockB.add(getBlock.elementAt(i).sBlock_CD);
            }
            _selectedObjBlockB = dropBlockB[0];
          } else {
            dropBlockA.clear();
            dropBlockB.clear();

            for (int i = 0; i < getBlock.length; i++) {
              mapBlock[getBlock.elementAt(i).sBlock_CD] =
                  getBlock.elementAt(i).sBlock_NM;
              dropBlockA.add(getBlock.elementAt(i).sBlock_CD);
              dropBlockB.add(getBlock.elementAt(i).sBlock_CD);
            }
            _selectedObjBlockA = valBlock;
            _selectedObjBlockB = shareBLOCK;
          }
        } else {
          getBlock = [];
        }
      });
    });
  }

// # API 호출(베이정보 리스트)
  Future<void> get_BayInfo_A(
      String sCorpCD, String sWorkCenter, String sBlock_CD) async {
    APIGetBayInfo apiGetBayInfo = APIGetBayInfo();
    List<String> sParam = [sCorpCD, sWorkCenter, sBlock_CD];
    await apiGetBayInfo.getSelect("USP_GET_BAY_INFO", sParam).then((value) {
      setState(() {
        var temp = Get.arguments;
        String valBay = temp.toString().split('/')[1];

        if (value.bay.isNotEmpty) {
          getBayA = value.bay;
          if (selectGrid == 'L') {
            dropBayA.clear();
            for (int i = 0; i < getBayA.length; i++) {
              dropBayA.add(getBayA.elementAt(i).iROW_ID.toString());
            }
            _selectedObjRowA = dropBayA.contains(_selectedObjRowA)
                ? _selectedObjRowA
                : dropBayA.last;
          } else if (selectGrid == 'R') {
            return;
          } else {
            dropBayA.clear();
            for (int i = 0; i < getBayA.length; i++) {
              dropBayA.add(getBayA.elementAt(i).iROW_ID.toString());
            }
            _selectedObjRowA = valBay;
          }
        } else {
          getBayA = [];
        }
      });
    });
  }

  Future<void> get_BayInfo_B(
      String sCorpCD, String sWorkCenter, String sContrNo) async {
    APIGetBayInfo apiGetBayInfo = APIGetBayInfo();
    List<String> sParam = [sCorpCD, sWorkCenter, sContrNo];
    await apiGetBayInfo.getSelect("USP_GET_BAY_INFO", sParam).then((value) {
      setState(() {
        if (value.bay.isNotEmpty) {
          getBayB = value.bay;
          if (selectGrid == 'L') {
            return;
          } else if (selectGrid == 'R') {
            dropBayB.clear();
            for (int i = 0; i < getBayB.length; i++) {
              dropBayB.add(getBayB.elementAt(i).iROW_ID.toString());
            }
            _selectedObjRowB = dropBayB.contains(_selectedObjRowB)
                ? _selectedObjRowB
                : dropBayB.last;
          } else {
            dropBayB.clear();
            for (int i = 0; i < getBayB.length; i++) {
              dropBayB.add(getBayB.elementAt(i).iROW_ID.toString());
            }
            _selectedObjRowB =
                dropBayB.contains(shareBAY) ? shareBAY : dropBayB.last;
          }
        } else {
          getBayB = [];
        }
      });
    });
  }

  // # API 호출(컨테이너 상차등록)
  void add_Contr_Load(
    String sCorpCD,
    String sDRVID,
    String sVehicle,
    String sContrKey,
    String sContrNO,
    String sWorkCenter,
    String sBlockCD,
    int iBayID,
    int iRowID,
    int iTierID,
    String sOutCode,
    String sOutMsg,
  ) async {
    APIAddContrLoad apiAddContrLoad = APIAddContrLoad();
    List<String> sParam = [
      sCorpCD,
      sDRVID,
      sVehicle,
      sContrKey,
      sContrNO,
      sWorkCenter,
      sBlockCD,
      iBayID.toString(),
      iRowID.toString(),
      iTierID.toString(),
      sOutCode,
      sOutMsg,
    ];
    await apiAddContrLoad.getUpdate("USP_ADD_CONTR_LOAD", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          result_L = value.result;
          String Msg = result_L.elementAt(0).rsMsg;
          if (result_L.elementAt(0).rsCode != 'S') {
            Get.defaultDialog(title: Msg);
          }
        } else {}
      });
    });
  }

// # API 호출(컨테이너 이적등록)
  void add_Contr_Move(
      String sCorpCD,
      String sUserID,
      String sWorkCenter,
      String sContrKey,
      String sContrNO,
      String sBlockCD,
      String sBayID,
      String sRowID,
      String sTierID,
      String sOutCode,
      String sOutMsg) async {
    APIAddContrMove apiAddContrMove = APIAddContrMove();
    List<String> sParam = [
      sCorpCD,
      sUserID,
      sWorkCenter,
      sContrKey,
      sContrNO,
      sBlockCD,
      sBayID,
      sRowID,
      sTierID,
      sOutCode,
      sOutMsg,
    ];
    await apiAddContrMove.getUpdate("USP_ADD_CONTR_MOVE", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          result = value.result;
          moveCode = result.elementAt(0).rsCode;
          if (result.elementAt(0).rsCode == "E") {
            moveError = result.elementAt(0).rsMsg;
            showToast(moveError);
          }
          get_BlockBayContrMoveA(sCorpCD, shareWC, _selectedObjBlockA,
              _selectedObjRowA.toString());
          get_BlockBayContrMoveB(sCorpCD, shareWC, _selectedObjBlockB,
              _selectedObjRowB.toString());
        } else {}
      });
    });
  }

// # 위젯이 생성될때 처음으로 호출되는 메서드
  @override
  bool get wantKeepAlive => false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _sclControllerOneA = ScrollController();
    _sclControllerTwoA = ScrollController();
    _sclControllerOneB = ScrollController();
    _sclControllerTwoB = ScrollController();
    _sclControllerOneA.addListener(() {
      _sclControllerTwoA.animateTo(_sclControllerOneA.offset,
          duration: const Duration(microseconds: 700), curve: Curves.linear);
    });
    _sclControllerOneB.addListener(() {
      _sclControllerTwoB.animateTo(_sclControllerOneB.offset,
          duration: const Duration(microseconds: 700), curve: Curves.linear);
    });
    firstClick = '';
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (firstClick.isEmpty) {
        _refresh();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sclControllerOneA.dispose();
    _sclControllerTwoA.dispose();
    _sclControllerOneB.dispose();
    _sclControllerTwoB.dispose();
    _timer.cancel();
  }

// # 스캐폴드
  @override
  Widget build(BuildContext context) {
    SearchStateController_A scA = Get.put(SearchStateController_A());
    SearchStateController_B scB = Get.put(SearchStateController_B());

    final _height = Get.height;
    final _width = Get.width;
    final screenHeight = _height * 0.95;
    final screenWidth = _width * 0.95;

    // # 위젯 - 커스텀 앱바
    final customAppbar = SizedBox(
      height: screenHeight * 0.12,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.2,
            margin:
                const EdgeInsets.only(left: 30, right: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )),
                          padding: const EdgeInsets.all(0),
                          primary: const Color(0xFF4087EB)),
                      onPressed: () {
                        setState(() {
                          int tempIndex = 0;
                          selectGrid = 'L';
                          tempIndex = dropBlockA.indexOf(_selectedObjBlockA);
                          tempIndex =
                              tempIndex == 0 ? tempIndex : tempIndex - 1;
                          _selectedObjBlockA =
                              getBlock.elementAt(tempIndex).sBlock_CD;
                          // _selectedObjRowA = dropBayA.first;
                          get_BayInfo_A(sCorp_CD, shareWC, _selectedObjBlockA);
                          get_BlockBayContrMoveA(sCorp_CD, shareWC,
                              _selectedObjBlockA, _selectedObjRowA.toString());
                        });
                      },
                      child: const Icon(Icons.chevron_left_rounded,
                          size: 40, color: Colors.white)),
                ),
                Container(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF4087EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Colors.white70,
                      menuMaxHeight: screenHeight,
                      value: _selectedObjBlockA,
                      items: dropBlockA.map((item) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          child: AutoSizeText(mapBlock[item].toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 25)),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          selectGrid = 'L';
                          // _selectedObjRowA = dropBayA.first;
                          _selectedObjBlockA = item;
                          get_BayInfo_A(sCorp_CD, shareWC, _selectedObjBlockA);
                          get_BlockBayContrMoveA(sCorp_CD, shareWC,
                              _selectedObjBlockA, _selectedObjRowA.toString());
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        padding: const EdgeInsets.all(0),
                        primary: const Color(0xFF4087EB)),
                    onPressed: () {
                      setState(() {
                        int tempIndex = 0;
                        selectGrid = 'L';
                        tempIndex = dropBlockA.indexOf(_selectedObjBlockA);
                        tempIndex = tempIndex == dropBlockA.length - 1
                            ? tempIndex
                            : tempIndex + 1;
                        _selectedObjBlockA =
                            getBlock.elementAt(tempIndex).sBlock_CD;
                        // _selectedObjRowA = dropBayA.first;
                        get_BayInfo_A(sCorp_CD, shareWC, _selectedObjBlockA);
                        get_BlockBayContrMoveA(sCorp_CD, shareWC,
                            _selectedObjBlockA, _selectedObjRowA.toString());
                      });
                    },
                    child: const Icon(Icons.chevron_right_rounded,
                        size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.2,
            margin:
                const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                        padding: const EdgeInsets.all(0),
                        primary: const Color(0xFF4087EB)),
                    onPressed: () {
                      setState(() {
                        int tempIndex = 0;
                        selectGrid = 'L';
                        tempIndex = dropBayA.indexOf(_selectedObjRowA);
                        tempIndex = tempIndex == 0 ? tempIndex : tempIndex - 1;
                        _selectedObjRowA =
                            getBayA.elementAt(tempIndex).iROW_ID.toString();
                      });
                      get_BlockBayContrMoveA(sCorp_CD, shareWC,
                          _selectedObjBlockA, _selectedObjRowA.toString());
                    },
                    child: const Icon(Icons.chevron_left_rounded,
                        size: 40, color: Colors.white),
                  ),
                ),
                Container(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF4087EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      menuMaxHeight: screenHeight,
                      value: _selectedObjRowA,
                      items: dropBayA.map((item) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          child: AutoSizeText(item,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 25)),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          selectGrid = 'L';
                          _selectedObjRowA = item;
                          get_BlockBayContrMoveA(sCorp_CD, shareWC,
                              _selectedObjBlockA, _selectedObjRowA.toString());
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        padding: const EdgeInsets.all(0),
                        primary: const Color(0xFF4087EB)),
                    onPressed: () {
                      setState(() {
                        int tempIndex = 0;
                        selectGrid = 'L';
                        tempIndex = dropBayA.indexOf(_selectedObjRowA);
                        tempIndex = tempIndex == dropBayA.length - 1
                            ? tempIndex
                            : tempIndex + 1;
                        _selectedObjRowA =
                            getBayA.elementAt(tempIndex).iROW_ID.toString();
                      });
                      get_BlockBayContrMoveA(sCorp_CD, shareWC,
                          _selectedObjBlockA, _selectedObjRowA);
                    },
                    child: const Icon(Icons.chevron_right_rounded,
                        size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.2,
            margin:
                const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                        padding: const EdgeInsets.all(0),
                        primary: const Color(0xFF4087EB)),
                    onPressed: () {
                      setState(() {
                        selectGrid = 'R';
                        int tempIndex = 0;
                        tempIndex = dropBlockB.indexOf(_selectedObjBlockB);
                        tempIndex = tempIndex == 0 ? tempIndex : tempIndex - 1;
                        _selectedObjBlockB =
                            getBlock.elementAt(tempIndex).sBlock_CD;
                      });
                      // _selectedObjRowB = dropBayB.first;
                      get_BayInfo_B(sCorp_CD, shareWC, _selectedObjBlockB);
                      get_BlockBayContrMoveB(sCorp_CD, shareWC,
                          _selectedObjBlockB, _selectedObjRowB.toString());
                    },
                    child: const Icon(Icons.chevron_left_rounded,
                        size: 40, color: Colors.white),
                  ),
                ),
                Container(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF4087EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      menuMaxHeight: screenHeight,
                      value: _selectedObjBlockB,
                      items: dropBlockB.map((item) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          child: AutoSizeText(mapBlock[item].toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 25)),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          selectGrid = 'R';
                          // _selectedObjRowB = dropBayB.first;
                          _selectedObjBlockB = item.toString();
                          get_BayInfo_B(sCorp_CD, shareWC, _selectedObjBlockB);
                          get_BlockBayContrMoveB(sCorp_CD, shareWC,
                              _selectedObjBlockB, _selectedObjRowB.toString());
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        padding: const EdgeInsets.all(0),
                        primary: const Color(0xFF4087EB)),
                    onPressed: () {
                      setState(() {
                        selectGrid = 'R';
                        int tempIndex = 0;
                        tempIndex = dropBlockB.indexOf(_selectedObjBlockB);
                        tempIndex = tempIndex == dropBlockB.length - 1
                            ? tempIndex
                            : tempIndex + 1;
                        _selectedObjBlockB =
                            getBlock.elementAt(tempIndex).sBlock_CD;
                        // _selectedObjRowB = dropBayB.first;
                        get_BayInfo_B(sCorp_CD, shareWC, _selectedObjBlockB);
                        get_BlockBayContrMoveB(sCorp_CD, shareWC,
                            _selectedObjBlockB, _selectedObjRowB.toString());
                      });
                      // get_BlockBayContrMove(
                      //     shareWC, _selectedObjStageB, _selectedBay);
                    },
                    child: const Icon(Icons.chevron_right_rounded,
                        size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.2,
            margin:
                const EdgeInsets.only(left: 15, right: 30, top: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                        padding: const EdgeInsets.all(0),
                        primary: const Color(0xFF4087EB)),
                    onPressed: () {
                      setState(() {
                        selectGrid = 'R';
                        int tempIndex = 0;
                        tempIndex = dropBayB.indexOf(_selectedObjRowB);
                        tempIndex = tempIndex == 0 ? tempIndex : tempIndex - 1;
                        _selectedObjRowB =
                            getBayB.elementAt(tempIndex).iROW_ID.toString();
                      });
                      get_BlockBayContrMoveB(sCorp_CD, shareWC,
                          _selectedObjBlockB, _selectedObjRowB.toString());
                    },
                    child: const Icon(Icons.chevron_left_rounded,
                        size: 40, color: Colors.white),
                  ),
                ),
                Container(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF4087EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      menuMaxHeight: screenHeight,
                      value: _selectedObjRowB,
                      items: dropBayB.map((item) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          child: AutoSizeText(item,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 25)),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          selectGrid = 'R';
                          _selectedObjRowB = item;
                          get_BlockBayContrMoveB(sCorp_CD, shareWC,
                              _selectedObjBlockB, _selectedObjRowB.toString());
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                        padding: const EdgeInsets.all(0),
                        primary: const Color(0xFF4087EB)),
                    onPressed: () {
                      setState(() {
                        selectGrid = 'R';
                        int tempIndex = 0;
                        tempIndex = dropBayB.indexOf(_selectedObjRowB);
                        tempIndex = tempIndex == dropBayB.length - 1
                            ? tempIndex
                            : tempIndex + 1;
                        _selectedObjRowB = dropBayB[tempIndex];
                      });
                      get_BlockBayContrMoveB(sCorp_CD, shareWC,
                          _selectedObjBlockB, _selectedObjRowB);
                    },
                    child: const Icon(Icons.chevron_right_rounded,
                        size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // # 위젯 - 검색창 텍스트필드
    final txtSearch_A = InkWell(
      onTap: () async {
        selectGrid = 'L';
        search_Contr_A = await showSearch(
          context: context,
          delegate: CustomSearchDelegate_A(),
        ) as String;
        scA.change(search_Contr_A);
        await get_BayInfo_A(sCorp_CD, shareWC, scA.searchBlockCD.value);
        _selectedObjBlockA = scA.searchBlockCD.value;
        _selectedObjRowA = scA.searchBay.value;
        moveScroll(int.parse(scA.searchRow.value), reContrListA.length);
        _refresh();
      },
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.8,
            width: screenWidth * 0.2,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0),
            ),
            child: Center(
              child: Obx(
                () => AutoSizeText(
                  scA.searchContrNO.value,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: _fontFamily),
                ),
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.8,
            width: screenWidth * 0.25,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0),
            ),
            child: Center(
              child: Obx(
                () => AutoSizeText(
                  scA.searchBlock.value +
                      '-' +
                      scA.searchBay.value +
                      '-' +
                      scA.searchRow.value +
                      '-' +
                      scA.searchTier.value,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: _fontFamily),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // # 위젯 - 검색창 텍스트필드
    final txtSearch_B = InkWell(
      onTap: () async {
        selectGrid = 'R';
        search_Contr_B = await showSearch(
          context: context,
          delegate: CustomSearchDelegate_B(),
        ) as String;
        scB.change(search_Contr_B);
        await get_BayInfo_B(sCorp_CD, shareWC, scB.searchBlockCD.value);
        _selectedObjBlockB = scB.searchBlockCD.value;
        _selectedObjRowB = scB.searchBay.value;
        moveScroll(int.parse(scB.searchRow.value), reContrListB.length);
        _refresh();
      },
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.8,
            width: screenWidth * 0.2,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0),
            ),
            child: Center(
              child: Obx(
                () => AutoSizeText(
                  scB.searchContrNO.value,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: _fontFamily),
                ),
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.8,
            width: screenWidth * 0.25,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
               borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0),
            ),
            child: Center(
              child: Obx(
                () => AutoSizeText(
                  scB.searchBlock.value +
                      '-' +
                      scB.searchBay.value +
                      '-' +
                      scB.searchRow.value +
                      '-' +
                      scB.searchTier.value,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: _fontFamily),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // # 위젯 - 베이뷰 그리드A
    final grdBayViewA = SizedBox(
      height: screenHeight * 0.77,
      width: screenWidth * 0.485,
      child: Row(
        children: [
          Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _moveflagA,
                builder: (BuildContext context, value, Widget? child) {
                  return Container(
                    height: screenHeight * 0.72,
                    width: screenWidth * 0.485,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1),
                    ),
                    child: GridView.count(
                      shrinkWrap: true,
                      controller: _sclControllerOneA,
                      scrollDirection: Axis.horizontal,
                      childAspectRatio: 0.7,
                      crossAxisCount: 6,
                      children: List.generate(allBayCountA, (i) {
                        String sIndexTemp =
                            reContrListA.isEmpty ? '' : reContrListA[i];
                        return InkWell(
                          onDoubleTap: () {
                            if (sIndexTemp.length < 4) {
                              return;
                            } else if (sIndexTemp.toString().endsWith('L')) {
                              Get.defaultDialog(
                                  title: '알림',
                                  content: const Text('반출지시된 컨테이너가 아닙니다.'));
                            } else {
                              add_Contr_Load(
                                sCorp_CD,
                                sUser_ID,
                                '0000',
                                sIndexTemp.split('\n')[3],
                                (sIndexTemp.split('\n')[0].substring(0, 4) +
                                    sIndexTemp.split('\n')[1]),
                                shareWC,
                                _selectedObjBlockA,
                                int.parse(_selectedObjRowA),
                                ((i ~/ 6) + 1),
                                (6 - (i % 6)),
                                '0',
                                '',
                              );
                              _refresh();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: scA.searchContrNO.isNotEmpty
                                    ? (sIndexTemp.contains(scA
                                                .searchContrNO.value
                                                .substring(0, 3)) &&
                                            sIndexTemp.contains(scA
                                                .searchContrNO.value
                                                .substring(4, 10))
                                        ? Border.all(
                                            color: Colors.red, width: 4)
                                        : sIndexTemp.contains('Empty')
                                            ? Border.all(
                                                color: Colors.lightBlueAccent,
                                                width: 3)
                                            : sIndexTemp.contains('Full')
                                                ? Border.all(
                                                    color: Colors.amberAccent,
                                                    width: 3)
                                                : null)
                                    : null,
                                image: DecorationImage(
                                  image: setContrColor2(
                                    sIndexTemp,
                                    "X",
                                    "Y",
                                    "Z",
                                    "M",
                                    "W",
                                    'L',
                                    const AssetImage(
                                        "resources/image/green_container.png"),
                                    const AssetImage(
                                        "resources/image/puple_container.png"),
                                    const AssetImage(
                                        "resources/image/real_container.png"),
                                    const AssetImage(
                                        "resources/image/orange_container.png"),
                                    const AssetImage(
                                        "resources/image/blue_container.png"),
                                    const AssetImage(
                                        "resources/image/grey_container.png"),
                                    const AssetImage(
                                        "resources/image/grey_container.png"),
                                  ),
                                  fit: BoxFit.fill,
                                )),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: !sIndexTemp.endsWith('')
                                      ? BorderSide(
                                          width: 3,
                                          color: Colors.green.shade700)
                                      : BorderSide.none,
                                  elevation: sIndexTemp != '' ? 5 : 0,
                                  primary:
                                      (selectFlagA && sIndexTemp.endsWith('M'))
                                          ? Colors.transparent
                                          : setContrColor(
                                              sIndexTemp,
                                              'X',
                                              'Y',
                                              'Z',
                                              'M',
                                              'W',
                                              'L',
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.white)),
                              onPressed: () {
                                if (sIndexTemp.length == 1 &&
                                    firstClick == '') {
                                  return;
                                } else {
                                  // 이적 대상 체크
                                  if (countClick.isEmpty) {
// 초기화
                                    countClick.add(i); // 첫번째 클릭 객체 인텍스 추가
                                    setState(() {
                                      reContrListA.replaceRange(i, i + 1,
                                          [sIndexTemp.toString() + '\nM']);
                                    });

                                    firstClick = sIndexTemp; // 첫번째 객체 변수 지정
                                    selectedCart = -1;
                                    selectFlagA = true;
                                  } else {
                                    // 이적 실행
                                    setState(() {
                                      add_Contr_Move(
                                        sCorp_CD,
                                        sUser_ID,
                                        shareWC,
                                        firstClick.split("\n")[3],
                                        firstClick.split("\n")[0],
                                        _selectedObjBlockA,
                                        _selectedObjRowA.toString(),
                                        ((i ~/ 6) + 1).toString(),
                                        (6 - (i % 6)).toString(),
                                        '',
                                        '',
                                      );
                                    });
                                    setState(() {
                                      selectedCart = i;
                                      selectFlagA = false;

                                      countClick.clear();
                                      firstClick = '';
                                      // selectFlagA = true;
                                    });
                                  }
                                }
                              },
                              child: AutoSizeText(
                                sIndexTemp.length > 10 // 공백 있음
                                    ? sIndexTemp.toString().split('\n')[0] +
                                        '\n' +
                                        sIndexTemp.toString().split('\n')[1] +
                                        '\n' +
                                        sIndexTemp.toString().split('\n')[2]
                                    : ' ',
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: _fontFamily,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.485,
                child: GridView.count(
                  controller: _sclControllerTwoA,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  childAspectRatio: 0.29,
                  crossAxisCount: 1,
                  children: List.generate(rowBayCountA, (i) {
                    return Container(
                      margin: EdgeInsets.zero,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFF777777),
                          border: Border.all(color: Colors.white)),
                      child: AutoSizeText(
                        (i + 1).toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ],
      ),
    );
    // # 위젯 - 베이뷰 그리드B
    final grdBayViewB = SizedBox(
      height: screenHeight * 0.77,
      width: screenWidth * 0.485,
      child: Row(
        children: [
          Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _moveflagB,
                builder: (BuildContext context, value, Widget? child) {
                  return Container(
                    height: screenHeight * 0.72,
                    width: screenWidth * 0.485,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1),
                    ),
                    child: GridView.count(
                      shrinkWrap: true,
                      controller: _sclControllerOneB,
                      scrollDirection: Axis.horizontal,
                      childAspectRatio: 0.7,
                      crossAxisCount: 6,
                      children: List.generate(allBayCountB, (i) {
                        String sIndexTemp =
                            reContrListB.isEmpty ? '' : reContrListB[i];
                        return InkWell(
                          onDoubleTap: () {
                            if (sIndexTemp.length < 4) {
                              return;
                            } else if (sIndexTemp.toString().endsWith('L')) {
                              Get.defaultDialog(
                                  title: '알림',
                                  content: const Text('반출지시된 컨테이너가 아닙니다.'));
                            } else {
                              add_Contr_Load(
                                sCorp_CD,
                                sUser_ID,
                                '0000',
                                sIndexTemp.split('\n')[3],
                                (sIndexTemp.split('\n')[0].substring(0, 4) +
                                    sIndexTemp.split('\n')[1]),
                                shareWC,
                                _selectedObjBlockB,
                                int.parse(_selectedObjRowB),
                                ((i ~/ 6) + 1),
                                (6 - (i % 6)),
                                '0',
                                '',
                              );
                              _refresh();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: scB.searchContrNO.isNotEmpty
                                    ? (sIndexTemp.contains(scB
                                                .searchContrNO.value
                                                .substring(0, 3)) &&
                                            sIndexTemp.contains(scB
                                                .searchContrNO.value
                                                .substring(4, 10))
                                        ? Border.all(
                                            color: Colors.red, width: 7)
                                        : sIndexTemp.contains('Empty')
                                            ? Border.all(
                                                color: Colors.lightBlueAccent,
                                                width: 3)
                                            : sIndexTemp.contains('Full')
                                                ? Border.all(
                                                    color: Colors.amberAccent,
                                                    width: 3)
                                                : null)
                                    : null,
                                image: DecorationImage(
                                  image: setContrColor2(
                                    sIndexTemp,
                                    "X",
                                    "Y",
                                    "Z",
                                    "M",
                                    "W",
                                    "L",
                                    const AssetImage(
                                        "resources/image/green_container.png"),
                                    const AssetImage(
                                        "resources/image/puple_container.png"),
                                    const AssetImage(
                                        "resources/image/real_container.png"),
                                    const AssetImage(
                                        "resources/image/orange_container.png"),
                                    const AssetImage(
                                        "resources/image/blue_container.png"),
                                    const AssetImage(
                                        "resources/image/grey_container.png"),
                                    const AssetImage(
                                        "resources/image/grey_container.png"),
                                  ),
                                  fit: BoxFit.fill,
                                )),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: !sIndexTemp.endsWith('')
                                      ? BorderSide(
                                          width: 3,
                                          color: Colors.green.shade700)
                                      : BorderSide.none,
                                  elevation: sIndexTemp != '' ? 5 : 0,
                                  primary:
                                      (selectFlagB && sIndexTemp.endsWith('M'))
                                          ? Colors.transparent
                                          : setContrColor(
                                              sIndexTemp,
                                              "X",
                                              "Y",
                                              "Z",
                                              "M",
                                              "#",
                                              "L",
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.white)),
                              onPressed: () {
                                if (sIndexTemp.length == 1 &&
                                    firstClick == '') {
                                  return;
                                } else {
                                  // 이적 대상 체크
                                  if (countClick.isEmpty) {
// 초기화
                                    countClick.add(i); // 첫번째 클릭 객체 인텍스 추가
                                    setState(() {
                                      reContrListB.replaceRange(i, i + 1,
                                          [sIndexTemp.toString() + '\nM']);
                                    });

                                    firstClick = sIndexTemp; // 첫번째 객체 변수 지정

                                    selectedCart = -1;
                                    selectFlagB = true;
                                  } else {
                                    // 이적 실행
                                    setState(() {
                                      add_Contr_Move(
                                        sCorp_CD,
                                        sUser_ID,
                                        shareWC,
                                        firstClick.split("\n")[3],
                                        firstClick.split("\n")[0],
                                        _selectedObjBlockB,
                                        _selectedObjRowB.toString(),
                                        ((i ~/ 6) + 1).toString(),
                                        (6 - (i % 6)).toString(),
                                        '',
                                        '',
                                      );
                                    });
                                    setState(() {
                                      selectedCart = i;
                                      selectFlagB = false;

                                      countClick.clear();
                                      firstClick = '';
                                      // selectFlagB = true;
                                    });
                                  }
                                }
                              },
                              child: AutoSizeText(
                                sIndexTemp.length > 10 // 공백 있음
                                    ? sIndexTemp.toString().split('\n')[0] +
                                        '\n' +
                                        sIndexTemp.toString().split('\n')[1] +
                                        '\n' +
                                        sIndexTemp.toString().split('\n')[2]
                                    : ' ',
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: _fontFamily,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.485,
                child: GridView.count(
                  controller: _sclControllerTwoB,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  childAspectRatio: 0.29,
                  crossAxisCount: 1,
                  children: List.generate(rowBayCountB, (i) {
                    return Container(
                      margin: EdgeInsets.zero,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFF777777),
                          border: Border.all(color: Colors.white)),
                      child: AutoSizeText(
                        (i + 1).toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          child: Center(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  customAppbar,
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      grdBayViewA,
                      SizedBox(
                        height: screenHeight * 0.77,
                        width: screenWidth * 0.03,
                        child: GridView.count(
                          childAspectRatio: 0.425,
                          crossAxisCount: 1,
                          children: List.generate(6, (i) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF777777),
                                  border: Border.all(color: Colors.white)),
                              child: AutoSizeText(
                                (6 - i).toString(),
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontFamily: _fontFamily,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      grdBayViewB,
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    height: screenHeight * 0.08,
                    width: Get.width,
                    color: const Color(0xFFDCDCDC),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        txtSearch_A,
                        txtSearch_B,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
        backgroundColor: Colors.black45,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  // 그리드 컨트롤러 컨트롤 함수
  Future<void> moveScroll(int iRow, int rowlegth) async {
    if (selectGrid == 'L') {
      if (iRow < 5) {
        _sclControllerOneA.animateTo(
            _sclControllerOneA.position.minScrollExtent,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
        _sclControllerTwoA.animateTo(
            _sclControllerTwoA.position.minScrollExtent,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
      } else {
        _sclControllerOneA.animateTo(
            _sclControllerOneA.position.maxScrollExtent * iRow / rowlegth * 6,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
        _sclControllerTwoA.animateTo(
            _sclControllerTwoA.position.maxScrollExtent * iRow / rowlegth * 6,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
      }
    } else {
      if (iRow < 5) {
        _sclControllerOneB.animateTo(
            _sclControllerOneB.position.minScrollExtent,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
        _sclControllerTwoB.animateTo(
            _sclControllerTwoB.position.minScrollExtent,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
      } else {
        _sclControllerOneB.animateTo(
            _sclControllerOneB.position.maxScrollExtent * iRow / rowlegth * 6,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
        _sclControllerTwoB.animateTo(
            _sclControllerTwoB.position.maxScrollExtent * iRow / rowlegth * 6,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.ease);
      }
    }
  }
}

class CustomSearchDelegate_A extends SearchDelegate {
  // # Api 관련 변수
  List<SearchContrResponseModel> getSearchList_A = [];
  late String tempArg_A = '';

  // # 캐시 호출(작업장)
  String sCorp_CD_A = '';
  String shareWC_A = '';

  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD_A = prefs.getString('CorpCD')!;
    shareWC_A = prefs.getString('WC') ?? '';
  }

  // # API 호출(파트너 리스트)
  Future<List<SearchContrResponseModel>> get_SearchContr_A(
      String sCorpCD, String sWCCD,
      {required String sContr_NO}) async {
    APIGetSearchContr apiGetSearchContr_A = APIGetSearchContr();
    List<String> sParam = [sCorpCD, sWCCD, sContr_NO];
    await apiGetSearchContr_A
        .getSelect("USP_GET_CONTR_SEARCH", sParam)
        .then((value) {
      getSearchList_A = value.contr;
    });
    return getSearchList_A;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<SearchContrResponseModel>>(
        future: get_SearchContr_A(sCorp_CD_A, shareWC_A, sContr_NO: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          List<SearchContrResponseModel>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    tempArg_A =
                        '${data?[index].sContr_NO.toString()}/${data?[index].sBlock_CD.toString()}/${data?[index].sBlock_NM.toString()}/${data?[index].sBay_ID.toString()}/${data?[index].sRow_ID.toString()}/${data?[index].sTier_ID.toString()}';
                    close(context, tempArg_A);
                  },
                  title: Row(
                    children: [
                      Container(
                        width: Get.width * 0.2,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            '${data?[index].sContr_NO}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '${data?[index].sBP_CD}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            AutoSizeText(
                              '${data?[index].sBlock_NM}'
                              '-'
                              '${data?[index].sBay_ID}'
                              '-'
                              '${data?[index].sRow_ID}'
                              '-'
                              '${data?[index].sTier_ID}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ])
                    ],
                  ),
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _loadCounter();
    return const Center(
      child: AutoSizeText('컨테이너 검색'),
    );
  }
}

class CustomSearchDelegate_B extends SearchDelegate {
  // # Api 관련 변수
  List<SearchContrResponseModel> getSearchList_B = [];
  late String tempArg_B = '';

  // # 캐시 호출(작업장)
  String sCorp_CD_B = '';
  String shareWC_B = '';

  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD_B = prefs.getString('CorpCD')!;
    shareWC_B = prefs.getString('WC') ?? '';
  }

  // # API 호출(파트너 리스트)
  Future<List<SearchContrResponseModel>> get_SearchContr_B(
      String sCorpCD, String sWCCD,
      {required String sContr_NO}) async {
    APIGetSearchContr apiGetSearchContr_B = APIGetSearchContr();
    List<String> sParam = [sCorpCD, sWCCD, sContr_NO];
    await apiGetSearchContr_B
        .getSelect("USP_GET_CONTR_SEARCH", sParam)
        .then((value) {
      getSearchList_B = value.contr;
    });
    return getSearchList_B;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<SearchContrResponseModel>>(
        future: get_SearchContr_B(sCorp_CD_B, shareWC_B, sContr_NO: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          List<SearchContrResponseModel>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    tempArg_B =
                        '${data?[index].sContr_NO.toString()}/${data?[index].sBlock_CD.toString()}/${data?[index].sBlock_NM.toString()}/${data?[index].sBay_ID.toString()}/${data?[index].sRow_ID.toString()}/${data?[index].sTier_ID.toString()}';
                    close(context, tempArg_B);
                  },
                  title: Row(
                    children: [
                      Container(
                        width: Get.width * 0.2,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            '${data?[index].sContr_NO}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '${data?[index].sBP_CD}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            AutoSizeText(
                              '${data?[index].sBlock_NM}'
                              '-'
                              '${data?[index].sBay_ID}'
                              '-'
                              '${data?[index].sRow_ID}'
                              '-'
                              '${data?[index].sTier_ID}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ])
                    ],
                  ),
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _loadCounter();
    return const Center(
      child: AutoSizeText('컨테이너 검색'),
    );
  }
}
