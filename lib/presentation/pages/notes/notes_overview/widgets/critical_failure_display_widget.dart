import 'package:flutter/material.dart';

import '../../../../../utils/icon_broken.dart';
import '../../../../../domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;
  const CriticalFailureDisplay({Key? key, required this.failure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '😪',
          style: TextStyle(fontSize: 80),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
          child: Text(
            failure.maybeWhen(
                insufficientPermissions: () => 'Insufficient Permissions ❌',
                orElse: () =>
                    'Unexpected error\nPlease contact support. 👨‍💻'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(0)),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  IconBroken.Message,
                ),
                SizedBox(
                  width: 4,
                ),
                Text('I NEED HELP'),
              ],
            ))
      ],
    );
  }
}
