// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:orar/Login/login.dart';
import 'package:orar/account.dart';
import 'package:orar/custom_components.dart';

import 'choosefacultate.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> with TickerProviderStateMixin {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;
  late bool validEmail;
  late bool validPassword;

  String? _getEmailError() {
    String email = emailController.text;
    String dom = email.split('@').last;
    if (!EmailValidator.validate(email)) return "Your email is not valid";
    if (!(RegExp(r'^stud.[A-Za-z]+.upb.ro$')).hasMatch(dom)) return "You have to use your school email";
    return null;
  }

  String? _getPasswordError() {
    String password = passwordController.text;
    String passwordVerify = passwordConfirmController.text;
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#-_|;:$&*~]).{8,}$');
    if (password != passwordVerify) {
      return "The passwords do not match";
    } else if (!regex.hasMatch(password)) {
      return "• should contain at least one upper case\n" +
          "• should contain at least one lower case\n" +
          "• should contain at least one digit\n" +
          "• should contain at least one Special character\n" +
          "• Must be at least 8 characters in length";
    }
    return null;
  }

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    validEmail = true;
    validPassword = true;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();

    _animationController.addListener(() {
      if (_animationController.isDismissed) {
        Navigator.of(context).popUntil((route) => false);
        _animationController.animateTo(
          1,
          duration: Duration.zero,
        );
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginStudent(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
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
          bottom: false,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Create your student account',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Expanded(flex: 3, child: Container()),
                        TextBox(
                          controller: emailController,
                          labelText: "Email",
                          error: !validEmail,
                          errorText: _getEmailError(),
                          isPassword: false,
                          onChanged: (value) => setState(() {
                            validEmail = value;
                          }),
                        ),
                        TextBox(
                          controller: passwordController,
                          labelText: "Password",
                          error: !validPassword,
                          errorText: _getPasswordError(),
                          isPassword: true,
                          onChanged: (value) => setState(() {
                            validPassword = value;
                          }),
                        ),
                        TextBox(
                          controller: passwordConfirmController,
                          labelText: "Verify Password",
                          error: !validPassword,
                          errorText: validPassword ? null : "",
                          isPassword: true,
                          onChanged: (value) => setState(() {
                            validPassword = value;
                          }),
                        ),
                        Expanded(flex: 3, child: Container()),
                        Button(
                          text: "Create account",
                          function: () {
                            String email = emailController.text;
                            String password = passwordController.text;
                            String passwordConfirm = passwordConfirmController.text;
                            setState(() {
                              validEmail = EmailValidator.validate(email) && _getEmailError() == null;
                              validPassword = password == passwordConfirm && _getPasswordError() == null;
                            });
                            if (validEmail && validPassword) {
                              Account account = Account(email, password, passwordConfirm);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChooseFacultate(account: account),
                                ),
                              );
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            _animationController.reverse();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
