import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/api.dart';

class SplashUI extends StatelessWidget {
  const SplashUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Loading(),
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  AppUpdateInfo? _updateInfo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _flexibleUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }
  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  bool reverse = false;
  bool isLogin = false;

  String userInfo = "";
  static const storage =
      FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

  @override
  void initState() {
    super.initState();
    requestStoragePermission(context);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
      value: 0,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 600), () {
            _controller.reverse();
            reverse = true;
          });
        }
        if (reverse) {
          Future.delayed(const Duration(milliseconds: 500), () {});
          //비동기로 flutter secure storage 정보를 불러오는 작업.
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _asyncMethod();
          });
        }
      });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // # 스캐폴드
    return Scaffold(
      body: Center(
        child: RotationTransition(
          turns: _animation,
          alignment: const Alignment(0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  width: 114,
                  height: 119,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('resources/image/kuls_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Get.toNamed('/signin');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    // storage.write(key: "login", value: "id " + '10000001 ' + " " + '10000001 ');
    userInfo = (await storage.read(key: "login")) ?? '';

    //user의 정보가 있다면 바로 메인 페이지로 넝어가게 합니다.
    if (userInfo.isNotEmpty) {
      List<String> sParam = [userInfo.split(" ")[1], userInfo.split(" ")[3]];

      APICheckLogin apiCheckLogin = APICheckLogin();
      apiCheckLogin.getSelect('CHECKLOGIN_S2', sParam).then((value) {
        if (value.result.elementAt(0).sResult != "") {
          Get.toNamed('/selectWC');
        }
        else{
          Get.toNamed('/signin');
        }
      });
    } else {
      Get.toNamed('/signin');
    }
  }
}

Future<bool> requestStoragePermission(BuildContext context) async {
  PermissionStatus status = await Permission.storage.request();

  if (!status.isGranted) {
    // 허용이 안된 경우
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("권한 설정을 확인해주세요."),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    openAppSettings(); // 앱 설정으로 이동
                  },
                  child: const Text('설정하기')),
            ],
          );
        });
    return false;
  }
  return true;
}
