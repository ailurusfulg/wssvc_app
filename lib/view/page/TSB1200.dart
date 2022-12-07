// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easycontainer_dwl/api/api.dart';
import 'package:easycontainer_dwl/model/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TSB1200 extends StatefulWidget {
  const TSB1200({Key? key}) : super(key: key);

  @override
  _TSB1200 createState() => _TSB1200();
}

final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();

class Controller extends GetxController {
  // List<CheakContrResponsemodel> itemList;
}

class _TSB1200 extends State<TSB1200> {
  Controller controller = Get.put(Controller());
  bool switchValue = false;
  String buttonState = '완료';
  List<SelContrInfoResponsemodel> getSelcntinfo = [];
  List<CheakContrResponsemodel> getCheakContr = [];
  List<AddCheakContrResponseModel> addCheakContr = [];
  String inKey = '${Get.arguments['sCONTR_KEY']}';
  String loading_Flg = 'L';
  String RemkText = '';
  String Test_NO = '';
  String ChageText = '';
  List<CheakContrResponsemodel> setCheakContr = [];

  Future<void> get_Selcntinfo(String sCNTKEY) async {
    APISelContrInfo apiSelContrInfo = APISelContrInfo();
    List<String> sParam = ['WSTANK', sCNTKEY];
    apiSelContrInfo.getSelect("USP_WCY0200", sParam).then((value) {
      getSelcntinfo.clear();
      setState(() {
        loading_Flg = 'C';
        getSelcntinfo = value.selectcontrinfo.isNotEmpty ? value.selectcontrinfo : [];
      });
    });
  }

  Future<void> get_CheakContr(String sCNTKEY) async {
    APIGetCheakContr apiGetCheakContr = APIGetCheakContr();
    List<String> sParam = ['WSTANK', sCNTKEY];
    apiGetCheakContr.getSelect("USP_WCY0201", sParam).then((value) {
      getCheakContr.clear();
      setState(() {
        getCheakContr = value.cheakcontr.isNotEmpty ? value.cheakcontr : [];
      });
    });
  }

  Future<void> add_CheakContr(String sCNTKEY, String sTestNO, String sREMK, String saveFlg ) async {
    APIAddCheakContr apiAddCheakContr = APIAddCheakContr();
    String sOutCode = '';
    String sOutMsg  = '';
      List<String> sParam = ['WSTANK', sCNTKEY.toString(), sTestNO, sREMK, saveFlg, '유저아이디' ,sOutCode, sOutMsg];
    await apiAddCheakContr.getUpdate("USP_WCY0200_I10", sParam).then((value) {
      setState(() {
        if(value.result.isNotEmpty) {
          addCheakContr = value.result;
          String Msg = addCheakContr.elementAt(0).rsMsg;
          if (addCheakContr.elementAt(0).rsCode != 'S') {
            Get.defaultDialog(title : '알림', content: Text(Msg));
          }
          get_CheakContr(inKey);
        } else {}
      });
    });
    }



