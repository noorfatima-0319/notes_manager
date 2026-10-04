import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../constants/app_routes.dart';

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
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: -20,
            child: Icon(Icons.eco_outlined,
                size: 140, color: colors.primary.withValues(alpha: 0.15)),
          ),
          Positioned(
            bottom: 40,
            right: -20,
            child: Icon(Icons.eco_outlined,
                size: 160, color: colors.primary.withValues(alpha: 0.12)),
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
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(Icons.edit_note, size: 46, color: colors.onPrimary),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700, color: colors.onSurface),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppConstants.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: colors.onSurface.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 32),
                  Container(width: 60, height: 3, color: colors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}