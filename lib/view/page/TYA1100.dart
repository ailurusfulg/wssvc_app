// ignore_for_file: non_constant_identifier_names, must_call_super, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../api/api.dart';
import '../../common/common_widget.dart';
import '../../common/navigation_drawer_widget.dart';
import '../../controller/controllers.dart';
import '../../model/models.dart';

class TYA1100 extends StatefulWidget {
  const TYA1100({Key? key}) : super(key: key);

  @override
  _TYA1100 createState() => _TYA1100();
}

class _TYA1100 extends State<TYA1100> with AutomaticKeepAliveClientMixin {
  bool _isDrawerOpen = false;

  // # Drawer 콜백
  void drawerCallback(bool isOpen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isDrawerOpen = isOpen;
        FocusScope.of(context).requestFocus(FocusNode());
        if (_isDrawerOpen == false) {
          _refresh();
        }
      });
    });
  }

  // # 그리드 관련 변수
  bool selectFlag = false;
  final DataGridController _controller = DataGridController();
  late final _moveflag = ValueNotifier(selectFlag);
  String firstClick = '';
  int firstClickIndex = 0;
  List<int> clickIndex = [];

  // # 리스트 새로고침 관련 변수
  int currentRow = -1;
  String stateOrder = 'L';
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  // # 레이아웃 관련 변수
  final String _fontFamily = 'NotoSansKR';

  // # 그리드 MultiScrollController
  late ScrollController _scrollControllerOne, _scrollControllerTwo;

  // # API 관련 변수
  List<LoadResponseModel> getLoadOrder = [];
  List<UnLoadResponseModel> getUnLoadOrder = [];
  List<BlockResponseModel> getBlock = [];
  List<BayResponseModel> getBay = [];
  List<LOCResponseModel> getLocationContr = [];
  List<AddContrLoadResponseModel> result_L = [];
  List<AddContrUnLoadResponseModel> result_U = [];

  var reContrList = [];
  int allBayCount = 35;
  int rowBayCount = 5;
  bool isDisposed = false;

  // # 검색창 관련 변수
  final key = GlobalKey<ScaffoldState>();
  final _searchQuery = TextEditingController();
  List<LoadResponseModel> searchLoadOrder = [];
  List<UnLoadResponseModel> searchUnLoadOrder = [];
  String _searchText = "";
  FocusNode searchFocus = FocusNode();
  late String search_Contr = '';

  // # 캐시 저장 관련 변수
  late String shareWC = '', sCorp_CD = '', sUser_ID = '', shareBLOCK = '';

  // # 기타 변수
  late String sContainerCode = '';
  var _selectedBlock, _selectedBay;
  List<String> dropBlock = [], dropBlockNM = [], dropBay = [];
  late LoadResponseModel _paramModel_L;
  late UnLoadResponseModel _paramModel_U;
  String sContrNO_L = '', sContrNO_U = '';
  String sCONTR_KEY_L = '', sCONTR_KEY_U = '';
  Map<String, String> mapBlock = {};

  // # API 호출(상자지시 리스트)
  Future<void> get_LoadOrder() async {
    APIGetLoadOrder apiGetLoadOrder = APIGetLoadOrder();
    List<String> sParam = [sCorp_CD, shareWC, ''];
    await apiGetLoadOrder.getSelect("USP_GET_LOADORDER", sParam).then((value) {
      setState(() {
        getLoadOrder = value.approval.isNotEmpty ? value.approval : [];
      });
    });
  }

  // # API 호출(하차지시 리스트)
  Future<void> get_UnLoadOrder() async {
    APIGetUnLoadOrder apiGetUnLoadOrder = APIGetUnLoadOrder();
    List<String> sParam = [sCorp_CD, shareWC, ''];
    await apiGetUnLoadOrder
        .getSelect("USP_GET_UNLOADORDER", sParam)
        .then((value) {
      setState(() {
        getUnLoadOrder = value.approval.isNotEmpty ? value.approval : [];
      });
    });
  }

  // # API 호출(블록정보 리스트)
  Future<void> get_BlockInfo() async {
    APIGetBlockInfo apiGetBlockInfo = APIGetBlockInfo();
    List<String> sParam = [sCorp_CD, shareWC];
    await apiGetBlockInfo.getSelect("USP_GET_BLOCK_INFO", sParam).then((value) {
      setState(() {
        int tempIndex = 0;
        if (value.block.isNotEmpty) {
          getBlock = value.block;
          for (int i = 0; i < getBlock.length; i++) {
            mapBlock[getBlock.elementAt(i).sBlock_CD] =
                getBlock.elementAt(i).sBlock_NM;
            dropBlock.add(getBlock.elementAt(i).sBlock_CD);
            if (getBlock.elementAt(i).sPlate_Top.contains('Y')) {
              tempIndex = i;
              _setShareBLOCK(dropBlock[tempIndex]);
            }
          }
          _selectedBlock = shareBLOCK;
        } else {
          getBlock = [];
        }
      });
    });
  }

  // # API 호출(베이정보 리스트)
  Future<void> get_BayInfo(
      String sCorpCD, String sWorkCenter, String sLocNo) async {
    APIGetBayInfo apiGetBayInfo = APIGetBayInfo();
    List<String> sParam = [sCorpCD, sWorkCenter, sLocNo];
    await apiGetBayInfo.getSelect("USP_GET_BAY_INFO", sParam).then((value) {
      setState(() {
        dropBay.clear();
        if (value.bay.isNotEmpty) {
          getBay = value.bay;
          for (int i = 0; i < getBay.length; i++) {
            dropBay.add(getBay.elementAt(i).iROW_ID.toString());
          }
          _selectedBay =
              dropBay.contains(_selectedBay) ? _selectedBay : dropBay.last;
        } else {
          getBay = [];
        }
      });
    });
  }

  // # API 호출(컨테이너위치 리스트)
  Future<void> get_BlockBayContrMove(String sCorpCD, String sWorkCenter,
      String sStockCD, String sBayCD) async {
    APIGetLocationContrMove apiGetLocationContrMove = APIGetLocationContrMove();
    List<String> sParam = [sCorpCD, sWorkCenter, sStockCD, sBayCD];
    await apiGetLocationContrMove
        .getSelect("USP_GET_BLOCKBAYCONTRMOVE", sParam)
        .then((value) {
      setState(() {
        reContrList.clear();
        if (value.approval.isNotEmpty) {
          getLocationContr = value.approval;
          allBayCount = getLocationContr.length * 6;
          rowBayCount = getLocationContr.length;

          for (int i = 0; i < rowBayCount; i++) {
            reContrList.add(getLocationContr.elementAt(i).sTier6);
            reContrList.add(getLocationContr.elementAt(i).sTier5);
            reContrList.add(getLocationContr.elementAt(i).sTier4);
            reContrList.add(getLocationContr.elementAt(i).sTier3);
            reContrList.add(getLocationContr.elementAt(i).sTier2);
            reContrList.add(getLocationContr.elementAt(i).sTier1);
          }
          Get.log('무브');
        } else {
          getLocationContr = [];
        }
      });
    });
  }

  // # API 호출(컨테이너 상차등록)
  Future<void> add_Contr_Load(
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
            Get.defaultDialog(title: "알림", content: Text(Msg));
          }
        } else {}
      });
    });
  }

  // # API 호출(컨테이너 하차등록)
  Future<void> add_Contr_UnLoad(
    String sCorpCD,
    String sDRVID,
    String sVehicle,
    String sContrKey,
    String sContrNO,
    String sWorkCenter,
    String sBlockCD,
    String sBayID,
    String sRowID,
    String sTierID,
    String sOutCode,
    String sOutString,
  ) async {
    APIAddContrUnLoad apiAddContrUnLoad = APIAddContrUnLoad();
    List<String> sParam = [
      sCorpCD,
      sDRVID,
      sVehicle,
      sContrKey,
      sContrNO,
      sWorkCenter,
      sBlockCD,
      sBayID,
      sRowID,
      sTierID,
      sOutCode,
      sOutString,
    ];
    await apiAddContrUnLoad
        .getUpdate("USP_ADD_CONTR_UNLOAD", sParam)
        .then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          result_U = value.result;
          String Msg = result_U.elementAt(0).rsMsg;
          if (result_U.elementAt(0).rsCode != "S") {
            Get.defaultDialog(title: "알림", content: Text(Msg));
          }
        } else {}
      });
    });
  }

