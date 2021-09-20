import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:notes_app/db/notes_database.dart';
import 'package:notes_app/google_ads/ad_state.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/widget/note_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {

  BannerAd? banner;

  void dispose() {
    banner!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then(
            (status){
          setState((){
            banner = BannerAd(
                adUnitId: adState.bannerAdUnitUd,
                size: AdSize.banner,
                request: AdRequest(),
                listener: adState.adListener
            )..load();
          }
          );
        }
    );
  }

  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
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
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: NoteFormWidget(
                isImportant: isImportant,
                number: number,
                title: title,
                description: description,
                onChangedImportant: (isImportant) =>
                    setState(() => this.isImportant = isImportant),
                onChangedNumber: (number) => setState(() => this.number = number),
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDescription: (description) =>
                    setState(() => this.description = description),
              ),
            ),
            if(banner != null)
              Column(
                children: [
                  Expanded(child: Container()),
                  Container(
                    height: 50,
                    child: AdWidget(ad: banner!,),
                  )
                ],
              )
          ]
        ),
      );

  Widget buildButton() {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800)
        ),
        onPressed: addOrUpdateNote,
        child: Text(
            'save'.tr,
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.blueGrey.shade700:Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
        ),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
