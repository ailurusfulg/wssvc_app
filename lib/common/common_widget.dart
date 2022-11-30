// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/api.dart';
import '../model/models.dart';

SnackBar basicSnackBar(String Message) {
  return SnackBar(
    // SnackBar가 출력되는 시간
    duration: Duration(seconds: 2),
    backgroundColor: Colors.green,
    // SnackBar의 내용
    content: Text(
      Message,
      style: TextStyle(color: Colors.white, fontFamily: 'NotoSansKR'),
    ),

    // SnackBar의 오른쪽에 배치될 위젯
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}
// 상세보기 btn

btnDetailView(BuildContext context, String sDetailNM,
    StatefulWidget pMovePageNM, String sSelectedStage, String sSelectedBay) {
  var _height = Get.height;
  var _width = Get.width;
  final _ScreenHeight = _height * 0.95;
  final _ScreenWidth = _width * 0.95;

  return Container(
    height: _ScreenHeight * 0.08,
    width: _ScreenWidth * 0.15,
    margin: EdgeInsets.only(left: _ScreenWidth * 0.01),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10, primary: Color.fromRGBO(245, 134, 52, 1)),
      onPressed: () async {
        String result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => pMovePageNM));
        sSelectedStage = result.substring(0, 2);
        sSelectedBay = result.substring(3, 4);
      },
      child: Text(
        sDetailNM,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

txtWorkState(BuildContext context, String sTxtNM, Color clrBackColor,
    Color clrTxtColor) {
  final _height = Get.height;
  final _width = Get.width;
  final _ScreenHeight = _height * 0.95;
  final _ScreenWidth = _width * 0.95;
  return Container(
    alignment: Alignment.center,
    height: _ScreenHeight * 0.08,
    decoration: BoxDecoration(color: clrBackColor),
    child: AutoSizeText(sTxtNM.isEmpty ? "" : sTxtNM,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: clrTxtColor,
        )),
  );
}

txtValueState(BuildContext context, String sTxtNM, Color clrBackColor,
    Color clrTxtColor) {
  final _height = Get.height;
  final _width = Get.width;
  final _ScreenHeight = _height * 0.95;
  final _ScreenWidth = _width * 0.95;
  return Container(
    alignment: Alignment.center,
    height: _ScreenHeight * 0.08,
    padding: EdgeInsets.only(right: 5),
    decoration: BoxDecoration(
        color: clrBackColor,
        border: Border(right: BorderSide(width: 1, color: Colors.grey))),
    child: AutoSizeText(sTxtNM.isEmpty ? "" : sTxtNM,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: clrTxtColor,
        )),
  );
}

// 긴급등록 Dialog
// # API 호출(컨테이너 긴급 등록 - 컨테이너 번호 얻기)
List<AddUrgContrResponseModel> result = [];
late int iUrgContrNo = 0;
final sContrNo_TxtController = TextEditingController();
final sVehicle_TxtController = TextEditingController();
final sType_TxtController = TextEditingController();
late UnLoadResponseModel tempModel;

void add_Contr_Urg(
  String sDRV_ID,
  String sContr_NO,
  String sContr_Type,
  String sVehicle,
  String pCONTR_KEY,
  String pERROR,
) async {
  APIAddUrgContr apiAddUrgContr = APIAddUrgContr();
  List<String> sParam = [
    sDRV_ID,
    sContr_NO,
    sContr_Type,
    sVehicle,
    pCONTR_KEY,
    pERROR,
  ];
  await apiAddUrgContr.getUpdate("USP_ADD_URG_CONTR", sParam).then((value) {
    if (value.result.isNotEmpty) {
      result = value.result;
      if (result.elementAt(0).rsCode != "0") {
        iUrgContrNo = int.parse(result.elementAt(0).rsCode);
      }
    } else {}
  });
}

