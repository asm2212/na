import 'package:auto_route/annotations.dart';

import '../pages/splash/splash_page.dart';
import '../pages/sign_in/sign_in_page.dart';
import '../pages/notes/note_form/note_form_page.dart';
import '../pages/notes/notes_overview/notes_overview_screen.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  AutoRoute(page: SplashPage, initial: true),
  AutoRoute(page: SignInPage),
  AutoRoute(page: NotesOverviewPage),
  AutoRoute(page: NoteFormPage, fullscreenDialog: true),
])
class $Router {}

/// for build runner: flutter pub run build_runner watch --delete-conflicting-outputs
