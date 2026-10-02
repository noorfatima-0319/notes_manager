import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';
import '../widgets/category_chips.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';
import 'note_form_screen.dart';
import 'search_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  Future<void> _delete(BuildContext context, Note note) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Note?',
      message: 'Are you sure you want to delete this note? This action cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (confirmed) {
      await context.read<NotesProvider>().deleteNote(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final notes = provider.filteredNotes;
    final hasAnyNotes = provider.allNotes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'theme') {
                context.read<NotesProvider>().toggleDarkMode(!isDark);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(isDark ? 'Light Mode' : 'Dark Mode'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteFormScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text('Keep your thoughts organized', style: theme.textTheme.bodyMedium),
          ),
          // tapping opens the dedicated Search screen
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CategoryChips(
              categories: AppConstants.filterCategories,
              selected: provider.categoryFilter,
              onSelected: (category) => context.read<NotesProvider>().setCategoryFilter(category),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: !hasAnyNotes
                ? const EmptyState(
                      icon: Icons.note_add_outlined,
                      title: 'No notes yet',
                      subtitle:
                          'Tap the + button to create your first note and start organizing your thoughts.',
                    )
                : notes.isEmpty
                    ? const EmptyState(
                        icon: Icons.filter_list_off,
                        title: 'No notes in this category',
                        subtitle: 'Try a different category or add a new note.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                        itemCount: notes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return NoteCard(
                            note: note,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
                              );
                            },
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => NoteFormScreen(note: note)),
                              );
                            },
                            onDelete: () => _delete(context, note),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
