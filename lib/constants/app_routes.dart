import 'package:get/get.dart';

import '../view/page/page.dart';
import '../view/view.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => const SplashUI()),
    GetPage(name: '/signin', page: () => const TZA0100(), transition: Transition.cupertino),
    GetPage(name: '/selectWC', page: () => const TZA0200(), transition: Transition.cupertino),
    // GetPage(name: '/load', page: () => const TYA1100(),transition: Transition.cupertino),
    // GetPage(name: '/move', page: () => const TYA1200(),transition: Transition.cupertino),
    GetPage(name: '/cancel', page: () => TWB1200(),transition: Transition.cupertino),
    GetPage(name: '/selectWrk', page: () => const TSB1100(),transition: Transition.cupertino),
    GetPage(name: '/test2', page: () => const TSB1200(),transition: Transition.cupertino),
    GetPage(name: '/test3', page: () => const TSB1300(),transition: Transition.cupertino),
    GetPage(name: '/test4', page: () => const TSB1201(),transition: Transition.cupertino),
  ];
}
