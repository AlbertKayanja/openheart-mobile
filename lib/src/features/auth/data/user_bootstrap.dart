import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Ensures the signed-in user has a Firestore profile doc.
///
/// Collection: `users/{uid}`
/// Fields:
/// - role: 'client' | 'counsellor'
/// - createdAt: Timestamp
/// - lastSeenAt: Timestamp
class UserBootstrap {
  UserBootstrap({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<void> ensureUserDoc({
    required User user,
    required String role,
  }) async {
    final ref = _db.collection('users').doc(user.uid);
    final now = FieldValue.serverTimestamp();

    await ref.set(
      {
        'uid': user.uid,
        'role': role,
        'createdAt': now,
        'lastSeenAt': now,
      },
      SetOptions(merge: true),
    );
  }
}
