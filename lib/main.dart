import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/notes_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

import 'constants/app_routes.dart';
import 'models/note_model.dart';
import 'screens/note_detail_screen.dart';
import 'screens/note_form_screen.dart';
import 'screens/notes_list_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesProvider()..load(),
      child: const NotesManagerApp(),
    ),
  );
}

class NotesManagerApp extends StatelessWidget {
  const NotesManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<NotesProvider>().isDarkMode;

    return MaterialApp(
      title: 'Notes Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.home: (_) => const NotesListScreen(),
        AppRoutes.search: (_) => const SearchScreen(),
        AppRoutes.addNote: (_) => const NoteFormScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.noteDetail:
            final noteId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => NoteDetailScreen(noteId: noteId),
              settings: settings,
            );
          case AppRoutes.editNote:
            final note = settings.arguments as Note;
            return MaterialPageRoute(
              builder: (_) => NoteFormScreen(note: note),
              settings: settings,
            );
        }
        return null;
      },

      builder: (context, child) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: child,
          ),
        ),
      ),
    );
  }
}
