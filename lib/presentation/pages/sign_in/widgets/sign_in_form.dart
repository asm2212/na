import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:na/application/auth/auth_bloc.dart';
import 'package:na/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:na/presentation/routes/router.gr.dart';
class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {}, // none
          (either) => either.fold(
              // some failure or success option
              (failure) {
            FlushbarHelper.createError(
                title: '⚠ ERROR',
                duration: const Duration(seconds: 5),
                message: failure.when(
                  cancelledByUser: () => 'you canceled the sign in form!! 🙁',
                  serverError: () => 'there was a server error 😪',
                  emailAlreadyInUse: () =>
                      'you already have an account with this email 🤓',
                  invalidEmailAndPasswordCombination: () =>
                      'there was an invalid email or password combination 🤔',
                )).show(context);
          }, (_) {
            context.router.replace(const NotesOverviewPageRoute());
            context.read<AuthBloc>().add(const AuthEvent.authCheckRequested());
          }),
        );
      },
      buildWhen: (previous, current) =>
          previous.showErrorMessages != current.showErrorMessages,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            autovalidateMode: state.showErrorMessages
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/notes_2.png',
                      height: 220,
                      width: 220,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 35),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      hintText: 'example@mail.com',
                    ),
                    autocorrect: false,
                    onChanged: (value) => context
                        .read<SignInFormBloc>()
                        .add(SignInFormEvent.emailChanged(value)),
                    validator: (_) => context
                        .read<SignInFormBloc>()
                        .state
                        .emailAddress
                        .value
                        .fold(
                          (failure) => failure.maybeMap(
                            // validation failed
                            invalidEmail: (_) => 'Invalid email',
                            orElse: () => null,
                          ),
                          (_) => null, // validation succeeded
                        ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password',
                      hintText: '********',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    onChanged: (value) => context
                        .read<SignInFormBloc>()
                        .add(SignInFormEvent.passwordChanged(value)),
                    validator: (_) => context
                        .read<SignInFormBloc>()
                        .state
                        .password
                        .value
                        .fold(
                          (failure) => failure.maybeMap(
                            // validation failed
                            shortPassword: (_) => 'Week password',
                            orElse: () => null,
                          ),
                          (_) => null, // validation succeeded
                        ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.read<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .signInWithEmailAndPasswordPressed()),
                          child: const Text('SIGN IN'),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.read<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .registerWithEmailAndPasswordPressed()),
                          child: const Text('REGISTER'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                      onPressed: () => context
                          .read<SignInFormBloc>()
                          .add(const SignInFormEvent.signInWithGooglePressed()),
                      child: const Text(
                        'SIGN IN WITH GOOGLE',
                      )
                      // .textColor(Colors.white).bold(),
                      ),
                  if (state.isSubmitting) ...[
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      color: Colors.green[500],
                    ),
                  ],
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
