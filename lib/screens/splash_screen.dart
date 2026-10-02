import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import 'notes_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _visible = true);
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.iris,
      body: Stack(
        children: [
          // faint decorative leaf icons in the corners
          Positioned(
            top: 40,
            left: -20,
            child: Icon(Icons.eco_outlined, size: 140, color: AppColors.mist.withValues(alpha: 0.3)),
          ),
          Positioned(
            bottom: 40,
            right: -20,
            child: Icon(Icons.eco_outlined, size: 160, color: AppColors.mist.withValues(alpha: 0.25)),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(Icons.edit_note, size: 46, color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.mist),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppConstants.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.cream.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 32),
                  Container(width: 60, height: 3, color: AppColors.mist),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
