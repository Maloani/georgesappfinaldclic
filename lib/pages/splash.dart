// pages/splash.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'connexion.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    // Animation du logo
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Timer avant d'aller à la connexion
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0066FF), Color(0xFF0033AA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/img/login.jpeg",
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "MS SOLUTIONS LAB",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Loading...",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
