import 'package:flutter/material.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:provider/provider.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(context),
              SizedBox(height: 8),
              buildDescription(context),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle(BuildContext context) => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white70:Colors.blueGrey.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white70:Colors.blueGrey.shade700,),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription(BuildContext context) => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white60:Colors.blueGrey.shade700, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white60:Colors.blueGrey.shade700, fontSize: 18),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );
}
