import 'package:sportiwe_admin/utils/shared_pref_manager.dart';

class AppController {
  static AppController? _instance;

  factory AppController() {
    if(_instance == null) {
      _instance = AppController._();
    }

    return _instance!;
  }

  AppController._();

  bool? isDev, isLightTheme;

  Future getThemeMode() async {
    bool? isLight = await SharedPrefManager().getBool("isLight");

    if(isLight == null) await SharedPrefManager().setBool("isLight", true);

    isLightTheme = isLight ?? true;
  }
}