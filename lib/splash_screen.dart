import 'dart:math' as math;

import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;
  
  const SplashScreen({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _slideController;
  late AnimationController _numberController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _numberAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Fade animation controller
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Rotate animation controller
    _rotateController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Slide animation controller
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Number animation controller
    _numberController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Define animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _numberAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _numberController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    // Start fade animation
    _fadeController.forward();
    
    // Start scale animation after a short delay
    await Future.delayed(Duration(milliseconds: 300));
    _scaleController.forward();
    
    // Start rotate animation
    await Future.delayed(Duration(milliseconds: 200));
    _rotateController.forward();
    
    // Start slide animation
    await Future.delayed(Duration(milliseconds: 400));
    _slideController.forward();
    
    // Start number animation
    await Future.delayed(Duration(milliseconds: 300));
    _numberController.forward();
    
    // Complete splash screen after total duration
    await Future.delayed(Duration(milliseconds: 1500));
    widget.onAnimationComplete();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _slideController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF6F6F6),
              Color(0xFFFFFFFF),
              Color(0xFFFFF3E0),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background animated circles
            ...List.generate(5, (index) => _buildFloatingCircle(index, size)),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Calculator icon with animations
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _fadeAnimation,
                      _scaleAnimation,
                      _rotateAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _rotateAnimation.value * 0.1,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFB74D),
                                    Color(0xFFFF9800),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFF9800).withValues(alpha:0.3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.calculate_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 40),
                  
                  // App title with slide animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Calculator',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF222222),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Subtitle with delayed fade
               
                  SizedBox(height: 60),
                  
                  // Animated numbers
                  AnimatedBuilder(
                    animation: _numberAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _numberAnimation.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAnimatedNumber('1', 0),
                            SizedBox(width: 20),
                            _buildAnimatedNumber('+', 1),
                            SizedBox(width: 20),
                            _buildAnimatedNumber('1', 2),
                            SizedBox(width: 20),
                            _buildAnimatedNumber('=', 3),
                            SizedBox(width: 20),
                            _buildAnimatedNumber('∞', 4),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Loading indicator at bottom
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        // Animated dots loading indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedBuilder(
                              animation: _rotateController,
                              builder: (context, child) {
                                final delay = index * 0.3;
                                final animValue = (_rotateController.value + delay) % 1.0;
                                final scale = 0.8 + (0.4 * (0.5 + 0.5 * 
                                  math.sin(animValue * 2 * math.pi)));
                                
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8 * scale,
                                  height: 8 * scale,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF9800),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF999999),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedNumber(String number, int index) {
    return AnimatedBuilder(
      animation: _numberAnimation,
      builder: (context, child) {
        final delay = index * 0.1;
        final animValue = Curves.elasticOut.transform(
          math.max(0.0, (_numberAnimation.value - delay) / (1.0 - delay))
        );
        
        return Transform.scale(
          scale: animValue,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingCircle(int index, Size size) {
    final colors = [
      Color(0xFFFF9800).withValues(alpha:0.1),
      Color(0xFFFFB74D).withValues(alpha:0.08),
      Color(0xFFFFC107).withValues(alpha:0.06),
      Color(0xFFFFE082).withValues(alpha:0.04),
      Color(0xFFFFF3E0).withValues(alpha:0.03),
    ];
    
    final sizes = [80.0, 120.0, 60.0, 100.0, 40.0];
    final positions = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.1),
      Offset(size.width * 0.9, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.1),
    ];

    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        final offset = math.sin(_rotateController.value * 2 * math.pi + index) * 20;
        
        return Positioned(
          left: positions[index].dx + offset,
          top: positions[index].dy + offset * 0.5,
          child: Transform.scale(
            scale: 0.8 + 0.2 * math.sin(_rotateController.value * 2 * math.pi + index),
            child: Container(
              width: sizes[index],
              height: sizes[index],
              decoration: BoxDecoration(
                color: colors[index],
                borderRadius: BorderRadius.circular(sizes[index] / 2),
              ),
            ),
          ),
        );
      },
    );
  }
}

