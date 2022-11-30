// ignore_for_file: non_constant_identifier_names, camel_case_types, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../controller/controllers.dart';
import '../model/models.dart';

class navigationDrawerWidget extends StatefulWidget {
  final Function _drawerCallback;

  const navigationDrawerWidget(this._drawerCallback);

  @override
  _navigationDrawerWidget createState() => _navigationDrawerWidget();
}

class _navigationDrawerWidget extends State<navigationDrawerWidget>
    with WidgetsBindingObserver {
  late FocusNode contrFocusNode;
  late FocusNode lastCargoFocusNode;
  final String _fontFamily = 'NotoSansKR';

  // # 캐시 저장 관련 변수
  late String shareWC = '';
  late String sCorp_CD = '';
  late String sUser_ID = '';

  // # Api 관련 변수
  List<PartnerResponseModel> getPartner = [];
  List<String> PartnerList = [];

  // # 긴급하차 관련 변수
  final txtContrController = TextEditingController();
  final txtVehController = TextEditingController();
  final txtSizeController = TextEditingController();
  List<bool> isType = [true, false, false, false, false];
  List<bool> isSize = [true, false, false];
  List<bool> isSTS = [true, false];

  List<String> isType_List = ['GP', 'RF', 'FR', 'OT', 'TN'];
  List<String> isSize_List = ['20', '40', '45'];
  List<String> isSTS_List = ['E', 'F'];

  String isType_Text = '';
  String isSize_Text = '';
  String isSTS_Text = '';
  late String temp_Partner = '';
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  // # API 호출(컨테이너 긴급 등록 - 컨테이너 번호 얻기)
  List<AddUrgContrResponseModel> result = [];
  late int iUrgContrKey = 0;
  late UnLoadResponseModel tempModel;

  add_Contr_Urg(
    String sCorp_ID,
    String sUser_ID,
    String sContr_NO,
    String sContr_Type,
    String sContr_Size,
    String sContr_LOAD_STS,
    String sWorkCenter,
    String sPartner,
    String sLast_Cargo,
    String pCONTR_KEY,
    String pERROR,
  ) async {
    APIAddUrgContr apiAddUrgContr = APIAddUrgContr();
    List<String> sParam = [
      sCorp_ID,
      sUser_ID,
      sContr_NO,
      sContr_Type,
      sContr_Size,
      sContr_LOAD_STS,
      sWorkCenter,
      sPartner,
      sLast_Cargo,
      pCONTR_KEY,
      pERROR,
    ];
    await apiAddUrgContr.getUpdate("USP_ADD_URG_CONTR", sParam).then((value) {
      if (value.result.isNotEmpty) {
        result = value.result;
        if (result.elementAt(0).rsCode != '0') {
          iUrgContrKey = int.parse(result.elementAt(0).rsCode);
        }
      } else {}
    });
  }

// # 캐시 호출(작업장)
  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD = prefs.getString('CorpCD')!;
    shareWC = prefs.getString('WC') ?? '';
    sUser_ID = prefs.getString('UserID') ?? '';
  }

  @override
  void initState() {
    super.initState();
    widget._drawerCallback(true);
    contrFocusNode = FocusNode();
    lastCargoFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    widget._drawerCallback(false);
    contrFocusNode.dispose();
    lastCargoFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PartnerStateController pc = Get.put(PartnerStateController());
    return SizedBox(
      width: Get.width / 2,
      child: Drawer(
          elevation: 30,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 12,
                color: const Color(0xFF0094d0),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: AutoSizeText(
                      'NO.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily),
                    ),
                    subtitle: SizedBox(
                      height: Get.height * 0.07,
                      child: TextField(
                        autofocus: false,
                        focusNode: contrFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: _fontFamily, fontSize: 20),
                        textInputAction: TextInputAction.done,
                        controller: txtContrController,
                      ),
                    ),
                  ),
                  ListTile(
                    title: AutoSizeText(
                      '화주',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily),
                    ),
                    subtitle: InkWell(
                      onTap: () async {
                        temp_Partner = await showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        ) as String;
                        pc.change(temp_Partner);
                      },
                      child: Container(
                        height: Get.height * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Obx(
                            () => AutoSizeText(
                              pc.partnerName.value,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: _fontFamily),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: AutoSizeText(
                      '타입(Type)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily),
                    ),
                    subtitle: ToggleButtons(
                      direction: Axis.horizontal,
                      borderColor: Colors.grey,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.086,
                          child: AutoSizeText(
                            'GP',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.086,
                          child: AutoSizeText(
                            'RF',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.086,
                          child: AutoSizeText(
                            'FR',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.086,
                          child: AutoSizeText(
                            'OT',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.086,
                          child: AutoSizeText(
                            'TN',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isType.length; i++) {
                            isType[i] = i == index;
                            if (isType[i] == true) {
                              isType_Text = isType_List[i];
                            }
                          }
                        });
                      },
                      isSelected: isType,
                    ),
                  ),
                  ListTile(
                    title: AutoSizeText(
                      '크기(Size)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily),
                    ),
                    subtitle: ToggleButtons(
                      direction: Axis.horizontal,
                      borderColor: Colors.grey,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.144,
                          child: AutoSizeText(
                            '20',
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.143,
                          child: AutoSizeText(
                            '40',
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.143,
                          child: AutoSizeText(
                            '45',
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSize.length; i++) {
                            isSize[i] = i == index;
                            if (isSize[i] == true) {
                              isSize_Text = isSize_List[i];
                            }
                          }
                        });
                      },
                      isSelected: isSize,
                    ),
                  ),
                  ListTile(
                    title: AutoSizeText(
                      '컨테이너 상태',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily),
                    ),
                    subtitle: ToggleButtons(
                      borderColor: Colors.grey,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.215,
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            isSTS_List[0],
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.08,
                          width: Get.width * 0.215,
                          child: AutoSizeText(
                            isSTS_List[1],
                            style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSTS.length; i++) {
                            isSTS[i] = i == index;
                            if (isSTS[i] == true) {
                              isSTS_Text = isSTS_List[i];
                            }
                          }
                        });
                      },
                      isSelected: isSTS,
                    ),
                  ),
                  ListTile(
                    title: AutoSizeText(
                      '차량번호',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily),
                    ),
                    subtitle: SizedBox(
                      height: Get.height * 0.07,
                      child: TextField(
                        autofocus: false,
                        focusNode: lastCargoFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: _fontFamily, fontSize: 20),
                        textInputAction: TextInputAction.done,
                        controller: txtVehController,
                      ),
                    ),
                  ),
                  ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: SizedBox(
                        height: Get.height * 0.08,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(10)),
                          onPressed: () async {
                            if (txtContrController.text.isEmpty) {
                              Get.defaultDialog(
                                barrierDismissible: false,
                                title: "알림",
                                middleText: "컨테이너 번호를 입력해주세요.",
                              );
                              Timer(const Duration(milliseconds: 500), () {
                                Get.back();
                              });
                            } else if (txtContrController.text.length != 11) {
                              Get.defaultDialog(
                                title: "알림",
                                middleText: "컨테이너 번호의 자릿수를 확인해주세요.",
                              );
                              Timer(const Duration(milliseconds: 500), () {
                                Get.back();
                              });
                            } else {
                              await _loadCounter();

                              await add_Contr_Urg(
                                sCorp_CD,
                                sUser_ID,
                                // 로그인 ID
                                txtContrController.text,
                                // 컨테이너 번호
                                isType_Text.isEmpty ? "GP" : isType_Text,
                                // 컨테이너 타입
                                isSize_Text.isEmpty ? "20" : isSize_Text,
                                // 청소 크기
                                isSTS_Text.isEmpty ? "E" : isSTS_Text,
                                // 컨테이너 반입 시 상태
                                shareWC,
                                // 야드 코드
                                pc.partnerCode.value,
                                // 화주
                                txtVehController.text,
                                //.라스트 카고(마지막 화물)
                                '0',
                                '',
                              );
                              pc.clean();
                              Navigator.pop(context);
                              Get.toNamed('/load');
                            }
                          },
                          icon: const Icon(
                            CupertinoIcons.floppy_disk,
                            size: 30,
                          ),
                          label: const Text(
                            '등  록',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          )),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // # Api 관련 변수
  List<PartnerResponseModel> getPartner = [];
  late String tempArg = '';

  // # 캐시 호출(작업장)
  String sCorp_CD = '';

  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCorp_CD = prefs.getString('CorpCD')!;
  }

  // # API 호출(파트너 리스트)
  Future<List<PartnerResponseModel>> get_PartnerInfo(String sCorpCD,
      {required String sBP_SHORT_NM}) async {
    APIGetPartnerInfo apiGetPartnerInfo = APIGetPartnerInfo();
    List<String> sParam = [sCorpCD, sBP_SHORT_NM];
    await apiGetPartnerInfo
        .getSelect("USP_GET_PARTNER_INFO", sParam)
        .then((value) {
      getPartner = value.partner;
    });
    return getPartner;
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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<PartnerResponseModel>>(
        future: get_PartnerInfo(sCorp_CD, sBP_SHORT_NM: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          List<PartnerResponseModel>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    tempArg =
                        '${data?[index].sBP_CD.toString()}/${data?[index].sBP_NM.toString()}/${data?[index].sBP_SHORT_NM.toString()}';
                    close(context, tempArg);
                  },
                  title: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            '${data?[index].sBP_CD}',
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
                              '${data?[index].sBP_NM}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            AutoSizeText(
                              '${data?[index].sBP_SHORT_NM}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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
      child: AutoSizeText('거래처 검색'),
    );
  }
}
