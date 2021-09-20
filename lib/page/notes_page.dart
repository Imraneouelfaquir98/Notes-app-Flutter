import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:notes_app/db/notes_database.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/page/edit_note_page.dart';
import 'package:notes_app/page/note_detail_page.dart';
import 'package:notes_app/widget/note_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_widget.dart';
import 'package:get/get.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

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
  void initState(){
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('language') != null){
      String language = prefs.getString('language')!;
      Get.back();
      Get.updateLocale(getLocal(language));
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.changeLanguage(language);
    }
    else {
      await prefs.setString('language', 'English');
      Get.back();
      Get.updateLocale(Locale('en','US'));
    }
    if(prefs.getBool('isDark') != null){
      bool isDark = prefs.getBool('isDark')!;
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.toggleTheme(isDark);
    }
    else {
      await prefs.setBool('isDark', false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
                color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          title: Text(
            'notes'.tr,
            style: TextStyle(
                fontSize: 24,
                color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
            ),
          ),
          actions: [
            Icon(Icons.search, size: 30, color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,),
            SizedBox(width: 12)
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'no notes'.tr,
                      style: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode?Colors.white:Colors.blueGrey.shade800, fontSize: 24,),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode?Colors.black:Colors.blueGrey.shade800,
          child: Icon(Icons.add, size: 30,),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
        drawer: DrawerWidget(),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
