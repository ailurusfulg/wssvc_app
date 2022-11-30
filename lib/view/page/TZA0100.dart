// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../model/models.dart';

class TZA0100 extends StatefulWidget {
  const TZA0100({Key? key}) : super(key: key);

  @override
  _TZA0100 createState() => _TZA0100();
}

class _TZA0100 extends State<TZA0100> with SingleTickerProviderStateMixin {
  // # 로그인 관련 변수
  bool hidePassword = true; // Password Hide
  bool _isChecked = true;

  final _idTextEditController = TextEditingController();
  final _pwdTextEditController = TextEditingController();

  late FocusNode idFocusNode;
  late FocusNode pwdFocusNode;
  late Future<ResultModel> userInfo;
  List<UserModel> userModel = [];

  // # 레이아웃 관련 변수
  final double _fontSize = 25;
  final String _fontFamily = 'NotoSansKR';
  late ScrollController _scrollController;

  // # 로그인 관련 변수
  static const storage =
      FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업
  String sCorp_CD = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadCounter(sCorp_CD);
    idFocusNode = FocusNode();
    pwdFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _idTextEditController.dispose();
    _pwdTextEditController.dispose();
  }

  // # 캐시 저장(DB)
  Future<void> _loadCounter(sCorpCD) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('CorpCD', sCorpCD);
    await prefs.setString('UserID', _idTextEditController.text);
    sCorpCD = prefs.getString(('CorpCD'));
  }

  // # 종료버튼
  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => Material(
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
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
                              child: const AutoSizeText(
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
                              child: const AutoSizeText(
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
    final screenHeight = _height * 0.95;

    // # 위젯 - 로고
    final logo = Container(
      height: _height * 0.1,
      width: _height * 0.15,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
            image: AssetImage('resources/image/logo_kuls.png'),
            fit: BoxFit.contain),
      ),
    );

    // # 위젯 - 타이틀
    final title = Container(
      height: _height * 0.2,
      width: _height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
            image: AssetImage('resources/image/title.png'),
            fit: BoxFit.contain),
      ),
    );

    // # 위젯 - ID 레이블
    final labelUserName = Container(
      height: screenHeight * 0.07,
      width: _width / 4,
      alignment: Alignment.bottomLeft,
      child: AutoSizeText("ID",
          maxLines: 1,
          style: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily)),
    );

    // # 위젯 - ID 텍스트박스
    final txtUserName = Container(
      height: _height * 0.1,
      width: _width / 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Colors.blue)),
        child: AutoSizeTextField(
          autofocus: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(pwdFocusNode);
          },
          textAlignVertical: TextAlignVertical.bottom,
          textAlign: TextAlign.left,
          controller: _idTextEditController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            filled: true,
            fillColor: Color(0xFFEFEFEF),
            hintText: '아이디를 입력하세요.',
            hintStyle: TextStyle(color: Color.fromRGBO(159, 159, 159, 1.0)),
          ),
          style: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
        ),
      ),
    );

    // # 위젯 - ID 패널
    final pnlUserName = SizedBox(
      height: _height * 0.1,
      child: Stack(
        alignment: AlignmentDirectional.center, //alignment:new Alignment(x, y)
        children: <Widget>[
          txtUserName,
        ],
      ),
    );

    // # 위젯 - PW 레이블
    final labelUserPwd = Container(
      height: _height * 0.05,
      width: _width / 4,
      alignment: Alignment.bottomLeft,
      child: AutoSizeText("PW",
          maxLines: 1,
          style: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily)),
    );

    // # 위젯 - PW 텍스트박스
    final txtUserPwd = Container(
      height: _height * 0.1,
      width: _width / 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Colors.blue)),
        child: AutoSizeTextField(
          autofocus: false,
          focusNode: pwdFocusNode,
          textInputAction: TextInputAction.go,
          onSubmitted: (value) {
            _login(_idTextEditController.text, _pwdTextEditController.text);
          },
          textAlignVertical: TextAlignVertical.bottom,
          textAlign: TextAlign.left,
          controller: _pwdTextEditController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: const Color(0xFFEFEFEF),
            hintText: '비밀번호를 입력하세요.',
            hintStyle:
                const TextStyle(color: Color.fromRGBO(159, 159, 159, 1.0)),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              icon:
                  Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          style: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
          keyboardType: TextInputType.text,
          obscureText: hidePassword,
        ),
      ),
    );

    // # 위젯 - PW 패널
    final pnlPassword = SizedBox(
      height: _height * 0.1,
      child: Stack(
        alignment: AlignmentDirectional.center, //alignment:new Alignment(x, y)
        children: <Widget>[
          txtUserPwd,
        ],
      ),
    );

    // # 위젯 - ID 체크
    final chkUserName = Container(
      height: _height * 0.05,
      width: _width / 3,
      margin: EdgeInsets.only(left: _width / 10),
      child: Row(
        children: [
          Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                });
              }),
          AutoSizeText(
            "ID 기억하기",
            style: TextStyle(color: Colors.black45, fontFamily: _fontFamily),
          ),
        ],
      ),
    );

    // # 위젯 - 로그인 버튼
    final loginButton = Container(
      height: _height * 0.07,
      width: _width / 4,
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 3),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFF06115A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: AutoSizeText(
          '로 그 인',
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          _login(_idTextEditController.text, _pwdTextEditController.text);
        },
      ),
    );

    // # 스캐폴드
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: WillPopScope(
                onWillPop: null,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              title,
                              Column(children: [
                                FittedBox(
                                    child: labelUserName, fit: BoxFit.fitWidth),
                                FittedBox(
                                    child: pnlUserName, fit: BoxFit.fitWidth),
                                FittedBox(
                                    child: labelUserPwd, fit: BoxFit.fitWidth),
                                FittedBox(
                                    child: pnlPassword, fit: BoxFit.fitWidth),
                                FittedBox(
                                    child: chkUserName, fit: BoxFit.fitWidth),
                              ]),
                              FittedBox(
                                  child: loginButton, fit: BoxFit.fitWidth),
                              logo,
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
      ),
    );
  }

  // # 메소드
  _login(String sUserId, String sPassword) async {
    if (sUserId == '' || sUserId.isEmpty) {
      Get.defaultDialog(
        title: '알림',
        content: const Text("아이디를 입력해주세요."),
      );
      return;
    }
    if (sPassword == '' || sPassword.isEmpty) {
      Get.defaultDialog(
        title: '알림',
        content: const Text("비밀번호를 입력해주세요."),
      );
      return;
    }
    List<String> sParamsPW = [sUserId, sPassword];
    APICheckLogin apiService = APICheckLogin();

      apiService.getSelect("CHECKLOGIN_S1", sParamsPW).then((value) {
      setState(() {
        if (value.user.isNotEmpty) {
          userModel = value.user;
          DateTime getDate = DateTime.parse(userModel.elementAt(0).sEFFECT_DT);
          DateTime nowDate = DateTime.now();
          Duration duration = getDate.difference(nowDate);

          if (userModel.elementAt(0).sUserId != '') {
            if (userModel.elementAt(0).sCORP_USE_FLG == 'N') {
              Get.defaultDialog(
                title: '알림',
                content: const Text("승인되지 않은 사용자입니다."),
              );
            } else if (duration.inDays + 1 <= 0) {
              Get.defaultDialog(
                title: '알림',
                content: const Text("사용 기한이 만료 되었습니다."),
              );
            } else {
              apiService.getSelect("CHECKLOGIN_S2", sParamsPW).then((value2) {
                if (value2.result.elementAt(0).sResult == "PWD") {
                  Get.defaultDialog(
                    title: '알림',
                    content: const Text("비밀번호가 일치하지 않습니다."),
                  );
                  return;
                } else {
                  storage.write(
                    key: "login",
                    value: "id " +
                        _idTextEditController.text.toString() +
                        " " +
                        "password " +
                        _pwdTextEditController.text.toString(),
                  );
                  String tempCorpCD =
                      value2.result.elementAt(0).sResult.toString();
                  _loadCounter(tempCorpCD);
                  Get.toNamed('/test');
                }
              });
            }
          }
        } else {
          userModel = [];
          Get.defaultDialog(
            title: "알림",
            content: const Text("등록된 사용자가 아닙니다."),
          );
        }
      });
    });
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
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            AutoSizeText(sContent),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const AutoSizeText('확인'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
