import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/page/notes_page.dart';
import 'package:provider/provider.dart';

import 'Provider/theme_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Notes SQLite';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    builder: (context, _) => MaterialApp(
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
      home: NotesPage(),
      /*
      builder: (context, child){
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child as Widget,
        );
      },
       */
    )
  );
}
