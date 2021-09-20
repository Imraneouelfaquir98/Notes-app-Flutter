import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageButton extends StatelessWidget {

  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (value){
          print(value);
        },
        icon: Icon(
          Icons.arrow_drop_down,
          size: 35,
          color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueAccent,
        ),
        itemBuilder: (BuildContext context){
          return List<PopupMenuEntry>.generate(
              locale.length,
              (index) => PopupMenuItem(
                child: TextButton(
                  child: Text(locale[index]['name'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  onPressed: () async {
                    final provider = Provider.of<ThemeProvider>(context, listen: false);
                    provider.changeLanguage(locale[index]['name']);
                    updateLanguage(locale[index]['locale']);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('language', locale[index]['name']);
                  },
                ),
              )
          );
        }
    );
  }

  final List locale =[
    {'name':'العربية',  'locale': Locale('ar','MA')},
    {'name':'فارسي', 'locale': Locale('ir','IR')},
    {'name':'Armenian', 'locale': Locale('ar','AR')},
    {'name':'Chiniese', 'locale': Locale('ch','CH')},
    {'name':'Danish', 'locale': Locale('dk','DK')},
    {'name':'English',  'locale': Locale('en','US')},
    {'name':'Espagnol', 'locale': Locale('es','ES')},
    {'name':'Français', 'locale': Locale('fr','FR')},
    {'name':'Finnish', 'locale': Locale('fi','FI')},
    {'name':'Filipino', 'locale': Locale('fp','FP')},
    {'name':'German', 'locale': Locale('gr','GR')},
    {'name':'Hebrew', 'locale': Locale('is','IS')},
    {'name':'Hindi', 'locale': Locale('in','IN')},
    {'name':'Italian', 'locale': Locale('it','IT')},
    {'name':'Indonesian', 'locale': Locale('id','ID')},
    {'name':'Japanese', 'locale': Locale('jp','JP')},
    {'name':'Korean', 'locale': Locale('kr','KR')},
    {'name':'Latin', 'locale': Locale('lt','LT')},
    {'name':'Portoguese', 'locale': Locale('pt','PT')},
    {'name':'Russian', 'locale': Locale('ru','RU')},
    {'name':'Turkish', 'locale': Locale('tr','TR')},
  ];
}
