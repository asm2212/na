import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth/auth_bloc.dart';
import '../../../presentation/routes/router.gr.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) =>
              context.router.replace(const NotesOverviewPageRoute()),
          unauthenticated: (_) =>
              context.router.replace(const SignInPageRoute()),
        );
      },
      child: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.green[600],
          backgroundColor: Colors.blue[600],
        ),
      ),
    );
  }
}
