import 'package:flutter/material.dart';
import '../models/note_model.dart';

class CategoryChips extends StatelessWidget {
  final NoteCategory? selected; // null = "All"
  final ValueChanged<NoteCategory?> onSelected;

  const CategoryChips({super.key, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    // "All" plus every enum value
    final items = <NoteCategory?>[null, ...NoteCategory.values];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = items[index];
          final label = category == null ? 'All' : category.label;
          final isSelected = category == selected;
          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}