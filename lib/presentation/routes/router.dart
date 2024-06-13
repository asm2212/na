import 'package:auto_route/annotations.dart';
import 'package:na/presentation/pages/notes/note_form/note_form_page.dart';
import 'package:na/presentation/pages/notes/notes_overview/notes_overview_screen.dart';
import 'package:na/presentation/pages/sign_in/sign_in_page.dart';
import 'package:na/presentation/pages/splash/splash_page.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  AutoRoute(page: SplashPage, initial: true),
  AutoRoute(page: SignInPage),
  AutoRoute(page: NotesOverviewPage),
  AutoRoute(page: NoteFormPage, fullscreenDialog: true),
])
class $Router {}

