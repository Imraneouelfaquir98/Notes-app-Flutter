import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  String language = 'English';

  TextDirection get testDirection => ((language == 'العربية' || language == 'Hebrew' || language == 'فارسي')? TextDirection.rtl:TextDirection.ltr);
  bool get isDarkMode => themeMode == ThemeMode.dark;
  String get selectedLanguage => language;

  String getLanguage(){
    notifyListeners();
    return language;
  }

  void setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('language') != null){
      language = prefs.getString('language')!;
      Get.back();
      Get.updateLocale(getLocal(language));
    }
    else {
      await prefs.setString('language', 'English');
      Get.back();
      Get.updateLocale(Locale('en','US'));
    }
  }

  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isOn);
  }

  void changeLanguage(String new_language){
    language = new_language;
    notifyListeners();
  }

  final List locale =[
    {'name':'العربية',  'locale': Locale('ar','MA')},
    {'name':'English',  'locale': Locale('en','US')},
    {'name':'Espagnol', 'locale': Locale('es','ES')},
    {'name':'Français', 'locale': Locale('fr','FR')},
    {'name':'فارسي', 'locale': Locale('ir','IR')},
    {'name':'Russian', 'locale': Locale('ru','RU')},
    {'name':'Chiniese', 'locale': Locale('ch','CH')},
    {'name':'Hebrew', 'locale': Locale('is','IS')},
    {'name':'German', 'locale': Locale('gr','GR')},
    {'name':'Italian', 'locale': Locale('it','IT')},
    {'name':'Danish', 'locale': Locale('dk','DK')},
    {'name':'Japanese', 'locale': Locale('jp','JP')},
    {'name':'Korean', 'locale': Locale('kr','KR')},
    {'name':'Turkish', 'locale': Locale('tr','TR')},
    {'name':'Hindi', 'locale': Locale('in','IN')},
    {'name':'Portoguese', 'locale': Locale('pt','PT')},
    {'name':'Finnish', 'locale': Locale('fi','FI')},
    {'name':'Filipino', 'locale': Locale('fp','FP')},
    {'name':'Latin', 'locale': Locale('lt','LT')},
    {'name':'Armenian', 'locale': Locale('ar','AR')},
    {'name':'Indonesian', 'locale': Locale('id','ID')},
  ];

  Locale getLocal(String lng){
    for(int i=0; i<locale.length; i++)
      if(locale[i]['name'] == lng)
        return locale[i]['locale'];
    return Locale('en','US');
  }
}