import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A), // dark navy top
              Color(0xFF1B263B), // slightly lighter bottom
            ],
          ),
        ),
        child: Stack(
          children: [
            // Top-left circle
            Positioned(
              top: -80,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1B263B), // faint circle
                ),
              ),
            ),
            // Bottom-right circle
            Positioned(
              bottom: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1B263B),
                ),
              ),
            ),

            // Center Logo
            Center(child: Image.asset("assets/Vector.png")),
          ],
        ),
      ),
    );
  }
}
