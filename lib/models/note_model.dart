enum NoteCategory { personal, work, study, other }

extension NoteCategoryLabel on NoteCategory {
  String get label {
    switch (this) {
      case NoteCategory.personal: return 'Personal';
      case NoteCategory.work: return 'Work';
      case NoteCategory.study: return 'Study';
      case NoteCategory.other: return 'Other';
    }
  }
}

class Note {
  final String id;
  final String title;
  final String content;
  final NoteCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({String? title, String? content, NoteCategory? category, DateTime? updatedAt}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'category': category.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    category: NoteCategory.values.firstWhere(
          (c) => c.name == json['category'],
      orElse: () => NoteCategory.personal,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

enum SortOrder { newest, oldest, titleAZ }