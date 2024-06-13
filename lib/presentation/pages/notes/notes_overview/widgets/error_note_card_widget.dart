import 'package:flutter/material.dart';

import '../../../../../domain/notes/note.dart';

class ErrorNoteCard extends StatelessWidget {
  final Note note;
  const ErrorNoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[800],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Text(
              'Invalid note, please contact support 👨‍💻',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 4),
            Text(
              'Details for nerds:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              note.failureOption
                  .fold(() => '', (failure) => failure.toString()),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
