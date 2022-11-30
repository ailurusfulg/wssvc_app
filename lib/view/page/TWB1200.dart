// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_declarations, curly_braces_in_flow_control_structures, avoid_types_as_parameter_names, use_key_in_widget_constructors
import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../api/api.dart';
import '../../common/common_widget.dart';
import '../../model/models.dart';

class TWB1200 extends StatefulWidget {
  @override
  _TWB1200 createState() => _TWB1200();
}

class _TWB1200 extends State<TWB1200> with AutomaticKeepAliveClientMixin {
  // # 리스트 새로고침 관련 변수
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  // # 캐시 저장 관련 변수
  late String sCorp_CD = '';
  late String shareWC = '';
  late String sUser_ID = '';

  // # 검색창 관련 변수
  final key = GlobalKey<ScaffoldState>();
  final _searchQuery = TextEditingController();
  List<WRKHistoryResponseModel> searchContrInfo = [];
  bool _IsSearching = false;
  String _searchText = '';

  // # 레이아웃 관련 변수
  final double _grdFontSize = 20;
  final String _fontFamily = 'NotoSansKR';

  // # API 관련 변수
  List<WRKHistoryResponseModel> getWorksSum = [];
  List<CnlContrWRKResponseModel> result = [];

  List<bool> bValue = [];

// # API 호출(GetWorkHistory)
  void get_WorkHistory(String sCorp_CD, String sWorkCenter,
      String sContainerCode, String sNow) async {
    APIGetWorksSum apiGetWorksSum = APIGetWorksSum();
    List<String> sParam = [sCorp_CD, sWorkCenter, sContainerCode, sNow];
    await apiGetWorksSum.getSelect("USP_GET_WORKS_SUM", sParam).then((value) {
      setState(() {
        if (value.workHistory.isNotEmpty) {
          getWorksSum = value.workHistory;
        } else {
          getWorksSum = [];
        }
      });
    });
  }

// # API 호출(CnlContrWRK)
  void cnl_ContrWRK(
      String sCorp_CD,
      String _sMachDRVID,
      String sContr_NO,
      String sWRK_Type,
      String sContr_Key,
      String sOutCode,
      String sOutMsg) async {
    APICnlContrWRK apiCnlContrWRK = APICnlContrWRK();
    List<String> sParam = [
      sCorp_CD,
      _sMachDRVID,
      sContr_NO,
      sWRK_Type,
      sContr_Key,
      '',
      ''
    ];
    await apiCnlContrWRK.getUpdate("USP_CNL_CONTR_WRK", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          result = value.result;
          if (result.elementAt(0).rsCode == "E") {
            ScaffoldMessenger.of(context)
                .showSnackBar(basicSnackBar(result.elementAt(0).rsMsg));
          } else if (result.elementAt(0).rsCode == "S") {
            ScaffoldMessenger.of(context)
                .showSnackBar(basicSnackBar("작업 내역이 취소되었습니다."));
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(basicSnackBar(result.elementAt(0).rsMsg));
          }
        } else {}
      });
    });
  }

// # 검색 기능
  _TWB1200() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });
  }

  List<WRKHistoryResponseModel> _buildSearchList() {
    if (_searchText.isEmpty) {
      return searchContrInfo = getWorksSum;
    } else {
      searchContrInfo = getWorksSum
          .where((element) => element.sContr_NO
              .toLowerCase()
              .contains(_searchText.toLowerCase()))
          .toList();
      return searchContrInfo;
    }
  }

// # 캐시 호출(장비, 기사)
  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sCorp_CD = prefs.getString('CorpCD')!;
      shareWC = prefs.getString('WC')!;
      sUser_ID = prefs.getString('UserID') ?? '';
      get_WorkHistory(sCorp_CD, shareWC, "", DateTime.now().toString());
    });
  }

// # 위젯이 생성될때 처음으로 호출되는 메서드\
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadCounter();
    _IsSearching = false;
    // get_WorkHistory("", DateTime.now().toString());
    _buildSearchList();
    super.initState();
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

// # 새로고침 관련 함수
  Future<void> _refresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      get_WorkHistory(sCorp_CD, shareWC, "", DateTime.now().toString());
    });
    return;
  }

