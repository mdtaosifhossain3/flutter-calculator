import 'package:calculator/calculator_screen.dart';
import 'package:calculator/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? SplashScreen(onAnimationComplete: _onSplashComplete)
        : CalculatorScreen(); // Your existing calculator screen
  }
}

// Alternative: If you want to control splash duration manually
class TimedSplashWrapper extends StatefulWidget {
  const TimedSplashWrapper({super.key});

  @override
  State<TimedSplashWrapper> createState() => _TimedSplashWrapperState();
}

class _TimedSplashWrapperState extends State<TimedSplashWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() async {
    // Show splash for 3 seconds
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? SplashScreen(onAnimationComplete: () {})
        : CalculatorScreen();
  }
}