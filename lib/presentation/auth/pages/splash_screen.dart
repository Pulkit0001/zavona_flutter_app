import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zavona_flutter_app/core/router/route_names.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _fadeController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _backgroundFadeAnimation;
  late Animation<double> _topVectorSlideAnimation;
  late Animation<double> _bottomVectorSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _navigateToDashboardPage();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade controller for overall fade in
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // Background fade animation
    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Vector slide animations
    _topVectorSlideAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _bottomVectorSlideAnimation = Tween<double>(begin: -100.0, end: 0.0)
        .animate(
          CurvedAnimation(
            parent: _backgroundController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _startAnimations() {
    // Start fade in immediately
    _fadeController.forward();

    // Start background animations after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _backgroundController.forward();
      }
    });

    // Start logo animation after background starts
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _logoController.forward();
      }
    });
  }

  void _navigateToDashboardPage() {
    Future.delayed(const Duration(seconds: 3), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Navigate to the dashboard page after the delay
          context.go(RouteNames.dashboard);
        }
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _backgroundController,
          _fadeController,
        ]),
        builder: (context, child) {
          return Opacity(
            opacity: _backgroundFadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.45, 1.4],
                  colors: [
                    AppColors.secondaryDarkBlue,
                    Color(0xFF3D578D), // slightly lighter bottom
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated Logo in center
                  Center(
                    child: Transform.rotate(
                      angle: _logoRotationAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: Hero(
                            tag: 'app_logo',
                            child: Image.asset(
                              "assets/vectors/zavona.png",
                              height: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Animated Top-left circle
                  AnimatedBuilder(
                    animation: _topVectorSlideAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: -38 + _topVectorSlideAnimation.value,
                        left: -78 + _topVectorSlideAnimation.value,
                        child: Transform.scale(
                          scale: _backgroundFadeAnimation.value,
                          child: Opacity(
                            opacity: _backgroundFadeAnimation.value,
                            child: Image.asset(
                              "assets/vectors/blue_top_left_vector.png",
                              width: 300,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Animated Bottom-right circle
                  AnimatedBuilder(
                    animation: _bottomVectorSlideAnimation,
                    builder: (context, child) {
                      return Positioned(
                        bottom: -36 + _bottomVectorSlideAnimation.value,
                        right: -24 + _bottomVectorSlideAnimation.value,
                        child: Transform.scale(
                          scale: _backgroundFadeAnimation.value,
                          child: Opacity(
                            opacity: _backgroundFadeAnimation.value,
                            child: Image.asset(
                              "assets/vectors/blue_bottom_rigth_vector.png",
                              width: 315,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Animated loading indicator (optional)
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: Transform.scale(
                            scale: _logoFadeAnimation.value,
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