void UrgentAddContainer(
    BuildContext context, String sMachID, String sMachDRVID) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        var _height = Get.height;
        var _width = Get.width;
        var _DialogHeight = _height * 0.5;
        var _DialogWidth = _width * 0.4;
        UnLoadResponseModel tempModel;

        FocusNode frtFocusNode;
        FocusNode scdFocusNode;
        FocusNode thdFocusNode;

        frtFocusNode = FocusNode();
        scdFocusNode = FocusNode();
        thdFocusNode = FocusNode();

        // @override
        // void dispose() {
        //   sContrNo_TxtController.dispose();
        //   sVehicle_TxtController.dispose();
        //   sType_TxtController.dispose();
        //   dispose();
        // }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                title: Text(
                  '긴급컨테이너 등록',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                content: Builder(
                  builder: (context) {
                    return Container(
                      height: _DialogHeight * 0.7,
                      width: _DialogWidth,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 10),
                                      padding: EdgeInsets.all(10),
                                      height: _DialogHeight * 0.2,
                                      width: _DialogWidth * 0.3,
                                      child: Text(
                                        '컨테이너',
                                        style: TextStyle(fontSize: 20),
                                      )),
                                  Container(
                                      height: _DialogHeight * 0.2,
                                      width: _DialogWidth * 0.6,
                                      child: AutoSizeTextField(
                                        autofocus: true,
                                        focusNode: frtFocusNode,
                                        controller: sContrNo_TxtController,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(scdFocusNode);
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.green)),
                                            filled: true,
                                            hintText: '컨테이너번호 입력'),
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 10),
                                      padding: EdgeInsets.all(10),
                                      height: _DialogHeight * 0.2,
                                      width: _DialogWidth * 0.3,
                                      child: Text(
                                        '차량번호',
                                        style: TextStyle(fontSize: 20),
                                      )),
                                  SizedBox(
                                      height: _DialogHeight * 0.2,
                                      width: _DialogWidth * 0.6,
                                      child: AutoSizeTextField(
                                        autofocus: false,
                                        focusNode: scdFocusNode,
                                        controller: sVehicle_TxtController,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(thdFocusNode);
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.green)),
                                            filled: true,
                                            hintText: '차량번호 입력'),
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 10),
                                      padding: EdgeInsets.all(10),
                                      height: _DialogHeight * 0.2,
                                      width: _DialogWidth * 0.3,
                                      child: Text(
                                        '규격코드',
                                        style: TextStyle(fontSize: 20),
                                      )),
                                  Container(
                                      height: _DialogHeight * 0.2,
                                      width: _DialogWidth * 0.6,
                                      child: AutoSizeTextField(
                                        autofocus: false,
                                        focusNode: thdFocusNode,
                                        controller: sType_TxtController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.green)),
                                            filled: true,
                                            hintText: '규격코드 입력'),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                actions: <Widget>[
                  Center(
                    child: Container(
                      height: _DialogHeight * 0.13,
                      width: _DialogWidth * 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(CupertinoIcons.pencil),
                            Text(
                              "등    록",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onPressed: () {
                          add_Contr_Urg(
                            sMachDRVID,
                            sContrNo_TxtController.text,
                            sType_TxtController.text,
                            sVehicle_TxtController.text,
                            '0',
                            '',
                          );
                          // print(iUrgContrNo);
                          tempModel = UnLoadResponseModel(
                              sContrNO: sContrNo_TxtController.text,
                              sCONTR_KEY: iUrgContrNo.toString(),
                              sIN_PLN_DT: '',
                              sOT_PLN_DT: '',
                              sWC_CD: '',
                              sCONTR_LOAD_STS: '',
                              sVehicle: sVehicle_TxtController.text,
                              sVES_CD: '',
                              sLINER_CD: '',
                              sARR_CD: '',
                              sWRK_PLN_DT: '',
                              sWRK_DT: '',
                              sORD_EMP: '',
                              sVes_Block: 0,
                              sVes_Bay: 0
                          );
                          Get.back();
                          // Navigator.of(context).pop();
                          // Get.to(TWA2200(), arguments: tempModel);
                        },
                      ),
                    ),
                  )
                ]);
          },
        );
      });
}

// 상태변경
Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    // MaterialState.hovered,
    // MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return Colors.grey;
}

// 컨테이너 색상 변경
AssetImage setContrColor2(
    String sTargetText,
    String txtFirst,
    String txtSecond,
    String txtThird,
    String txtForth,
    String txtFifth,
    String txtSixth,
    AssetImage aimgFisrt,
    AssetImage aimgSecond,
    AssetImage aimgThird,
    AssetImage aimgForth,
    AssetImage aimgFifth,
    AssetImage aimgSixth,
    AssetImage aimgRemain) {
  if (sTargetText.endsWith(txtFirst)) {
    return aimgFisrt;
  } else if (sTargetText.endsWith(txtSecond)) {
    return aimgSecond;
  } else if (sTargetText.endsWith(txtThird)) {
    return aimgThird;
  } else if (sTargetText.endsWith(txtForth)) {
    return aimgForth;
  } else if (sTargetText.endsWith(txtFifth)) {
    return aimgSixth;
  } else if (sTargetText.endsWith(txtSixth)) {
    return aimgSixth;
  } else {
    return aimgRemain;
  }
}

// 컨테이너 색상 변경
Color setContrColor(
    String sTargetText,
    String txtFirst,
    String txtSecond,
    String txtThird,
    String txtForth,
    String txtFifth,
    String txtSixth,
    Color clrFisrt,
    Color clrSecond,
    Color clrThird,
    Color clrForth,
    Color clrFifth,
    Color clrSixth,
    Color clrRemain) {
  if (sTargetText.endsWith(txtFirst)) {
    return clrFisrt;
  } else if (sTargetText.endsWith(txtSecond)) {
    return clrSecond;
  } else if (sTargetText.endsWith(txtThird)) {
    return clrThird;
  } else if (sTargetText.endsWith(txtForth)) {
    return clrForth;
  } else if (sTargetText.endsWith(txtFifth)) {
    return clrFifth;
  }  else if (sTargetText.endsWith(txtSixth)) {
    return clrSixth;
  } else {
    return clrRemain;
  }
}

Color setContrColorSTK(String sTargetText, int txtLenght, String txtSecond,
    Color clrFisrt, Color clrSecond, Color clrRemain) {
  if (sTargetText.length > txtLenght) {
    return clrFisrt;
  } else if (sTargetText.endsWith(txtSecond)) {
    return clrSecond;
  } else {
    return clrRemain;
  }
}

// color:  MaterialStateProperty.resolveWith(getColor),
class CustomCard extends StatelessWidget {
  final bool isActive;
  final String text;
  final IconData iconData;
  final VoidCallback onTap;

  const CustomCard({
    required this.isActive,
    required this.text,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final _height = Get.height;
    final _width = Get.width;
    final _ScreenHeight = _height * 0.95;
    final _ScreenWidth = _width * 0.95;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: _ScreenHeight * 0.1,
        width: _ScreenWidth * 0.15,
        child: Card(
          color: isActive ? Colors.white : Colors.grey[800],
          semanticContainer: true,
          margin: EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 0, right: 0, bottom: 20, left: 0),
                    child: Text(
                      isActive ? 'On' : 'Off',
                      style: TextStyle(
                          color: isActive ? Colors.grey[800] : Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
