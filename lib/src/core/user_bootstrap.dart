import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Ensures the signed-in user has a Firestore doc in `users/{uid}`.
///
/// You must call this AFTER FirebaseAuth sign-in succeeds.
class UserBootstrap {
  UserBootstrap({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<void> ensureUserDoc({
    required User user,
    required String role, // "client" | "counsellor"
  }) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        'uid': user.uid,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSeenAt': FieldValue.serverTimestamp(),
      });
    } else {
      await ref.update({
        'lastSeenAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
