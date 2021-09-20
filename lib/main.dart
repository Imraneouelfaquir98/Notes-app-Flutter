import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes_app/locale_string.dart';
import 'package:notes_app/page/notes_page.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'Provider/theme_provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'google_ads/ad_state.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  static final String title = 'notes'.tr;

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

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    builder: (context, _) => GetMaterialApp(
      translations: LocalString(),
      locale: getLocal(Provider.of<ThemeProvider>(context).selectedLanguage),
      debugShowCheckedModeBanner: false,
      title: title,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Provider.of<ThemeProvider>(context).isDarkMode? Colors.blueGrey.shade900:Colors.blueGrey.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: AnimatedSplashScreen(
        backgroundColor: Colors.white,
        splashIconSize: 600,
        splash: Container(
          color: Colors.white,
          child: Image.asset('assets/splash.png', width: 1000),
        ),
        nextScreen: NotesPage(),
        splashTransition: SplashTransition.scaleTransition,
        duration: 1000,
      ),
      builder: (context, child){
        return Directionality(
          textDirection: Provider.of<ThemeProvider>(context).testDirection,
          child: child as Widget,
        );
      },
    )
  );
}