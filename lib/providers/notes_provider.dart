import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/notes_storage_service.dart';

// Holds all notes + UI state (category filter, sort order, theme) and
// notifies listeners so screens rebuild automatically. This is the
// state management (Provider) part of the task.
class NotesProvider extends ChangeNotifier {
  final NotesStorageService _storage = NotesStorageService();

  List<Note> _notes = [];
  NoteCategory? _categoryFilter;
  SortOrder _sortOrder = SortOrder.newest;
  bool _isDarkMode = false;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  NoteCategory? get categoryFilter => _categoryFilter;
  SortOrder get sortOrder => _sortOrder;
  List<Note> get allNotes => List.unmodifiable(_notes);

  Note? noteById(String id) {
    for (final n in _notes) {
      if (n.id == id) return n;
    }
    return null;
  }

  // Home screen list: filtered by the selected category chip only.
  List<Note> get filteredNotes {
    List<Note> result = _categoryFilter == null
        ? List.of(_notes)
        : _notes.where((n) => n.category == _categoryFilter).toList();
    return _sorted(result);
  }

  // Used by the dedicated Search screen: filters by text AND an
  // independent category selection, regardless of the Home filter.
  List<Note> search({required String query, NoteCategory? category}) {
    List<Note> result = category == null
        ? List.of(_notes)
        : _notes.where((n) => n.category == category).toList();

    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where((n) =>
              n.title.toLowerCase().contains(q) || n.content.toLowerCase().contains(q))
          .toList();
    }
    return _sorted(result);
  }

  List<Note> _sorted(List<Note> notes) {
    switch (_sortOrder) {
      case SortOrder.newest:
        notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case SortOrder.oldest:
        notes.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case SortOrder.titleAZ:
        notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }
    return notes;
  }

  Future<void> load() async {
    try {
      _notes = await _storage.loadNotes();
      _isDarkMode = await _storage.loadDarkMode();
    } catch (e) {
      // storage was corrupted or unreadable — start fresh instead of crashing
      _notes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
    required NoteCategory category,
  }) async {
    final now = DateTime.now();
    final note = Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      category: category,
      createdAt: now,
      updatedAt: now,
    );
    _notes.add(note);
    await _storage.saveNotes(_notes);
    notifyListeners();
  }

  Future<void> updateNote(
    Note note, {
    required String title,
    required String content,
    required NoteCategory category,
  }) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) return;

    _notes[index] = note.copyWith(
      title: title.trim(),
      content: content.trim(),
      category: category,
      updatedAt: DateTime.now(),
    );
    await _storage.saveNotes(_notes);
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    _notes.removeWhere((n) => n.id == note.id);
    await _storage.saveNotes(_notes);
    notifyListeners();
  }

  void setCategoryFilter(NoteCategory? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _storage.saveDarkMode(value);
    notifyListeners();
  }
}
