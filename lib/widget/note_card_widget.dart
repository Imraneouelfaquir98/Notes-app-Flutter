import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:notes_app/model/note.dart';
import 'package:provider/provider.dart';

final _lightColors = [
  Color.fromRGBO(204, 225, 255, 1)
];

final _darkColors = [
  Color.fromRGBO(47, 63, 84, 1)
];

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = Provider.of<ThemeProvider>(context).isDarkMode? _darkColors[index % _darkColors.length] : _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode?Colors.grey.shade400:Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              note.title,
              style: TextStyle(
                color: Provider.of<ThemeProvider>(context).isDarkMode?Colors.blueGrey.shade100:Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 130;
      case 2:
        return 130;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
