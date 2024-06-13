import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:na/application/auth/auth_bloc.dart';
import 'package:na/application/notes/note_actor/note_actor_bloc.dart';
import 'package:na/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:na/injection.dart';
import 'package:na/presentation/pages/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:na/presentation/pages/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:na/presentation/routes/router.gr.dart';
import 'package:na/utils/icon_broken.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(
              const NoteWatcherEvent.watchAllStarted(),
            ),
        ),
        BlocProvider<NoteActorBloc>(
            create: (context) => getIt<NoteActorBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            state.maybeWhen(
              unauthenticated: () =>
                  context.router.replace(const SignInPageRoute()),
              orElse: () {},
            );
          }),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, state) {
              state.maybeWhen(
                deleteFailure: (noteFailure) {
                  FlushbarHelper.createError(
                    title: '⚠ ERROR',
                    duration: const Duration(seconds: 5),
                    message: noteFailure.when(
                        // Use localized strings here in your apps
                        insufficientPermissions: () =>
                            'Insufficient permissions ❌',
                        unableToUpdate: () => 'Impossible error 😵',
                        unexpected: () =>
                            'Unexpected error occurred while deleting, please contact support. 👨‍💻'),
                  ).show(context);
                },
                orElse: () {},
              );
            },
          )
        ],
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          appBar: AppBar(
            title: const Text('Notes'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(IconBroken.Logout),
              onPressed: () => context.read<AuthBloc>().add(
                    const AuthEvent.signedOut(),
                  ),
            ),
            actions: const <Widget>[UncompletedSwitch()],
          ),
          body: const NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                context.router.push(NoteFormPageRoute(editedNote: null)),
            child: const Icon(IconBroken.Paper_Plus),
          ),
        ),
      ),
    );
  }
}
