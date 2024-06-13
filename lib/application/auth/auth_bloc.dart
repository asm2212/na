import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auth/user.dart';
import '../../domain/auth/i_auth_facade.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const Initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        authCheckRequested: () {
          final userOption = _authFacade.getSignedInUser();
          emit(
            userOption.fold(
              () => const AuthState.unauthenticated(),
              (user) => AuthState.authenticated(user),
            ),
          );
        },
        signedOut: () async {
          await _authFacade.signOut();
          emit(const AuthState.unauthenticated());
        },
      );
    });
  }
}
