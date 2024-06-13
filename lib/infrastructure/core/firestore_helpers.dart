import 'package:cloud_firestore/cloud_firestore.dart';

import '../../injection.dart';
import '../../domain/core/errors.dart';
import '../../domain/auth/i_auth_facade.dart';

extension FirestoreX on FirebaseFirestore {
  /// The user must be already authenticated when calling this method.
  /// Otherwise, throws [NotAuthenticatedError].
  DocumentReference userDocument() {
    final firestore = getIt<FirebaseFirestore>();
    final userOption = getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());

    return firestore.collection('users').doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
