import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task.dart';

/// Semua operasi ke Firestore. Data disimpan di users/{uid}/tasks
/// sehingga setiap pengguna hanya memiliki tugasnya sendiri.
class FirestoreService {
  /// Dibuat sebagai getter agar uid selalu mengikuti pengguna yang sedang login.
  /// Halaman yang memakai service ini hanya tampil setelah login,
  /// jadi currentUser dijamin tidak null.
  CollectionReference<Map<String, dynamic>> get _tasksRef {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks');
  }

  Future<void> addTask(String title) async {
    await _tasksRef.add({
      'title': title,
      'isDone': false,
      // Waktu dicatat server agar urutan sama di semua perangkat.
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Stream: setiap ada perubahan data, daftar otomatis diperbarui.
  Stream<List<Task>> getTasks() {
    return _tasksRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromDoc(doc.id, doc.data()))
            .toList());
  }

  Future<void> toggleDone(String id, bool value) async {
    await _tasksRef.doc(id).update({'isDone': value});
  }

  /// Nilai tambahan: ubah judul tugas.
  Future<void> updateTitle(String id, String title) async {
    await _tasksRef.doc(id).update({'title': title});
  }

  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }
}
