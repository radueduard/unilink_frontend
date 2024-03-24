// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:orar/Login/login.dart';
import 'package:orar/Register%20Student/credentials.dart';
import 'package:orar/custom_components.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();

    _animationController.addListener(() {
      if (_animationController.isDismissed) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => page == 0 ? const CredentialsPage() : const LoginStudent(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        _animationController.animateTo(
          0,
          duration: Duration.zero,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              Transform.scale(
                origin: const Offset(0, -200),
                scale: 6.0 - 6.0 * _animationController.value,
                child: Container(
                  height: 430,
                  width: 430,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(400.0),
                    color: Theme.of(context).highlightColor,
                  ),
                ),
              ),
            ],
          );
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.titleLarge,
                          children: [
                            const TextSpan(
                              text: 'Welcome to ',
                            ),
                            TextSpan(
                              text: 'UniLink!',
                              style: TextStyle(
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: <Color>[
                                      Theme.of(context).colorScheme.onPrimary,
                                      Theme.of(context).highlightColor,
                                    ],
                                  ).createShader(
                                    Rect.fromPoints(
                                      const Offset(100, 200),
                                      const Offset(300, 700),
                                    ),
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    const Center(
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/ro/thumb/5/51/Logo_Universitatea_Politehnica_din_București.svg/360px-Logo_Universitatea_Politehnica_din_București.svg.png?20221104041826',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Button(
                      text: "Create account",
                      function: () {
                        page = 0;
                        _animationController.reverse();
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        page = 1;
                        _animationController.reverse();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          bottom: 20.0,
                        ),
                        child: SizedBox(
                          child: Center(
                            child: Text.rich(
                              style: Theme.of(context).textTheme.bodyMedium,
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'login',
                                    style: TextStyle(
                                      color: Theme.of(context).highlightColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
