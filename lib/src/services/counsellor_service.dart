import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounsellorService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  /// LOGIN
  static Future<void> loginCounsellor({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// REGISTER
  static Future<void> registerCounsellor({
    required String email,
    required String password,
    required String name,
    required String qualification,
    required String experience,
    required List<String> categories,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    await _firestore.collection('counsellors').doc(uid).set({
      'email': email,
      'name': name,
      'qualification': qualification,
      'experience': experience,
      'categories': categories,
      'approved': false, // admin approval later
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// CURRENT COUNSELLOR
  static User? get currentUser => _auth.currentUser;

  /// LOGOUT
  static Future<void> logout() async {
    await _auth.signOut();
  }
}
