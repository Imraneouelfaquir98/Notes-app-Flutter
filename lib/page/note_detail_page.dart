import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:notes_app/db/notes_database.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/page/edit_note_page.dart';
import 'package:provider/provider.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
          leading: Builder(
            builder: (BuildContext context) => IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                ),
                onPressed: () => Navigator.pop(context)
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white38:Colors.blueGrey.shade400),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.description,
                      style: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white70:Colors.blueGrey.shade600, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined, color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete, color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
