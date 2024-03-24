import 'package:flutter/material.dart';
import 'package:orar/Main/mainpage.dart';
import 'package:orar/custom_components.dart';

class RegistrationSuccessPage extends StatefulWidget {
  const RegistrationSuccessPage({super.key});

  @override
  State<RegistrationSuccessPage> createState() => _RegistrationSuccessPageState();
}

class _RegistrationSuccessPageState extends State<RegistrationSuccessPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;

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
        Navigator.of(context).popUntil((route) => false);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const MainPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            children: [
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Your account was succesfully created!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Button(
                function: () {
                  _animationController.reverse();
                },
                text: "Start using app",
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
