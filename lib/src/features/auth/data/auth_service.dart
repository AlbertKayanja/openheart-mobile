import 'package:firebase_auth/firebase_auth.dart';

/// Minimal auth wrapper for MVP:
/// - Client signs in anonymously
/// - Counsellor signs in anonymously
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInAsClient() async {
    return _auth.signInAnonymously();
  }

  Future<UserCredential> signInAsCounsellor() async {
    return _auth.signInAnonymously();
  }

  Future<void> signOut() => _auth.signOut();
}
