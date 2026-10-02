import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/notes_provider.dart';
import '../widgets/category_chips.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/confirm_dialog.dart';
import 'note_detail_screen.dart';
import 'note_form_screen.dart';
import '../models/note_model.dart';

// A dedicated full-screen search, separate from the Home list filter,
// with its own text field and its own category chips.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String _category = 'All';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _delete(Note note) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Note?',
      message: 'Are you sure you want to delete this note? This action cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (confirmed) {
      await context.read<NotesProvider>().deleteNote(note);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    final results = provider.search(query: _query, category: _category);
    final isSearching = _query.trim().isNotEmpty || _category != 'All';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Search notes...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryChips(
              categories: AppConstants.filterCategories,
              selected: _category,
              onSelected: (category) => setState(() => _category = category),
            ),
            const SizedBox(height: 16),
            if (isSearching)
              Text(
                'Search Results (${results.length})',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: !isSearching
                  ? const EmptyState(
                      icon: Icons.search,
                      title: 'Search your notes',
                      subtitle: 'Type a keyword or choose a category to get started.',
                    )
                  : results.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off,
                          title: 'No matching notes',
                          subtitle: 'Try a different keyword or category.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: results.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final note = results[index];
                            return NoteCard(
                              note: note,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NoteDetailScreen(note: note)),
                                );
                              },
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NoteFormScreen(note: note)),
                                );
                              },
                              onDelete: () => _delete(note),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
