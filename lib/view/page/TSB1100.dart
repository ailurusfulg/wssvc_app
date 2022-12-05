// ignore_for_file: non_constant_identifier_names, must_call_super, prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api/api.dart';
import '../../model/models.dart';

class TSB1100 extends StatefulWidget {
  const TSB1100({Key? key}) : super(key: key);

  @override
  _TSB1100 createState() => _TSB1100();
}

final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

class OwnerDataSource extends DataGridSource {
  OwnerDataSource({required List<CountContrResponsemodel> ownerData}) {
    _ownerData = ownerData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'index', value: (ownerData.indexOf(e)+1).toString()),
              DataGridCell<String>(columnName: 'owner', value: e.sBP_NM),
              DataGridCell<String>(columnName: 'tank no', value: e.sCNT_CNTR.toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _ownerData = [];

  @override
  List<DataGridRow> get rows => _ownerData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class TankDataSource extends DataGridSource {
  TankDataSource({required List<CountContrInfoResponsemodel> tankData}) {
    _tankData = tankData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'tank no', value: e.sCONTR_NO),
              DataGridCell<String>(columnName: 'scheduled', value: e.sOT_PLN_DT.toString()),
              DataGridCell<String>(columnName: 'cc', value: e.sCC_PLN_DT.toString()),
              DataGridCell<String>(columnName: 'cheak', value: e.sCC_DT.toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _tankData = [];

  @override
  List<DataGridRow> get rows => _tankData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class _TSB1100 extends State<TSB1100> {
  static const storage = FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업
  // List<Owner> owners = <Owner>[];
  // late OwnerDataSource ownerDataSource;
  // List<Tank> tanks = <Tank>[];
  // late TankDataSource tankDataSource;
  final TextEditingController _DataTimeEditingController = TextEditingController();
  final TextEditingController _EstimatedEditingController = TextEditingController();
  List<CountContrResponsemodel> cnt_Contr= [];
  List<CountContrInfoResponsemodel> cnt_ContrInfo= [];
  DateTime? tempPickedDate;


  String sPickDate = '';

  // # API 호출(GetWorkHistory)
  void get_CountContr(String sDate) async {
    APIGetCountContr apiGetCountContr = APIGetCountContr();
    List<String> sParam = ['WSTANK',sDate];
    await apiGetCountContr
        .getSelect("USP_WCY0100", sParam)
        .then((value) {
      cnt_Contr.clear();
      setState(() {
          cnt_Contr = value.countcontr.isNotEmpty ? value.countcontr : [];
          // Get.log(cnt_Contr.elementAt(0).sIN_PLN_DT);
          // Get.log(_DataTimeEditingController.text);
          // Get.log(DateFormat('yyyy-MM-dd').format(DateTime.now()));
          // Get.log(cnt_Contr.elementAt(0).sBP_NM);
          // Get.log(cnt_Contr.elementAt(0).sCNT_CNTR.toString());
      });
    });
  }

  void get_CountContrInfo(String sDate, String sBpCd) async {
    APIGetCountContrInfo apiGetCountContrInfo = APIGetCountContrInfo();
    List<String> sParam = ['WSTANK',sDate, sBpCd];
    await apiGetCountContrInfo.getSelect("USP_WCY0101", sParam).then((value) {
      cnt_ContrInfo.clear();
      setState(() {
        cnt_ContrInfo = value.countcontrinfo.isNotEmpty ? value.countcontrinfo : [];
      });
    });
  }


  @override
  void initState() {
    super.initState();
    // owners = getOwnerData();
    // ownerDataSource = OwnerDataSource(ownerData: owners);
    // tanks = getTankData();
    setState(() {
      sPickDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      get_CountContr(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });
    // tankDataSource = TankDataSource(tankData: tanks);
   }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;
    return Scaffold(
        key: _scaffoldKey1,
        // backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.1),
          child: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              '수리작업',
              style: TextStyle(
                height: 3,
                // letterSpacing: 7,
                color: Color.fromRGBO(75, 75, 75, 1),
                fontSize: 24.6,
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
            // 중앙 정렬
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.segment,
                  color: Color.fromRGBO(88, 105, 214, 1), size: 55),
              onPressed: () => _scaffoldKey1.currentState?.openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: const Color.fromRGBO(122, 136, 230, 1),
            child: ListView(
              padding: const EdgeInsets.only(top: 5), //여백 지정
              children: <Widget>[
                ListTile(
                  trailing:
                      const Icon(Icons.close, size: 50, color: Colors.white),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 5, bottom: 5),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      title: const Text(
                        '수리작업',
                        style: TextStyle(
                          height: 1.5,
                          color: Color.fromRGBO(88, 105, 214, 1),
                          fontSize: 18.6,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 5, bottom: 5),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListTile(
                      title: const Text(
                        '검사작업',
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 18.6,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Get.offNamed('/test4');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 5, bottom: 5),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListTile(
                      title: const Text(
                        '컨테이너 위치',
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 18.6,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Get.offNamed('/test3');
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.55),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 5, bottom: 5),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListTile(
                      title: RichText(
                        text: const TextSpan(
                            children: [
                        WidgetSpan(
                        child: Icon(Icons.logout, color: Colors.white),
                      ),
                      TextSpan(
                        text: ' 로그아웃',
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 18.6,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]),
                      ),
                      onTap: () {
                        storage.delete(key: "login");
                        Get.offNamed('/signin');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 241, 241, 1),
                      ),
                      height: screenHeight * 0.03,
                    ),
                    Container(
                      //선
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 241, 241, 1),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth * 0.04),
                          Container(
                            // padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromRGBO(207, 207, 207, 1),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 7),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                        color: Color.fromRGBO(251, 251, 251, 1),
                                      ),
                                      // color: Colors.blue,
                                      height: screenHeight * 0.08,
                                      width: screenWidth * 0.32,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: screenHeight * 0.08,
                                            width: screenWidth * 0.12,
                                            child: const AutoSizeText(
                                              'Date',
                                              style: TextStyle(
                                                height: 1.7,
                                                color: Color.fromRGBO(
                                                    75, 75, 75, 1),
                                                fontSize: 22.6,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(width: screenWidth * 0.02),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    get_CountContr(DateFormat('yyyy-MM-dd').format(DateTime.now()));
                                                  });
                                                  HapticFeedback.mediumImpact();
                                                  _selectDataCalendar_Expecteddate_visit(
                                                      context);
                                                },
                                                child: AbsorbPointer(
                                                  child: SizedBox(
                                                    height: screenHeight * 0.06,
                                                    width: screenWidth * 0.16,
                                                    child: TextField(
                                                      controller:
                                                          _DataTimeEditingController,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          height: 2.2),
                                                      decoration:
                                                      InputDecoration(
                                                        hintText: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        20.0),
                                                        border:
                                                            const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          207,
                                                                          207,
                                                                          207,
                                                                          1),
                                                                  width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          207,
                                                                          207,
                                                                          207,
                                                                          1),
                                                                  width: 2.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.01,
                                          color: const Color.fromRGBO(
                                              214, 214, 214, 1),
                                        ),
                                        color: Colors.white,
                                      ),
                                      width: screenWidth * 0.32,
                                      height: screenHeight * 0.72,
                                      child: SfDataGridTheme(
                                        data: SfDataGridThemeData(
                                          selectionColor: const Color.fromRGBO(226, 232, 255, 1),
                                          headerColor: Colors.blue,
                                          gridLineColor: const Color.fromRGBO(207, 207, 207, 1),
                                        ),
                                        child: SfDataGrid(
                                          frozenColumnsCount: 0,
                                          selectionMode: SelectionMode.single,
                                          // allowSorting: true,
                                          source: OwnerDataSource(ownerData: cnt_Contr),
                                          columnWidthMode: ColumnWidthMode.fill,
                                          gridLinesVisibility: GridLinesVisibility.both,
                                          onCellTap: (DataGridCellTapDetails details) async {
                                            // Get.log(details.rowColumnIndex.rowIndex.toString());
                                            // Get.log(cnt_Contr[details.rowColumnIndex.rowIndex-1].sBP_NM);
                                            // Get.log(cnt_Contr[details.rowColumnIndex.rowIndex-1].sBP_CD);
                                            get_CountContrInfo(sPickDate, cnt_Contr[details.rowColumnIndex.rowIndex-1].sBP_CD);
                                          },
                                          columns: <GridColumn>[
                                            GridColumn(
                                                width: screenWidth * 0.03,
                                                columnName: 'index',
                                                label: Container(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                        right: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      color: Color.fromRGBO(
                                                          251, 251, 251, 1),
                                                    ),
                                                    child: const Text(
                                                      'index',
                                                      style: TextStyle(
                                                        height: 1.5,
                                                        color: Color.fromRGBO(
                                                            75, 75, 75, 1),
                                                        fontSize: 24.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ))),
                                            GridColumn(
                                                width: screenWidth * 0.09,
                                                columnName: 'owner',
                                                label: Container(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                        right: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      color: Color.fromRGBO(
                                                          251, 251, 251, 1),
                                                    ),
                                                    child: const Text(
                                                      '오너',
                                                      style: TextStyle(
                                                        height: 1.5,
                                                        color: Color.fromRGBO(
                                                            75, 75, 75, 1),
                                                        fontSize: 24.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ))),
                                            GridColumn(
                                                width: screenWidth * 0.2,
                                                columnName: 'no',
                                                label: Container(
                                                    padding: const EdgeInsets.all(
                                                        16.0),
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(
                                                                width: 1.5,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        207,
                                                                        207,
                                                                        207,
                                                                        1),
                                                              ),
                                                            ),
                                                            color: Color.fromRGBO(
                                                                251,
                                                                251,
                                                                251,
                                                                1)),
                                                    child: const Text(
                                                      'Tank No.',
                                                      style: TextStyle(
                                                        height: 1.0,
                                                        color: Color.fromRGBO(
                                                            75, 75, 75, 1),
                                                        fontSize: 24.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromRGBO(207, 207, 207, 1),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                      color: Color.fromRGBO(226, 232, 255, 1),
                                    ),
                                    height: screenHeight * 0.8,
                                    width: screenWidth * 0.08,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 250),
                                          child: AutoSizeText(
                                            '상세내역',
                                            style: TextStyle(
                                              height: 1.5,
                                              color: Color.fromRGBO(61, 61, 61, 1),
                                              fontSize: 20.6,
                                              fontFamily: 'NotoSansKR',
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(2),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: const Color.fromRGBO(88, 105, 214, 1),
                                                  ),
                                                ),
                                                height: screenHeight * 0.028,
                                                width: screenWidth * 0.015,
                                                child:  const Icon(Icons.chevron_right,
                                                    size: 20, color: Color.fromRGBO(88, 105, 214, 1)),
                                              ),
                                               const SizedBox(width: 2),
                                               SizedBox(
                                                 width: 67,
                                                 child: AutoSizeText(
                                                   cnt_ContrInfo.isEmpty ? '' :
                                                   cnt_ContrInfo.elementAt(0).sBP_NM,
                                                   overflow: TextOverflow.ellipsis,
                                                   maxLines: 1,
                                                  style: const TextStyle(
                                                    height: 1.2,
                                                    color: Color.fromRGBO(88, 105, 214, 1),
                                                    fontSize: 14,
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                              ),
                                               ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            // border: Border.all(),
                                            color: Color.fromRGBO(
                                                251, 251, 251, 1),
                                          ),
                                          // color: Colors.blue,
                                          height: screenHeight * 0.08,
                                          width: screenWidth * 0.5,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: screenHeight * 0.08,
                                                width: screenWidth * 0.13,
                                                child: const AutoSizeText(
                                                  'Tank No.',
                                                  style: TextStyle(
                                                    height: 2.2,
                                                    color: Color.fromRGBO(
                                                        75, 75, 75, 1),
                                                    fontSize: 22.6,
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.29,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 7)),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: const Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10,
                                                              left: 10,
                                                              top: 5),
                                                      child: SizedBox(
                                                        width:
                                                            screenWidth * 0.29,
                                                        height:
                                                            screenHeight * 0.05,
                                                        child:
                                                            const AutoSizeText(
                                                          '',
                                                          style: TextStyle(
                                                            height: 1.5,
                                                            color: Colors.black,
                                                            fontSize: 16.6,
                                                            fontFamily:
                                                                'NotoSansKR',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            // border: Border.all(),
                                            color: Colors.white,
                                          ),
                                          width: screenWidth * 0.5,
                                          height: screenHeight * 0.72,
                                          child: SfDataGridTheme(
                                            data: SfDataGridThemeData(
                                              selectionColor: const Color.fromRGBO(226, 232, 255, 1),
                                              headerColor: const Color.fromRGBO(251, 251, 251, 1),
                                              gridLineColor: const Color.fromRGBO(207, 207, 207, 1),
                                            ),
                                            child: SfDataGrid(
                                              selectionMode:
                                                  SelectionMode.single,
                                              // allowSorting: true,
                                              source: TankDataSource(tankData: cnt_ContrInfo),
                                              columnWidthMode:
                                                  ColumnWidthMode.fill,
                                              gridLinesVisibility: GridLinesVisibility.both,
                                              onCellTap: (DataGridCellTapDetails details) async {
                                                Get.toNamed('/test2', arguments:{
                                                  'sCONTR_KEY': cnt_ContrInfo[details.rowColumnIndex.rowIndex-1].sCONTR_KEY,
                                                });
                                              },
                                              columns: <GridColumn>[
                                                GridColumn(
                                                    width: screenWidth * 0.18,
                                                    columnName: 'no',
                                                    label: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                              border: Border(
                                                            top: BorderSide(
                                                              width: 1.5,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      207,
                                                                      207,
                                                                      207,
                                                                      1),
                                                            ),
                                                            right: BorderSide(
                                                              width: 1.5,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      207,
                                                                      207,
                                                                      207,
                                                                      1),
                                                            ),
                                                          ),
                                                          color: Color.fromRGBO(
                                                              251, 251, 251, 1),
                                                        ),
                                                        child: const Text(
                                                          'Tank No.',
                                                          style: TextStyle(
                                                            height: 1.5,
                                                            color: Color.fromRGBO(
                                                                75, 75, 75, 1),
                                                            fontSize: 24.6,
                                                            fontFamily:
                                                                'NotoSansKR',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ))),
                                                GridColumn(
                                                    width: screenWidth * 0.16,
                                                    columnName: 'sch',
                                                    label: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              251, 251, 251, 1),
                                                          border: Border(
                                                            top: BorderSide(
                                                              width: 1.5,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      207,
                                                                      207,
                                                                      207,
                                                                      1),
                                                            ),
                                                            right: BorderSide(
                                                              width: 1.5,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      207,
                                                                      207,
                                                                      207,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Scheduled',
                                                          style: TextStyle(
                                                            height: 1.5,
                                                            color: Color.fromRGBO(
                                                                75, 75, 75, 1),
                                                            fontSize: 24.6,
                                                            fontFamily:
                                                                'NotoSansKR',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ))),
                                                GridColumn(
                                                    width: screenWidth * 0.08,
                                                    columnName: 'cc',
                                                    label: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                16.0),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              width: 1.5,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      207,
                                                                      207,
                                                                      207,
                                                                      1),
                                                            ),
                                                            right: BorderSide(
                                                              width: 1.5,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      207,
                                                                      207,
                                                                      207,
                                                                      1),
                                                            ),
                                                          ),
                                                          color: Color.fromRGBO(
                                                              251, 251, 251, 1),
                                                        ),
                                                        child: const Text(
                                                          'CC',
                                                          style: TextStyle(
                                                            height: 1.0,
                                                            color: Color.fromRGBO(
                                                                75, 75, 75, 1),
                                                            fontSize: 24.6,
                                                            fontFamily:
                                                                'NotoSansKR',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ))),
                                                GridColumn(
                                                    width: screenWidth * 0.08,
                                                    columnName: 'cheak',
                                                    label: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          '검사일',
                                                          style: TextStyle(
                                                            height: 1.5,
                                                            color: Color.fromRGBO(
                                                                75, 75, 75, 1),
                                                            fontSize: 24.6,
                                                            fontFamily:
                                                                'NotoSansKR',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        decoration:
                                                            const BoxDecoration(
                                                                border: Border(
                                                                  top: BorderSide(
                                                                    width: 1.5,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            207,
                                                                            207,
                                                                            207,
                                                                            1),
                                                                  ),
                                                                ),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        251,
                                                                        251,
                                                                        251,
                                                                        1)))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: screenHeight * 0.04,
                    //   width: screenWidth * 1,
                    //   color: Colors.black,
                    // )
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 241, 241, 1),
                      ),
                      height: screenHeight * 0.032,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _selectDataCalendar_Expecteddate_visit(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 550,
              child: SfDateRangePicker(
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  dayFormat: 'EEE',
                ),
                monthFormat: 'MMM',
                showNavigationArrow: true,
                headerStyle: const DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(fontSize: 25, color: Colors.blueAccent),
                ),
                headerHeight: 80,
                view: DateRangePickerView.month,
                allowViewNavigation: false,
                backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                initialSelectedDate: DateTime.now(),
                // minDate: DateTime.now(),
                minDate: tempPickedDate,
                maxDate: DateTime.now().add(const Duration(days: 365)),
                selectionMode: DateRangePickerSelectionMode.single,
                confirmText: '완료',
                cancelText: '취소',
                onSubmit: (args) => {
                  setState(() {
                    _EstimatedEditingController.clear();
                    //tempPickedDate = args as DateTime?;
                    _DataTimeEditingController.text = args.toString();
                    convertDateTimeDisplay(
                        _DataTimeEditingController.text, '방문');
                    sPickDate = _DataTimeEditingController.text;
                    get_CountContr(sPickDate);
                    Navigator.of(context).pop();
                  }),
                },
                onCancel: () => Navigator.of(context).pop(),
                showActionButtons: true,
              ),
            ),
          ));
        });
  }

  String convertDateTimeDisplay(String date, String text) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    if (text == '방문') {
      _EstimatedEditingController.clear();
      return _DataTimeEditingController.text =
          serverFormater.format(displayDate);
    } else {
      return _EstimatedEditingController.text =
          serverFormater.format(displayDate);
    }
  }
}
