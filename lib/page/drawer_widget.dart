import 'package:flutter/material.dart';
import 'package:notes_app/Provider/change_language.dart';
import 'package:notes_app/Provider/change_theme_button.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatelessWidget {

  final String email     = 'imrane.ouelfaquir@gmail.com';
  final String playStore = 'https://play.google.com/store/apps/details?id=com.notes_app_2022.notes.notes_app';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Drawer(
        child: Container(
          color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.blueGrey.shade900:Colors.blueGrey.shade50,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                    child: Column(
                      children: [
                        Expanded(child: Image.asset('assets/splash.png')),
                        Text(
                          'notes'.tr,
                          style: TextStyle(
                              color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    )
                )
              ),
              ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueAccent,
                  size: 30,
                ),
                title: Text(
                  'dark mode'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                  ),
                ),
                trailing: ChangeThemeButton(),
              ),
              ListTile(
                leading: Icon(
                  Icons.language_outlined,
                  color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueAccent,
                  size: 30,
                ),
                title: Text(
                    'languages'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                    ),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: ChangeLanguageButton(),
                ),
                onTap: (){print("hello");},
              ),
              ListTile(
                leading: Icon(
                  Icons.email,
                  color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueAccent,
                  size: 30,
                ),
                title: Text(
                  'contact us'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                  ),
                ),
                onTap: ()async {
                  String url = "mailto:$email?subject=Keep Notes app&body=";
                  await canLaunch(url)?launch(url):print("error");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.share,
                  color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueAccent,
                  size: 30,
                ),
                title: Text(
                    'share'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                    ),
                ),
                onTap: (){
                  Share.share(playStore, subject: 'Keep Notes App');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