// # 캐시 호출
  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD = prefs.getString('CorpCD')!;
    sUser_ID = prefs.getString('UserID') ?? '';
    shareWC = prefs.getString('WC') ?? '';
    shareBLOCK = prefs.getString('dBLOCK') ?? '';
    get_LoadOrder();
    get_UnLoadOrder();
    get_BlockInfo();
    get_BayInfo(sCorp_CD, shareWC, shareBLOCK);
    get_BlockBayContrMove(sCorp_CD, shareWC, shareBLOCK, '1');
  }

// # 캐시 호출(작업장)
  Future<void> _setShareBLOCK(defaultBlock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dBLOCK', defaultBlock);
  }

  // # 검색 기능
  _TYA1100() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SearchStateController sc = Get.put(SearchStateController());

    final screenHeight = Get.height * 0.95;
    final screenWidth = Get.width * 0.95;

    // # 위젯 - 커스텀 앱바
    final customAppbar = SizedBox(
      height: screenHeight * 0.12,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.14,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  clearSelectGrid();
                  stateOrder = 'L';

                  get_LoadOrder();
                  get_BlockBayContrMove(sCorp_CD, shareWC,
                      _selectedBlock ?? '1', _selectedBay.toString());
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: stateOrder == 'L' ? const Color(0xff4087EB) : Colors.white,
                side: BorderSide(
                  color: stateOrder == 'L'
                      ? Colors.white
                      : const Color(0xff4087EB),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: AutoSizeText('반 출',
                  style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 25,
                      color: stateOrder == 'L'
                          ? Colors.white
                          : const Color(0xff4087EB))),
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.14,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  clearSelectGrid();
                  stateOrder = 'U';

                  get_UnLoadOrder();
                  get_BlockBayContrMove(sCorp_CD, shareWC,
                      _selectedBlock ?? '1', _selectedBay.toString());
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: stateOrder == 'U' ? const Color(0xff4087EB) : Colors.white,
                side: BorderSide(
                  color: stateOrder == 'U'
                      ? Colors.white
                      : const Color(0xff4087EB),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: AutoSizeText('반 입',
                  style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 25,
                      color: stateOrder == 'U'
                          ? Colors.white
                          : const Color(0xff4087EB))),
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.14,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xff4087EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: AutoSizeText('하차등록',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 25,
                      color: const Color(0xff4087EB),
                    )),
              );
            }),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.14,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/move',
                    arguments: '$_selectedBlock/$_selectedBay');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xff4087EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: AutoSizeText('이 적',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 25,
                    color: const Color(0xff4087EB),
                  )),
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth * 0.2,
            margin: const EdgeInsets.all(10),
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
                          )), backgroundColor: const Color(0xFF4087EB),
                          padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        setState(() {
                          clearSelectGrid();
                          int tempIndex = 0;
                          tempIndex = dropBlock.indexOf(_selectedBlock);
                          tempIndex =
                              tempIndex == 0 ? tempIndex : tempIndex - 1;
                          _selectedBlock =
                              getBlock.elementAt(tempIndex).sBlock_CD;
                          get_BayInfo(sCorp_CD, shareWC, _selectedBlock);
                          get_BlockBayContrMove(
                              sCorp_CD, shareWC, _selectedBlock, _selectedBay);
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
                      value: _selectedBlock,
                      items: dropBlock.map((item) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            width: screenWidth * 0.05,
                            decoration: BoxDecoration(
                                color: item == _selectedBlock
                                    ? const Color(0xFF0D3965)
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: AutoSizeText(mapBlock[item].toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: item == _selectedBlock
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                          ),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          clearSelectGrid();
                          _selectedBlock = item;
                          sContrNO_U = '';
                          get_BayInfo(sCorp_CD, shareWC, _selectedBlock);
                          get_BlockBayContrMove(
                              sCorp_CD, shareWC, _selectedBlock, _selectedBay);
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
                        )), backgroundColor: const Color(0xFF4087EB),
                        padding: const EdgeInsets.all(0)),
                    onPressed: () {
                      setState(() {
                        clearSelectGrid();
                        int tempIndex = 0;
                        tempIndex = dropBlock.indexOf(_selectedBlock);
                        tempIndex = tempIndex == dropBlock.length - 1
                            ? tempIndex
                            : tempIndex + 1;
                        _selectedBlock =
                            getBlock.elementAt(tempIndex).sBlock_CD;
                        get_BayInfo(sCorp_CD, shareWC, _selectedBlock);
                        get_BlockBayContrMove(
                            sCorp_CD, shareWC, _selectedBlock, _selectedBay);
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
            margin: const EdgeInsets.only(
              left: 5,
              right: 10,
              top: 10,
              bottom: 10,
            ),
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
                        )), backgroundColor: const Color(0xFF4087EB),
                        padding: const EdgeInsets.all(0)),
                    onPressed: () {
                      setState(() {
                        clearSelectGrid();
                        int tempIndex = 0;
                        tempIndex = dropBay.indexOf(_selectedBay);
                        tempIndex = tempIndex == 0 ? tempIndex : tempIndex - 1;
                        _selectedBay =
                            getBay.elementAt(tempIndex).iROW_ID.toString();
                      });
                      get_BlockBayContrMove(
                          sCorp_CD, shareWC, _selectedBlock, _selectedBay);
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
                      dropdownColor: Colors.white70,
                      menuMaxHeight: screenHeight,
                      value: _selectedBay,
                      items: dropBay.map((item) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            width: screenWidth * 0.05,
                            decoration: BoxDecoration(
                                color: item == _selectedBay
                                    ? const Color(0xFF0D3965)
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: AutoSizeText(item,
                                style: TextStyle(
                                    color: item == _selectedBay
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                          ),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          clearSelectGrid();
                          _selectedBay = item;
                          sContrNO_U = '';

                          get_BlockBayContrMove(
                              sCorp_CD, shareWC, _selectedBlock, _selectedBay);
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
                        backgroundColor: const Color(0xFF4087EB),
                        padding: const EdgeInsets.all(0)),
                    onPressed: () {
                      setState(() {
                        clearSelectGrid();
                        int tempIndex = 0;
                        tempIndex = dropBay.indexOf(_selectedBay);
                        tempIndex = tempIndex == dropBay.length - 1
                            ? tempIndex
                            : tempIndex + 1;
                        _selectedBay =
                            getBay.elementAt(tempIndex).iROW_ID.toString();
                      });
                      get_BlockBayContrMove(
                          sCorp_CD, shareWC, _selectedBlock, _selectedBay);
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
    final txtSearchList = Container(
      height: screenHeight * 0.08,
      width: screenWidth * 0.45,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 6),
      child: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: ThemeData()
                .colorScheme
                .copyWith(primary: const Color(0xff707070))),
        child: AutoSizeTextField(
            autofocus: false,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            controller: _searchQuery,
            style: const TextStyle(color: Colors.black, fontSize: 25),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(
                Icons.search,
                size: 35,
              ),
              suffixIcon: IconButton(
                onPressed: _searchQuery.clear,
                icon: const Icon(Icons.clear),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: Color(0xFFEBF3FB),
                  )),
            )),
      ),
    );

    // # 위젯 - 검색창 텍스트필드
    final txtSearch = InkWell(
      onTap: () async {
        search_Contr = await showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        ) as String;
        sc.change(search_Contr);
        get_BayInfo(sCorp_CD, shareWC, sc.searchBlockCD.value);
        _selectedBlock = sc.searchBlockCD.value;
        _selectedBay = sc.searchBay.value;
        moveScroll(int.parse(sc.searchRow.value), reContrList.length);
        _refresh();
      },
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.8,
            width: screenWidth * 0.25,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
            child: Center(
              child: Obx(
                () => AutoSizeText(
                  sc.searchContrNO.value,
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
            width: screenWidth * 0.3,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
            child: Center(
              child: Obx(
                () => AutoSizeText(
                  sc.searchBlock.value +
                      '-' +
                      sc.searchBay.value +
                      '-' +
                      sc.searchRow.value +
                      '-' +
                      sc.searchTier.value,
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

    // # 위젯 - 도움말
    final txtHelper = InkWell(
      onTap: () {
        Get.toNamed('/cancel');
      },
      child: Container(
        height: screenHeight * 0.08,
        width: screenWidth * 0.1,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF2A4178),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.restart, size: 30, color: Colors.white),
            AutoSizeText(' 복구',
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: _fontFamily)),
          ],
        ),
      ),
    );

    // # 위젯 - 재수신 버튼
    final btnResearch = InkWell(
        onTap: () {
          setState(() {
            _searchQuery.clear();
            _refresh();
          });
        },
        child: Container(
          height: screenHeight * 0.08,
          width: screenWidth * 0.15,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A4178),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.repeat, size: 30, color: Colors.white),
              AutoSizeText(' 재수신',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: _fontFamily)),
            ],
          ),
        ));

    // # 위젯 - 확인(저장) 버튼
    final btnSave = InkWell(
        onTap: () {
          if (firstClick.isEmpty || !selectFlag) {
            Get.defaultDialog(
                title: '알림',
                content: Text(stateOrder == 'L'
                    ? '반출 할 컨테이너를 선택하세요.'
                    : '반입 할 컨테이너를 선택하세요.'));
            return;
          } else if (firstClick.endsWith('L')) {
            return;
          } else {
            setState(() {
              stateOrder == 'L'
                  ? add_Contr_Load(
                      sCorp_CD,
                      sUser_ID,
                      '0000',
                      firstClick.split('\n')[3],
                      firstClick.split('\n')[0],
                      shareWC,
                      _selectedBlock,
                      int.parse(_selectedBay),
                      ((firstClickIndex ~/ 6) + 1),
                      (6 - (firstClickIndex % 6)),
                      '0',
                      '',
                    )
                  : add_Contr_UnLoad(
                      sCorp_CD,
                      sUser_ID,
                      '0000',
                      _paramModel_U.sCONTR_KEY,
                      _paramModel_U.sContrNO,
                      shareWC,
                      _selectedBlock,
                      _selectedBay,
                      ((firstClickIndex ~/ 6) + 1).toString(),
                      (6 - (firstClickIndex % 6)).toString(),
                      '0',
                      '',
                    );
              stateOrder == 'L' ? get_LoadOrder() : get_UnLoadOrder();
              _refresh();
              firstClick = '';
              selectFlag = false;
              sContrNO_U = '';
            });
          }
        },
        child: Container(
          height: screenHeight * 0.08,
          width: screenWidth * 0.15,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A4178),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.floppy_disk,
                size: 30,
                color: Colors.white,
              ),
              AutoSizeText(' 확인',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: _fontFamily)),
            ],
          ),
        ));

    // # 위젯 - 컨테이너 리스트
    final grdLoadOrderList = Container(
      height: screenHeight * 0.62,
      width: screenWidth * 0.45,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black54),
      ),
      child: RefreshIndicator(
        key: refreshKey,
        backgroundColor: const Color(0xff12214B),
        color: Colors.white,
        displacement: 200,
        strokeWidth: 5,
        onRefresh: _refresh,
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
              selectionColor: const Color(0xFFfdcda4),
              headerColor: const Color(0xFF6D6D6D),
              gridLineColor: const Color(0xFF707070)),
          child: SfDataGrid(
            controller: _controller,
            frozenColumnsCount: 2,
            onCurrentCellActivated: (RowColumnIndex currentRowColumnIndex,
                RowColumnIndex previousRowColumnIndex) {
              currentRow = currentRowColumnIndex.columnIndex;
            },
            allowSorting: false,
            headerGridLinesVisibility: GridLinesVisibility.none,
            gridLinesVisibility: GridLinesVisibility.both,
            rowHeight: screenHeight * 0.1,
            headerRowHeight: screenHeight * 0.07,
            selectionMode: SelectionMode.single,
            onCellTap: (DataGridCellTapDetails details) async {
              if (details.rowColumnIndex.rowIndex < 1) {
                return;
              } else {
                // 상차
                if (stateOrder == 'L') {
                  _paramModel_L = getLoadOrder.where((element) {
                    return element.sContrNO
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()) ||
                        element.sORD_EMP
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()) ||
                        element.sVES_CD
                            .toLowerCase()
                            .contains(_searchText.toLowerCase());
                  }).toList()[details.rowColumnIndex.rowIndex - 1];

                  _selectedBlock = _paramModel_L.sBlock;
                  _selectedBay = _paramModel_L.iBay.toString();

                  get_BayInfo(sCorp_CD, shareWC, _selectedBlock).then((value) =>
                      get_BlockBayContrMove(
                          sCorp_CD, shareWC, _selectedBlock, _selectedBay));

                  _selectedBlock = _paramModel_L.sBlock;
                  _selectedBay = _paramModel_L.iBay.toString();

                  moveScroll(_paramModel_L.iRow, reContrList.length);

                  sContrNO_L = _paramModel_L.sContrNO;
                  sCONTR_KEY_L = _paramModel_L.sCONTR_KEY;

                  String temp = sContrNO_L.substring(4, 12).replaceAll(' ', '');

                  setState(() {
                    reContrList.contains(temp);

                    for (int tempint = 0;
                        tempint < reContrList.length;
                        tempint++) {
                      if (reContrList[tempint].toString().contains(temp)) {
                        reContrList[tempint] = reContrList[tempint] + '\nM';
                        break;
                      }
                    }
                  });
                  // 하차
                } else {
                  selectFlag = true;
                  _paramModel_U = getUnLoadOrder.where((element) {
                    return element.sContrNO
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()) ||
                        element.sWRK_PLN_DT
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()) ||
                        element.sORD_EMP
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()) ||
                        element.sVES_CD
                            .toLowerCase()
                            .contains(_searchText.toLowerCase());
                  }).toList()[details.rowColumnIndex.rowIndex - 1];

                  if (_paramModel_U.sVes_Block == 0 &&
                      _paramModel_U.sVes_Bay == 0) {
                    sContrNO_U = _paramModel_U.sContrNO;
                    sCONTR_KEY_U = _paramModel_U.sCONTR_KEY;
                  } else if (_selectedBlock ==
                          _paramModel_U.sVes_Block.toString() &&
                      _selectedBay == _paramModel_U.sVes_Bay.toString()) {
                    sContrNO_U = _paramModel_U.sContrNO;
                    sCONTR_KEY_U = _paramModel_U.sCONTR_KEY;
                  } else {
                    _selectedBlock = _paramModel_U.sVes_Block.toString();
                    _selectedBay = _paramModel_U.sVes_Bay.toString();
                    firstClick = '';
                    selectFlag = false;
                    await get_BayInfo(sCorp_CD, shareWC, _selectedBlock);
                    get_BlockBayContrMove(
                        sCorp_CD, shareWC, _selectedBlock, _selectedBay);
                  }
                }
              }
            },
            source: stateOrder == 'L'
                ? ContainerDataSource(dataSource: _buildSearchList())
                : UnContainerDataSource(dataSource: _buildUnSearchList()),
            columns: <GridColumn>[
              GridColumn(
                  columnName: '구분',
                  width: 50,
                  label: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'No.',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '컨테이너',
                  width: 150,
                  label: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(
                        color: Colors.white,
                      ))),
                      child: AutoSizeText(
                        '컨 테 이 너',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '유형',
                  width: 65,
                  label: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '유형',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: 70,
                  columnName: stateOrder == 'L' ? '반출예정일' : '반입예정일',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(
                        color: Colors.white,
                      ))),
                      child: AutoSizeText(
                        '반출일',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: 70,
                  columnName: '오더',
                  label: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '오더',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: 0,
                  columnName: '반출지',
                  label: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '반출지',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: 137,
                  columnName: '추가정보',
                  label: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(
                        color: Colors.white,
                      ))),
                      child: AutoSizeText(
                        '추가정보',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: _fontFamily),
                      ))),
            ],
          ),
        ),
      ),
    );
    // # 위젯 - 컨테이너 그리드
    final grdLoadOrderTable = Container(
      height: screenHeight * 0.71,
      width: screenWidth * 0.545,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFF707070)),
      ),
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.71,
            width: screenWidth * 0.03,
            margin: EdgeInsets.only(bottom: screenHeight * 0.05),
            child: GridView.count(
              childAspectRatio: 0.467,
              crossAxisCount: 1,
              children: List.generate(6, (i) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0xFF6D6D6D),
                      border: Border.all(color: Colors.white)),
                  child: AutoSizeText(
                    (6 - i).toString(),
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: _fontFamily,
                    ),
                  ),
                );
              }),
            ),
          ),
          Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: _moveflag,
                  builder: (BuildContext context, value, Widget? child) {
                    return Container(
                      height: screenHeight * 0.657,
                      width: screenWidth * 0.513,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(color: const Color(0xFF6D6D6D)),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        controller: _scrollControllerOne,
                        scrollDirection: Axis.horizontal,
                        childAspectRatio: 0.62,
                        crossAxisCount: 6,
                        children: List.generate(allBayCount, (i) {
                          String sIndexTemp =
                              reContrList.isEmpty ? "" : reContrList[i];
                          return Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                border: sc.searchContrNO.isNotEmpty
                                    ? (sIndexTemp.contains(sc
                                                .searchContrNO.value
                                                .substring(0, 3)) &&
                                            sIndexTemp.contains(sc
                                                .searchContrNO.value
                                                .substring(4, 10))
                                        ? Border.all(
                                            color: Colors.red, width: 6)
                                        : sIndexTemp.contains('Empty')
                                            ? Border.all(
                                                color: Colors.amber, width: 3)
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
                            child: InkWell(
                              onDoubleTap: () {
                                if (sIndexTemp.length < 4) {
                                  return;
                                } else if (sIndexTemp
                                    .toString()
                                    .endsWith('L')) {
                                  Get.defaultDialog(
                                      title: '알림',
                                      content: const Text('반출지시된 컨테이너가 아닙니다.'));
                                } else if (stateOrder == 'L') {
                                  firstClickIndex = i;

                                  add_Contr_Load(
                                    sCorp_CD,
                                    sUser_ID,
                                    '0000',
                                    sIndexTemp.split('\n')[3],
                                    (sIndexTemp.split('\n')[0].substring(0, 4) +
                                        sIndexTemp.split('\n')[1]),
                                    shareWC,
                                    _selectedBlock,
                                    int.parse(_selectedBay),
                                    ((firstClickIndex ~/ 6) + 1),
                                    (6 - (firstClickIndex % 6)),
                                    '0',
                                    '',
                                  );
                                  firstClickIndex = 0;
                                  _refresh();
                                }
                              },
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    backgroundColor: setContrColor(
                                        sIndexTemp,
                                        'X',
                                        'Y',
                                        'Z',
                                        'M',
                                        'W',
                                        "L",
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.white)),
                                onPressed: () {
                                  // 상차
                                  // Get.log(sIndexTemp.split('\n')[3]);
                                  if (stateOrder == 'L') {
                                    if (sIndexTemp.length < 4 ||
                                        sIndexTemp.isEmpty) {
                                      return;
                                    } else {
                                      // 초기화
                                      setState(() {
                                        if (sIndexTemp.contains('\nM')) {
                                          reContrList.replaceRange(i, i + 1, [
                                            sIndexTemp
                                                .toString()
                                                .replaceAll('\nM', '')
                                          ]);
                                          selectFlag = false;
                                        } else {
                                          if (firstClick.isNotEmpty &&
                                              selectFlag) {
                                            reContrList.replaceRange(
                                                firstClickIndex,
                                                firstClickIndex + 1,
                                                [firstClick.toString()]);
                                          }
                                          firstClick =
                                              sIndexTemp; // 첫번째 객체 변수 지정
                                          firstClickIndex = i;
                                          reContrList.replaceRange(i, i + 1,
                                              [sIndexTemp.toString() + '\nM']);
                                          selectFlag = true;
                                        }
                                      });
                                    }
                                    // 하차
                                  } else if (stateOrder == 'U') {
                                    if (sIndexTemp.length > 4 ||
                                        sContrNO_U.isEmpty) {
                                      if (sIndexTemp.contains('\nM')) {
                                        setState(() {
                                          selectFlag = false;
                                          reContrList
                                              .replaceRange(i, i + 1, [' ']);
                                        });
                                      }
                                      return;
                                    } else {
                                      if (firstClick.isNotEmpty) {
                                        setState(() {
                                          reContrList.replaceRange(
                                              firstClickIndex,
                                              firstClickIndex + 1,
                                              [firstClick]);
                                        });
                                        selectFlag = true;
                                      }
                                      firstClick = sIndexTemp;
                                      firstClickIndex = i;
                                      setState(() {
                                        selectFlag = true;

                                        reContrList.replaceRange(i, i + 1, [
                                          sContrNO_U.toString() + '\n' + '\nM'
                                        ]);
                                      });
                                    }
                                  }
                                },
                                child: AutoSizeText(
                                  (sIndexTemp.length > 4)
                                      ? sIndexTemp.toString().split('\n')[0] +
                                          '\n' +
                                          sIndexTemp.toString().split('\n')[1] +
                                          '\n' +
                                          sIndexTemp.toString().split('\n')[2]
                                      : ' ',
                                  maxLines: 3,
                                  style: const TextStyle(
                                    letterSpacing: 0.1,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.513,
                child: GridView.count(
                  controller: _scrollControllerTwo,
                  scrollDirection: Axis.horizontal,
                  childAspectRatio: 0.281,
                  crossAxisCount: 1,
                  children: List.generate(rowBayCount, (i) {
                    return Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: const Color(0xFF6D6D6D),
                          border: Border.all(color: Colors.white)),
                      child: AutoSizeText(
                        (i + 1).toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
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
        resizeToAvoidBottomInset: true,
        drawer: navigationDrawerWidget(drawerCallback),
        body: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Center(
                child: SizedBox(
                  height: screenHeight,
                  width: Get.width,
                  child: Column(
                    children: <Widget>[
                      customAppbar,
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: screenWidth,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                txtSearchList,
                                grdLoadOrderList,
                              ],
                            ),
                            SizedBox(
                              width: screenWidth * 0.005,
                            ),
                            grdLoadOrderTable
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.039),
                      Container(
                        height: screenHeight * 0.1,
                        width: Get.width,
                        color: const Color(0xFFDCDCDC),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            btnResearch,
                            btnSave,
                            txtSearch,
                            txtHelper,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  List<LoadResponseModel> _buildSearchList() {
    if (_searchText.isEmpty) {
      return searchLoadOrder = getLoadOrder;
    } else {
      searchLoadOrder = getLoadOrder.where((element) {
        return element.sContrNO
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            element.sORD_EMP
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            element.sVES_CD.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
      return searchLoadOrder;
    }
  }

  List<UnLoadResponseModel> _buildUnSearchList() {
    if (_searchText.isEmpty) {
      return searchUnLoadOrder = getUnLoadOrder;
    } else {
      searchUnLoadOrder = getUnLoadOrder.where((element) {
        return element.sContrNO
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            element.sWRK_PLN_DT
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            element.sORD_EMP
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            element.sVES_CD.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
      return searchUnLoadOrder;
    }
  }

  late Timer _timer;

  Future<void> clearSelectGrid() async {
    firstClick = '';
    selectFlag = false;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (firstClick.isEmpty && selectFlag == false) {
        _refresh();
      }
    });
    _loadCounter();
    _selectedBay = '1';
    _paramModel_L = LoadResponseModel(
        sCONTR_KEY: '',
        sContrNO: '',
        sCONTR_LOAD_STS: '',
        sOT_PLN_DT: '',
        sWC_CD: '',
        sBlock: '',
        sBlock_NM: '',
        iBay: 0,
        iRow: 0,
        iTier: 0,
        sVehicle: '',
        sVES_CD: '',
        sWRK_PLN_DT: '',
        sARR_CD: '',
        sLINER_CD: '',
        sWRK_DT: '',
        sORD_EMP: '');
    _paramModel_U = UnLoadResponseModel(
        sCONTR_KEY: '',
        sContrNO: '',
        sCONTR_LOAD_STS: '',
        sIN_PLN_DT: '',
        sOT_PLN_DT: '',
        sWC_CD: '',
        sVehicle: '',
        sVES_CD: '',
        sORD_EMP: '',
        sARR_CD: '',
        sWRK_PLN_DT: '',
        sWRK_DT: '',
        sLINER_CD: '',
        sVes_Block: 0,
        sVes_Bay: 0);

    _scrollControllerOne = ScrollController();
    _scrollControllerTwo = ScrollController();
    _scrollControllerOne.addListener(() {
      _scrollControllerTwo.animateTo(_scrollControllerOne.offset,
          duration: const Duration(microseconds: 10), curve: Curves.linear);
    });
    _buildSearchList();
    _buildUnSearchList();
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.dispose();
    _scrollControllerOne.dispose();
    _scrollControllerTwo.dispose();
    _timer.cancel();
  }

  // # 새로고침 관련 함수
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    stateOrder == 'L' ? get_LoadOrder() : get_UnLoadOrder();

    if (_selectedBlock == null || _selectedBay == null) {
      Get.defaultDialog(
          title: '알림', content: const Text('데이터 수신 상태를 확인해 주세요.'));
    } else {
      get_BlockBayContrMove(sCorp_CD, shareWC, _selectedBlock, _selectedBay);
    }
    clearSelectGrid();
    return;
  }

  // 그리드 컨트롤러 컨트롤 함수
  Future<void> moveScroll(int iRow, int rowlegth) async {
    if (iRow < 5) {
      _scrollControllerOne.animateTo(
          _scrollControllerOne.position.minScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease);
      _scrollControllerTwo.animateTo(
          _scrollControllerTwo.position.minScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease);
    } else {
      _scrollControllerOne.animateTo(
          _scrollControllerOne.position.maxScrollExtent * iRow / rowlegth * 6,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease);
      _scrollControllerTwo.animateTo(
          _scrollControllerTwo.position.maxScrollExtent * iRow / rowlegth * 6,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease);
    }
  }

  @override
  bool wantKeepAlive = true;
}

class ContainerDataSource extends DataGridSource {
  ContainerDataSource({required List<LoadResponseModel> dataSource}) {
    _dataSource = dataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(
                  columnName: '구분',
                  value:
                      '${(dataSource.length - dataSource.indexOf(e)).toString()}\n${e.sARR_CD})'),
              DataGridCell<String>(
                  columnName: '컨테이너',
                  value:
                      '${e.sContrNO}\n${e.sBlock_NM + e.iBay.toString()}-${e.iRow.toString()}-${e.iTier.toString()}'),
              DataGridCell<String>(columnName: '적입일', value: e.sWRK_DT),
              DataGridCell<String>(
                  columnName: '반출예정일', value: e.sOT_PLN_DT.substring(5)),
              DataGridCell<String>(columnName: '오더', value: e.sORD_EMP),
              DataGridCell<String>(columnName: '반출지', value: e.sARR_CD),
              DataGridCell<String>(columnName: '추가정보', value: e.sVES_CD),
            ]))
        .toList();
  }

  List<DataGridRow> _dataSource = [];

  @override
  List<DataGridRow> get rows => _dataSource;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.value.toString().contains('ORANGE')) {
            return Container(
              margin: const EdgeInsets.all(2),
              alignment: Alignment.center,
              color: Colors.orange,
              child: AutoSizeText(
                dataGridCell.value.toString().split('/')[0],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'NotoSansKR'),
              ),
            );
          } else if (dataGridCell.value.toString().contains('GREEN')) {
            return Container(
              margin: const EdgeInsets.all(2),
              alignment: Alignment.center,
              color: const Color(0xFF3db370),
              child: AutoSizeText(
                dataGridCell.value.toString().split('/')[0],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'NotoSansKR'),
              ),
            );
          } else if (dataGridCell.value.toString().contains('RED')) {
            return Container(
              margin: const EdgeInsets.all(2),
              alignment: Alignment.center,
              color: Colors.red,
              child: AutoSizeText(
                dataGridCell.value.toString().split('/')[0],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'NotoSansKR'),
              ),
            );
          } else if (dataGridCell.value.toString().contains('VIOLET')) {
            return Container(
              margin: const EdgeInsets.all(3),
              alignment: Alignment.center,
              color: const Color(0xFF4a14a0),
              child: AutoSizeText(
                dataGridCell.value.toString().split('/')[0],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'NotoSansKR'),
              ),
            );
          } else if (dataGridCell.value.toString().contains('BLUE')) {
            return Container(
              margin: const EdgeInsets.all(3),
              alignment: Alignment.center,
              color: const Color(0xFF004086),
              child: AutoSizeText(
                dataGridCell.value.toString().split('/')[0],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'NotoSansKR'),
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: AutoSizeText(
                dataGridCell.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'NotoSansKR'),
              ),
            );
          }
        }).toList());
  }
}

