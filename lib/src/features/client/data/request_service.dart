import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore access for help requests.
///
/// Collection: `requests/{requestId}`
///
/// NOTE on indexes:
/// Composite indexes are only required when you combine multiple `where()`
/// clauses with `orderBy()` on different fields. To keep setup simple for now,
/// most queries below use a single `where()` and an `orderBy(createdAt)`.
class RequestService {
  RequestService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('requests');

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    return uid;
  }

  Future<String> createHelpRequest({
    required String topic,
    required String message,
  }) async {
    final now = FieldValue.serverTimestamp();

    final doc = await _requests.add({
      'clientId': _uid,
      'counsellorId': null,
      'status': 'open',
      'topic': topic,
      'message': message,
      'createdAt': now,
      'updatedAt': now,
    });

    return doc.id;
  }

  /// The latest request for this client.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchMyRequests() {
    return _requests
        .where('clientId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Open requests shown to counsellors.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchOpenRequests() {
    return _requests
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> acceptRequest(String requestId) async {
    final now = FieldValue.serverTimestamp();
    await _requests.doc(requestId).update({
      'status': 'accepted',
      'counsellorId': _uid,
      'acceptedAt': now,
      'updatedAt': now,
    });
  }

  Future<void> closeRequest(String requestId) async {
    final now = FieldValue.serverTimestamp();
    await _requests.doc(requestId).update({
      'status': 'closed',
      'closedAt': now,
      'updatedAt': now,
    });
  }
}
