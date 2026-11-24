import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/edit_title_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirestoreService();
  final _authService = AuthService();
  // Stream dibuat sekali agar tidak dibuat ulang setiap build().
  late final Stream<List<Task>> _tasksStream = _firestore.getTasks();
  final _dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

  /// Menjalankan operasi Firestore dan menampilkan SnackBar jika gagal.
  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal: $e')));
    }
  }

  Future<bool> _confirm(String title, String message, String okLabel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(okLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _logout() async {
    if (await _confirm('Keluar', 'Yakin ingin keluar dari akun?', 'Keluar')) {
      await _authService.signOut();
    }
  }

  Future<void> _delete(Task task) async {
    if (await _confirm('Hapus tugas', 'Hapus "${task.title}"?', 'Hapus')) {
      await _safe(() => _firestore.deleteTask(task.id));
    }
  }

  Future<void> _edit(Task task) async {
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) => EditTitleDialog(initialTitle: task.title),
    );
    if (newTitle == null || newTitle == task.title) return;
    await _safe(() => _firestore.updateTitle(task.id, newTitle));
  }

  Widget _emptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.task_alt, size: 88, color: scheme.primary),
          const SizedBox(height: 16),
          Text('Belum ada tugas',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Tekan tombol + untuk menambah tugas',
              style: TextStyle(color: scheme.outline)),
        ],
      ),
    );
  }

  Widget _taskCard(BuildContext context, Task task) {
    final scheme = Theme.of(context).colorScheme;
    final ts = task.timestamp;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (val) =>
              _safe(() => _firestore.toggleDone(task.id, val ?? false)),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? scheme.outline : null,
          ),
        ),
        // timestamp null = server belum mengisi waktu (baru ditambahkan)
        subtitle: Text(
          ts == null ? 'Menyimpan...' : _dateFormat.format(ts),
          style: TextStyle(color: scheme.outline, fontSize: 12),
        ),
        onTap: () => _edit(task),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Ubah',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _edit(task),
            ),
            IconButton(
              tooltip: 'Hapus',
              icon: Icon(Icons.delete_outline, color: scheme.error),
              onPressed: () => _delete(task),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List Firestore'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: _tasksStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data!;
          if (tasks.isEmpty) return _emptyState(context);
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: tasks.length,
            itemBuilder: (context, index) => _taskCard(context, tasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