// # 위젯
  @override
  Widget build(BuildContext context) {
    final _height = Get.height;
    final _width = Get.width;
    final screenHeight = _height * 0.95;
    final screenWidth = _width * 0.95;
    // # 위젯 - 커스텀 앱바
    final customAppbar = AppBar(
      backgroundColor: const Color(0xff072a70),

      title: Center(
        child: AutoSizeText('작업이력 취소',
            style: TextStyle(
                fontFamily: _fontFamily, fontSize: 25, color: Colors.white)),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Get.back();
        },
      ),
    );

    // # 위젯 - 검색창 텍스트필드
    final txtSearch = Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.78,
      alignment: Alignment.center,
      child: Theme(
        data: Theme.of(context).copyWith(
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Color(0xff12214B))),
        child: AutoSizeTextField(
            autofocus: false,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            controller: _searchQuery,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBF3FB),
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: _searchQuery.clear,
                icon: Icon(Icons.clear),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Color(0xFFEBF3FB),
                  )),
            )),
      ),
    );

    // # 위젯 - 갱신버튼
    final btnResearch = InkWell(
        onTap: () {
          setState(() {
            _searchQuery.clear();
            _refresh();
          });
        },
        child: Container(
          height: screenHeight * 0.1,
          width: screenWidth * 0.2,
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Color(0xFF412198)),
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(left: screenWidth * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.repeat,
                size: 30,
                color: Color(0xFF412198),
              ),
              AutoSizeText(' 재수신',
                  maxLines: 1,
                  style: TextStyle(
                      color: Color(0xFF412198),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: _fontFamily)),
            ],
          ),
        ));

    // # 위젯 - 컨테이너 리스트
    final grdWorkSumList = Container(
      height: screenHeight * 0.75,
      width: screenWidth,
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: RefreshIndicator(
        key: refreshKey,
        backgroundColor: Color(0xff12214B),
        color: Colors.white,
        displacement: 200,
        strokeWidth: 5,
        onRefresh: _refresh,
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
              headerColor: Color(0xFF545454), gridLineColor: Colors.grey),
          child: SfDataGrid(
            swipeMaxOffset: 200.0,
            headerRowHeight: screenHeight * 0.1,
            allowSwiping: true,
            headerGridLinesVisibility: GridLinesVisibility.both,
            gridLinesVisibility: GridLinesVisibility.both,
            selectionMode: SelectionMode.single,
            navigationMode: GridNavigationMode.cell,
            source: HstDataSource(dataSource: _buildSearchList()),
            endSwipeActionsBuilder:
                (BuildContext context, DataGridRow row, int rowIndex) {
              return GestureDetector(
                onTap: () {
                  String tempEMP_NM = getWorksSum
                      .where((element) => element.sContr_NO
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()))
                      .toList()
                      .elementAt(rowIndex)
                      .sORD_EMP;
                  String tempContr_WRK_NO = getWorksSum
                      .where((element) => element.sContr_NO
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()))
                      .toList()
                      .elementAt(rowIndex)
                      .sContr_WRK_NO;
                  String tempContr_WRK_Type = getWorksSum
                      .where((element) => element.sContr_NO
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()))
                      .toList()
                      .elementAt(rowIndex)
                      .sContr_WRK_Type;
                  String tempCONTR_KEY = getWorksSum
                      .where((element) => element.sContr_NO
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()))
                      .toList()
                      .elementAt(rowIndex)
                      .sCONTR_KEY;
                  cnl_ContrWRK(sCorp_CD, sUser_ID, tempContr_WRK_NO,
                      tempContr_WRK_Type, tempCONTR_KEY, '', '');
                  get_WorkHistory(
                      sCorp_CD, shareWC, "", DateTime.now().toString());
                },
                child: Container(
                    color: Colors.red,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restart_alt_rounded,
                            color: Colors.white,
                          ),
                          AutoSizeText(
                            ' 상하차 취소',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              );
            },
            columns: <GridColumn>[
              GridColumn(
                  width: screenHeight * 0.15,
                  columnName: '구분',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '구  분',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: screenHeight * 0.2,
                  columnName: '일자',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '일   자',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: screenHeight * 0.2,
                  columnName: '시간',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '시   간',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: screenHeight * 0.25,
                  columnName: '컨테이너번호',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '컨테이너번호',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '화주',
                  width: screenHeight * 0.2,
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '화  주',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  width: screenHeight * 0,
                  columnName: '차량번호',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '차  번',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '담당',
                  width: screenHeight * 0.2,
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '담  당',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '구역',
                  width: screenHeight * 0.2,
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '구역',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '베이',
                  width: screenHeight * 0.1,
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '베이',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '행',
                  width: screenHeight * 0.1,
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '행',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
              GridColumn(
                  columnName: '단',
                  width: screenHeight * 0.1,
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '단',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _grdFontSize,
                            fontFamily: _fontFamily),
                      ))),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppbar,
        body: SafeArea(
          child: Center(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [txtSearch, btnResearch],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  grdWorkSumList,
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            ),
          ),
        ));
  }

  Future show(sMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(sMessage);
        }); // 비밀번호 불일치
  }

  Widget alert(String sContent) {
    return AlertDialog(
      // title: Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(sContent),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('확인'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}

class HstDataSource extends DataGridSource {
  HstDataSource({required List<WRKHistoryResponseModel> dataSource}) {
    _dataSource = dataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              // DataGridCell<String>(columnName: 'id', value: e.sCONTR_KEY),
              DataGridCell<String>(columnName: '구분', value: e.sContr_WRK_Type),
              DataGridCell<String>(columnName: '일자', value: e.sContr_WRK_DT),
              DataGridCell<String>(columnName: '시간', value: e.sContr_WRK_TM),
              DataGridCell<String>(columnName: '컨테이너번호', value: e.sContr_NO),
              DataGridCell<String>(columnName: '화주', value: e.sBP_SHORT_NM),
              DataGridCell<String>(columnName: '차량번호', value: e.sVehicle_NO),
              DataGridCell<String>(columnName: '담당', value: e.sORD_EMP),
              DataGridCell<String>(columnName: '구역', value: e.sBlock_CD),
              DataGridCell<int>(columnName: '베이', value: e.iBay_ID),
              DataGridCell<int>(columnName: '행', value: e.iRow_ID),
              DataGridCell<int>(columnName: '단', value: e.iTier_ID),
            ]))
        .toList();
  }

  List<DataGridRow> _dataSource = [];

  @override
  List<DataGridRow> get rows => _dataSource;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          dataGridCell.value.toString(),
          style: TextStyle(
              color: Colors.black87, fontSize: 15, fontFamily: 'NotoSansKR'),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList());
  }
}
