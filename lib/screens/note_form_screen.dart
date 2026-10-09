import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/confirm_dialog.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';


class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({super.key, this.note});

  bool get isEditing => note != null;

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late NoteCategory _category;

  static const _titleMax = 100;
  static const _contentMax = 2000;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _category = widget.note?.category ?? NoteCategory.personal;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Title is required';
    if (text.length < 3) return 'Title must be at least 3 characters';
    return null;
  }

  String? _validateContent(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Content cannot be empty';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<NotesProvider>();
    if (widget.isEditing) {
      await provider.updateNote(widget.note!, title: _titleController.text,
          content: _contentController.text, category: _category);
    } else {
      await provider.addNote(title: _titleController.text,
          content: _contentController.text, category: _category);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEditing ? 'Note updated' : 'Note saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final hasChanges = _titleController.text.trim().isNotEmpty ||
            _contentController.text.trim().isNotEmpty;
        if (!hasChanges) {
          if (context.mounted) Navigator.pop(context);
          return;
        }
        final leave = await ConfirmDialog.show(
          context,
          title: 'Discard changes?',
          message: 'You have unsaved changes. Are you sure you want to leave?',
          confirmLabel: 'Discard',
        );
        if (leave && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Note' : 'Add Note')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel(context, 'Title'),
              TextFormField(
                controller: _titleController,
                maxLength: _titleMax,
                validator: _validateTitle,
                decoration: const InputDecoration(hintText: 'Enter note title'),
              ),
              const SizedBox(height: 12),
              _fieldLabel(context, 'Content'),
              TextFormField(
                controller: _contentController,
                maxLength: _contentMax,
                maxLines: 8,
                validator: _validateContent,
                decoration: const InputDecoration(hintText: 'Write your note here...'),
              ),
              const SizedBox(height: 12),
              _fieldLabel(context, 'Category'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: NoteCategory.values.map((category) {
                  final isSelected = category == _category;
                  return ChoiceChip(
                    label: Text(category.label),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _category = category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _save,
                  child: Text(widget.isEditing ? 'Update Note' : 'Save Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          children: [TextSpan(text: ' *', style: TextStyle(color: Theme.of(context).colorScheme.error))],
        ),
      ),
    );
  }
}