  @override
  void initState() {
    super.initState();
    get_Selcntinfo(inKey);
    get_CheakContr(inKey);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      key: _scaffoldKey2,
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
            onPressed: () => _scaffoldKey2.currentState?.openDrawer(),
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
                      Get.offNamed('/signin');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(FocusNode());
            },
          child: loading_Flg == 'L'? const Center(child: CircularProgressIndicator(),)
              : Center(
              child: SizedBox(
                height: screenHeight,
                width: Get.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints(),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 241, 241, 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 20, left: 25, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          left: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Color.fromRGBO(251, 251, 251, 1),
                                      ),
                                      // color: Colors.blue,
                                      height: screenHeight * 0.1,
                                      width: screenWidth * 0.4,
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
                                                    102, 102, 102, 1),
                                                fontSize: 22.6,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.25,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 13)),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: const Color.fromRGBO(
                                                          207, 207, 207, 1),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.only(
                                                      right: 10,
                                                      left: 10,
                                                      top: 5),
                                                  child: SizedBox(
                                                    width: screenWidth * 0.29,
                                                    height: screenHeight * 0.05,
                                                    child: AutoSizeText(
                                                      getSelcntinfo.elementAt(0).sCONTR_NO.isEmpty ? '' :
                                                      getSelcntinfo.elementAt(0).sCONTR_NO,
                                                      style: const TextStyle(
                                                        height: 1.5,
                                                        color: Colors.black,
                                                        fontSize: 16.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign: TextAlign.center,
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
                                        border: Border(
                                          left: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                      width: screenWidth * 0.40,
                                      height: screenHeight * 0.5,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Color.fromRGBO(251, 251, 251, 1),
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.12,
                                      child: const AutoSizeText(
                                        '오너',
                                        style: TextStyle(
                                          height: 1.7,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 20.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.28,
                                      child: AutoSizeText(
                                        getSelcntinfo.elementAt(0).sBP_NM.isEmpty ? '' :
                                        getSelcntinfo.elementAt(0).sBP_NM,
                                        style: const TextStyle(
                                          height: 2.1,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 24.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Color.fromRGBO(251, 251, 251, 1),
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.12,
                                      child: const AutoSizeText(
                                        'Scheduled',
                                        style: TextStyle(
                                          height: 1.7,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 20.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.28,
                                      child: AutoSizeText(
                                        getSelcntinfo.elementAt(0).sOT_PLN_DT.isEmpty ? '' :
                                        getSelcntinfo.elementAt(0).sOT_PLN_DT,
                                        style: const TextStyle(
                                          height: 2.1,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 24.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Color.fromRGBO(251, 251, 251, 1),
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.12,
                                      child: const AutoSizeText(
                                        'CC',
                                        style: TextStyle(
                                          height: 1.7,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 20.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.28,
                                      child: AutoSizeText(
                                        getSelcntinfo.elementAt(0).sCC_PLN_DT.isEmpty ? '' :
                                        getSelcntinfo.elementAt(0).sCC_PLN_DT,
                                        style: const TextStyle(
                                          height: 2.1,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 24.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Color.fromRGBO(251, 251, 251, 1),
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.12,
                                      child: const AutoSizeText(
                                        'Customer',
                                        style: TextStyle(
                                          height: 1.7,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 20.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                          bottom: BorderSide(
                                            width: 1.5,
                                            color:
                                                Color.fromRGBO(207, 207, 207, 1),
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                      height: screenHeight * 0.055,
                                      width: screenWidth * 0.28,
                                      child: const AutoSizeText(
                                        'ISA',
                                        style: TextStyle(
                                          height: 2.1,
                                          color: Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 24.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20, left: 8, right: 8),
                            child: Row(
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          width: 1.5,
                                          color: Color.fromRGBO(207, 207, 207, 1),
                                        ),
                                        left: BorderSide(
                                          width: 1.5,
                                          color: Color.fromRGBO(207, 207, 207, 1),
                                        ),
                                        bottom: BorderSide(
                                          width: 1.5,
                                          color: Color.fromRGBO(207, 207, 207, 1),
                                        ),
                                      ),
                                      color: Color.fromRGBO(226, 232, 255, 1),
                                    ),
                                    height: screenHeight * 0.82,
                                    width: screenWidth * 0.1,
                                    child: const Center(
                                      child: AutoSizeText(
                                        '수리작업',
                                        style: TextStyle(
                                          height: 1.5,
                                          color: Color.fromRGBO(61, 61, 61, 1),
                                          fontSize: 22.6,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w800,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                              top: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                            ),
                                            color:
                                                Color.fromRGBO(251, 251, 251, 1),
                                          ),
                                          height: screenHeight * 0.065,
                                          width: screenWidth * 0.22,
                                          child: const AutoSizeText(
                                            '검사항목',
                                            style: TextStyle(
                                              height: 2.0,
                                              color: Colors.black,
                                              fontSize: 24.6,
                                              fontFamily: 'NotoSansKR',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                              top: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                            ),
                                            color:
                                                Color.fromRGBO(251, 251, 251, 1),
                                          ),
                                          height: screenHeight * 0.065,
                                          width: screenWidth * 0.11,
                                          child: const AutoSizeText(
                                            '검사여부',
                                            style: TextStyle(
                                              height: 2.1,
                                              color: Colors.black,
                                              fontSize: 24.6,
                                              fontFamily: 'NotoSansKR',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                              top: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                            ),
                                            color:
                                                Color.fromRGBO(251, 251, 251, 1),
                                          ),
                                          height: screenHeight * 0.065,
                                          width: screenWidth * 0.12,
                                          child: const AutoSizeText(
                                            '검사일자',
                                            style: TextStyle(
                                              height: 2.1,
                                              color: Colors.black,
                                              fontSize: 24.6,
                                              fontFamily: 'NotoSansKR',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.275,
                                      width: screenWidth * 0.45,
                                      child: ListView.builder(
                                          itemCount: getCheakContr.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Row(
                                              children: [
                                              Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                        top: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    // color: Colors.blue,
                                                    height: screenHeight * 0.055,
                                                    width: screenWidth * 0.22,

                                                    child: AutoSizeText(
                                                      getCheakContr.elementAt(index).sTEST_CONTENT,
                                                      style: const TextStyle(
                                                        height: 2.0,
                                                        color: Color.fromRGBO(
                                                            102, 102, 102, 1),
                                                        fontSize: 24.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                              Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(
                                                          right: BorderSide(
                                                            width: 1.5,
                                                            color: Color.fromRGBO(
                                                                207, 207, 207, 1),
                                                          ),
                                                          top: BorderSide(
                                                            width: 1.5,
                                                            color: Color.fromRGBO(
                                                                207, 207, 207, 1),
                                                          ),
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      height: screenHeight * 0.055,
                                                      width: screenWidth * 0.11,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.white,
                                                            minimumSize: const Size(200, 100),
                                                              alignment: Alignment.center,
                                                              textStyle: const TextStyle(fontSize: 20)
                                                          ),
                                                        child: Text(getCheakContr.elementAt(index).sTEST_STS,
                                                          style: TextStyle(color : getCheakContr.elementAt(index).sTEST_STS == 'Y' ? Colors.blue :  Colors.red),),
                                                        onPressed: () {
                                                            setState(() {
                                                              Test_NO = getCheakContr.elementAt(index).sTEST_NO;
                                                              add_CheakContr(inKey.toString(), Test_NO, '', 'Y');
                                                            });
                                                        },
                                                      ),
                                                  ),
                                              Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                        top: BorderSide(
                                                          width: 1.5,
                                                            color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    height: screenHeight * 0.055,
                                                    width: screenWidth * 0.12,
                                                    child: AutoSizeText(
                                            // getCheakContr.elementAt(index).sTEST_STS == 'Y' ?
                                            // getCheakContr.elementAt(index).sTEST_DT = DateFormat('yyyy-MM-dd').format(DateTime.now()) :
                                            // getCheakContr.elementAt(index).sTEST_DT = '',
                                            //           getCheakContr.elementAt(index).sTEST_STS == 'Y' ? getCheakContr.elementAt(index).sTEST_DT : '',
                                                      getCheakContr.elementAt(index).sTEST_DT,
                                                      style: const TextStyle(
                                                        height: 2.1,
                                                        color: Color.fromRGBO(
                                                            102, 102, 102, 1),
                                                        fontSize: 24.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                              top: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                            ),
                                            color:
                                                Color.fromRGBO(251, 251, 251, 1),
                                          ),
                                          width: screenWidth * 0.45,
                                          height: screenHeight * 0.08,
                                          child: const AutoSizeText(
                                            '특이사항',
                                            style: TextStyle(
                                              height: 2.0,
                                              color:
                                                  Color.fromRGBO(75, 75, 75, 1),
                                              fontSize: 22.6,
                                              fontFamily: 'NotoSansKR',
                                              fontWeight: FontWeight.w800,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.35,
                                          width: screenWidth * 0.45,
                                          child: ListView.builder(
                                            itemCount: getCheakContr.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                        top: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    // color: Colors.blue,
                                                    height: screenHeight * 0.055,
                                                    width: screenWidth * 0.12, //22
                                                    child: AutoSizeText(
                                                      getCheakContr.elementAt(index).sTEST_CONTENT,
                                                      style: const TextStyle(
                                                        height: 2.0,
                                                        color: Color.fromRGBO(
                                                            102, 102, 102, 1),
                                                        fontSize: 24.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                        top: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    height: screenHeight * 0.055,
                                                    width: screenWidth * 0.28,
                                                    child: AutoSizeText(
                                                      getCheakContr.elementAt(index).sREMK,
                                                      style: const TextStyle(
                                                        height: 2.0,
                                                        color: Color.fromRGBO(
                                                            102, 102, 102, 1),
                                                        fontSize: 24.6,
                                                        fontFamily: 'NotoSansKR',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                  ),
                                                  ),
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                        top: BorderSide(
                                                          width: 1.5,
                                                          color: Color.fromRGBO(
                                                              207, 207, 207, 1),
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    // color: Colors.blue,
                                                    height: screenHeight * 0.055,
                                                    width: screenWidth * 0.05, //22
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          minimumSize: const Size(200, 100),
                                                          alignment: Alignment.center,
                                                          textStyle: const TextStyle(fontSize: 16)
                                                      ), child: const Text('수정', style: TextStyle(color : Colors.black)),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (BuildContext context) => AlertDialog(
                                                            title: Text(getCheakContr.elementAt(index).sTEST_CONTENT),
                                                            // content: Text(getCheakContr.elementAt(index).sREMK),
                                                            content: SizedBox(
                                                              width: screenWidth * 0.4,
                                                              child: TextFormField(
                                                                decoration: InputDecoration(
                                                                  labelText: getCheakContr.elementAt(index).sREMK,
                                                                ),
                                                                onChanged: (String str) {
                                                                  setState((){
                                                                    ChageText = str;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () {
                                                                    if(ChageText.isNotEmpty){
                                                                      Test_NO = getCheakContr.elementAt(index).sTEST_NO;
                                                                      add_CheakContr(inKey.toString(), Test_NO, ChageText, 'R');
                                                                      Get.back();
                                                                    } else {
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) => AlertDialog(
                                                                            title:  const Text("알림"),
                                                                            content: const Text('값을 입력해 주세요.'),
                                                                            actions: [
                                                                              TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                                  child: const Text('닫기')),
                                                                            ],
                                                                          ));
                                                                    }
                                                                  },
                                                                  child: const Text('수정',
                                                                  style: TextStyle(
                                                                    color: Colors.black
                                                                  ),)),
                                                              TextButton(
                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                  child: const Text('닫기',
                                                                  style: TextStyle(
                                                                    color: Colors.black
                                                                  ),)),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                              top: BorderSide(
                                                width: 1.5,
                                                color: Color.fromRGBO(
                                                    207, 207, 207, 1),
                                              ),
                                            ),
                                            color:
                                            Color.fromRGBO(251, 251, 251, 1),
                                          ),
                                          width: screenWidth * 0.225,
                                          height: screenHeight * 0.05,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                minimumSize: const Size(200, 100),
                                                alignment: Alignment.center,
                                                textStyle: const TextStyle(fontSize: 20)
                                            ), child: const Text('전체완료', style: TextStyle(color : Colors.blue)),
                                            onPressed: () {
                                              for (int i = 0 ; i < getCheakContr.length ; i++) {
                                                setState(() {
                                                  Test_NO = getCheakContr.elementAt(i).sTEST_NO;
                                                  getCheakContr.elementAt(i).sTEST_DT.isEmpty?
                                                  add_CheakContr(inKey.toString(), Test_NO, '', 'Y') : getCheakContr.elementAt(i).sTEST_STS;
                                                });
                                              }
                                            },
                                          )
                                        ),
                                        Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  width: 1.5,
                                                  color: Color.fromRGBO(
                                                      207, 207, 207, 1),
                                                ),
                                                top: BorderSide(
                                                  width: 1.5,
                                                  color: Color.fromRGBO(
                                                      207, 207, 207, 1),
                                                ),
                                              ),
                                              color:
                                              Color.fromRGBO(251, 251, 251, 1),
                                            ),
                                            width: screenWidth * 0.225,
                                            height: screenHeight * 0.05,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  minimumSize: const Size(200, 100),
                                                  alignment: Alignment.center,
                                                  textStyle: const TextStyle(fontSize: 20)
                                              ), child: const Text('전체취소', style: TextStyle(color : Colors.red)),
                                              onPressed: () {
                                                for (int i = 0 ; i < getCheakContr.length ; i++) {
                                                  setState(() {
                                                    Test_NO = getCheakContr.elementAt(i).sTEST_NO;
                                                    getCheakContr.elementAt(i).sTEST_DT.isNotEmpty?
                                                    add_CheakContr(inKey.toString(), Test_NO, '', 'Y') : getCheakContr.elementAt(i).sTEST_STS;
                                                    // add_CheakContr(inKey.toString(), TNO);
                                                    // Get.log(getCheakContr.elementAt(0).sTEST_NO);
                                                  });
                                                }
                                              },
                                            )
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
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 241, 241, 1),
                      ),
                      height: screenHeight * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
