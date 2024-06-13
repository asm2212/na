import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/core/value_objects.dart';
import '../../domain/auth/user.dart' as my_user;

extension FirebaseUserDomainX on User {
  my_user.User get toDomain {
    return my_user.User(
      id: UniqueId.fromUniqueString(uniqueIdStr: uid), // this.uid
    );
  }
}
