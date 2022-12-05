import 'package:auto_size_text/auto_size_text.dart';
import 'package:easycontainer_dwl/api/api.dart';
import 'package:easycontainer_dwl/model/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TSB1201 extends StatefulWidget {
  const TSB1201({Key? key}) : super(key: key);

  @override
  _TSB1201 createState() => _TSB1201();
}

final int _rowsPerPage = 15;
final double _dataPagerHeight = Get.height * 0.1;

List<ContrTestResponsemodel> getContrTestList = <ContrTestResponsemodel>[];
late OrderInfoDataSource _orderInfoDataSource;

final GlobalKey<ScaffoldState> _scaffoldKey4 = GlobalKey<ScaffoldState>();

class OrderInfoDataSource extends DataGridSource {
  OrderInfoDataSource({required List<ContrTestResponsemodel> dataSource}) {
    _dataSource  = dataSource;
    _paginatedRows  = dataSource;
    buildDataGridRow();
  }

  void buildDataGridRow() {
    dataGridRows = _paginatedRows
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'No', value: (_paginatedRows.indexOf(e)+1).toString()),
      DataGridCell<String>(columnName: 'Owner', value: e.sBP_NM),
      DataGridCell<String>(columnName: 'Tank No.', value: e.sCONTR_NO),
      DataGridCell<String>(columnName: 'SCHEDULED', value: e.sOT_PLN_DT),
      DataGridCell<String>(columnName: 'CC', value: e.sCC_DT),
      DataGridCell<String>(columnName: 'CUSTOMER', value: e.sCUSTOMER),
      DataGridCell<String>(columnName: 'REMARK', value: e.sREMK),
    ])).toList();
  }

  List<ContrTestResponsemodel> _paginatedRows = [];
  List<ContrTestResponsemodel> _dataSource = [];
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows ;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          if (e.columnName == 'No') {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                e.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (e.columnName == 'Owner') {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  e.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
          } else if (e.columnName == 'Tank NO') {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  e.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
          } else if (e.columnName == 'SCHDULED') {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  e.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
          } else if (e.columnName == 'CC') {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  e.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
          } else if (e.columnName == 'CUSTOMER') {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  e.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
          } else {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  e.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
          }
        }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (startIndex < _dataSource.length && endIndex <= _dataSource.length) {
      _paginatedRows =
          _dataSource.getRange(startIndex, endIndex).toList(growable: false);
    } else {
      _paginatedRows = <ContrTestResponsemodel>[];
    }
    buildDataGridRow();
    notifyListeners();
    return Future<bool>.value(true);
  }
  void updateDataGriDataSource() {
    notifyListeners();
  }
}

class _TSB1201 extends State<TSB1201> {

  Future<void> get_ContrTestList() async {
    APIGetContrTestList apiGetContrTestList = APIGetContrTestList();
    List<String> sParam = ['WSTANK'];
    apiGetContrTestList.getSelect("USP_WCY0300", sParam).then((value) {
      setState(() {
        getContrTestList = value.contrtest.isNotEmpty ? value.contrtest : [];
        Get.log(getContrTestList.elementAt(0).sREMK);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getContrTestList.clear();
      get_ContrTestList();
      _orderInfoDataSource = OrderInfoDataSource(dataSource: getContrTestList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      key: _scaffoldKey4,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '검사작업',
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
            onPressed: () => _scaffoldKey4.currentState?.openDrawer(),
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
                  child: ListTile(
                    title: const Text(
                      '수리작업',
                      style: TextStyle(
                        height: 1.5,
                        color: Colors.white,
                        fontSize: 18.6,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Get.offNamed('/selectWrk');
                    },
                  ),
                ),
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
                      '검사작업',
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
                      Get.offNamed('/signin');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint) {
        return Column(children: [
          SizedBox(
              height: (screenHeight - _dataPagerHeight) * 0.8,
              width: screenWidth,
              child: _buildDataGrid(constraint),
          ),
          Container(
              height: _dataPagerHeight,
              child: SfDataPager(
                delegate: _orderInfoDataSource,
                // pageCount: (getContrTestList.length / _rowsPerPage) < 0 ? 1 : (getContrTestList.length / _rowsPerPage),
                pageCount: 3,
                direction: Axis.horizontal,
              ))
        ]);
  },
      ));
  }

  @override
  Widget _buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
        source: _orderInfoDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
              columnName: 'No',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'No',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'Tank No',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Tank No',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'SCHEDULED',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'SCHEDULED',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'CC',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'CC',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'CUSTOMER',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'CUSTOMER',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'REMARK',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'REMARK',
                    overflow: TextOverflow.ellipsis,
                  ))),
        ]);

  }
}