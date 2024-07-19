import 'package:flutter/material.dart';
import 'package:imtihon_4_oy1/screens/entering_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isBig = false;
  bool isBright = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToNextPage();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isBig = !isBig;
        isBright = !isBright;
      });
    });
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isBig = !isBig;
        isBright = !isBright;
      });
    });
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: isBig ? 1.2 : 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: isBig ? 200 : 100,
                  height: isBig ? 200 : 100,
                  child: TweenAnimationBuilder<Color?>(
                    tween: ColorTween(
                      begin: Colors.white,
                      end: isBright ? Colors.white : Colors.white,
                    ),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, color, child) {
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          color ?? Colors.white,
                          BlendMode.modulate,
                        ),
                        child: child,
                      );
                    },
                    child: child,
                  ),
                ),
              );
            },
            onEnd: () {
              setState(() {
                isBig = !isBig;
                isBright = !isBright;
              });
            },
            child: Image.asset(
              "assets/imtihon_logo_javohir.png",
              width: 300.0,
              height: 300.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
