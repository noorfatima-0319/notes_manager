import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/notes_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../constants/app_routes.dart';
class NoteDetailScreen extends StatelessWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});


  @override
  Widget build(BuildContext context) {
    final note = context.watch<NotesProvider>().noteById(noteId);
    if (note == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Note not found'),
        ),
      );
    }

    final theme = Theme.of(context);
    final color = CategoryStyle.color(note.category);
    final icon = CategoryStyle.icon(note.category);
    final dateText = DateFormat('MMM d, yyyy').format(note.updatedAt);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: AppColors.charcoal),
                    ),
                    const Spacer(),
                    Chip(label: Text(note.category.label)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              note.title,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                const SizedBox(width: 6),
                Text('Updated: $dateText', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, size: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                const SizedBox(width: 6),
                Text(
                  'Created: ${DateFormat('MMM d, yyyy').format(note.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(note.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.editNote, arguments: note);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      await ConfirmDialog.deleteNote(context, note);
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