class UnContainerDataSource extends DataGridSource {
  UnContainerDataSource({required List<UnLoadResponseModel> dataSource}) {
    _dataSource = dataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(
                  columnName: '구분',
                  value:
                      (dataSource.length - dataSource.indexOf(e)).toString() +
                          '\n' +
                          (e.sORD_EMP.contains('-') ? '하차' : '대기')),
              DataGridCell<String>(
                  columnName: '컨테이너',
                  value: e.sContrNO +
                      '\n' +
                      (e.sCONTR_LOAD_STS == 'E' ? 'Empty' : 'Full')),
              DataGridCell<String>(columnName: '적입일', value: e.sWRK_PLN_DT),
              DataGridCell<String>(
                  columnName: '반출예정일', value: e.sIN_PLN_DT.substring(5)),
              DataGridCell<String>(columnName: '오더', value: e.sORD_EMP),
              DataGridCell<String>(columnName: '반출지', value: e.sARR_CD),
              DataGridCell<String>(columnName: '추가정보', value: e.sVES_CD),
            ]))
        .toList();
  }

  List<DataGridRow> _dataSource = [];

  @override
  List<DataGridRow> get rows => _dataSource;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      return Colors.white;
    }

    return DataGridRowAdapter(
        color: getRowBackgroundColor(),
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.value.toString().contains('대기')) {
            return Container(
              margin: const EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.orange,
              ),
              child: AutoSizeText(
                dataGridCell.value.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else if (dataGridCell.value.toString().contains('하차')) {
            return Container(
              margin: const EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFC866A4),
              ),
              child: AutoSizeText(
                dataGridCell.value.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else {
            return Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: AutoSizeText(
                dataGridCell.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'NotoSansKR'),
              ),
            );
          }
        }).toList());
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // # Api 관련 변수
  List<SearchContrResponseModel> getSearchList = [];
  late String tempArg = '';

  // # 캐시 호출(작업장)
  String sCorp_CD = '';
  String shareWC = '';

  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD = prefs.getString('CorpCD')!;
    shareWC = prefs.getString('WC') ?? '';
  }

  // # API 호출(파트너 리스트)
  Future<List<SearchContrResponseModel>> get_SearchContr(
      String sCorpCD, String sWC_CD,
      {required String sContr_NO}) async {
    APIGetSearchContr apiGetSearchContr = APIGetSearchContr();
    List<String> sParam = [sCorpCD, sWC_CD, sContr_NO];
    await apiGetSearchContr
        .getSelect("USP_GET_CONTR_SEARCH", sParam)
        .then((value) {
      getSearchList = value.contr;
    });
    return getSearchList;
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
        future: get_SearchContr(sCorp_CD, shareWC, sContr_NO: query),
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
                    tempArg =
                        '${data?[index].sContr_NO.toString()}/${data?[index].sBlock_CD.toString()}/${data?[index].sBlock_NM.toString()}/${data?[index].sBay_ID.toString()}/${data?[index].sRow_ID.toString()}/${data?[index].sTier_ID.toString()}';
                    close(context, tempArg);
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
