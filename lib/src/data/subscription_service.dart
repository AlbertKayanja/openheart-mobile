import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionService {
  SubscriptionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not signed in');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _subscriptions =>
      _firestore.collection('subscriptions');

  Future<bool> hasActiveSubscription() async {
    final snap = await _subscriptions
        .where('ownerId', isEqualTo: _uid)
        .where('status', isEqualTo: 'active')
        .where('expiresAt', isGreaterThan: FieldValue.serverTimestamp())
        .limit(1)
        .get();

    return snap.docs.isNotEmpty;
  }

  Stream<bool> watchHasActiveSubscription() {
    return _subscriptions
        .where('ownerId', isEqualTo: _uid)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return false;
      final doc = snap.docs.first.data();
      final expires = doc['expiresAt'] as Timestamp?;
      return expires != null && expires.toDate().isAfter(DateTime.now());
    });
  }

  Future<void> createSubscription({
    required String plan,
  }) async {
    await _subscriptions.add({
      'ownerId': _uid,
      'plan': plan,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': null,
    });
  }
}