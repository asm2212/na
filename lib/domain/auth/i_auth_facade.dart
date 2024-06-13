import 'package:dartz/dartz.dart';

import './auth_failure.dart';
import './value_objects.dart';
import '../../domain/auth/user.dart';

abstract class IAuthFacade {
  Option<User> getSignedInUser();

  /// used Unit type because it from dartz package and it is same void type
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<void> signOut();
}
