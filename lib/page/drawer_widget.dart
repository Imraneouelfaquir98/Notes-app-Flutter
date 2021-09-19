import 'package:flutter/material.dart';
import 'package:notes_app/Provider/change_theme_button.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                    child: Text(
                      "Notes",
                      style: TextStyle(
                          color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
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
                  'Dark mode',
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
                    'Languages',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                    ),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 35,
                    color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueAccent,
                  ),
                ),
                onTap: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
