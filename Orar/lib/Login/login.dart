// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:orar/Main/mainpage.dart';
import 'package:orar/Register%20Student/credentials.dart';
import 'package:orar/Structures/an.dart';
import 'package:orar/Structures/facultate.dart';
import 'package:orar/Structures/grupa.dart';
import 'package:orar/Structures/semigrupa.dart';
import 'package:orar/Structures/serie.dart';
import 'package:orar/account.dart';
import 'package:orar/custom_components.dart';

import '../file_handler.dart';
import '../links.dart';

class LoginStudent extends StatefulWidget {
  const LoginStudent({super.key});

  @override
  State<LoginStudent> createState() => _LoginStudentState();
}

class _LoginStudentState extends State<LoginStudent> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool validEmail = true;
  bool validPassword = true;
  int page = 0;
  bool noEmail = false;
  bool noPassword = false;
  bool authErr = false;

  bool loading = false;
  late AnimationController _animationController;

  String? _getEmailError() {
    String email = emailController.text;
    if (!EmailValidator.validate(email)) return "Your email is not valid";
    return null;
  }

  String? _getPasswordError() {
    String password = passwordController.text;
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#-_|;:$&*~]).{8,}$');
    if (!regex.hasMatch(password)) {
      return "• should contain at least one upper case\n• should contain at least one lower case\n• should contain at least one digit\n• should contain at least one Special character\n• Must be at least 8 characters in length";
    }
    return null;
  }

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
            pageBuilder: (context, animation1, animation2) => page == 0 ? const MainPage() : const CredentialsPage(),
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
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
              child: SafeArea(
                top: false,
                child: Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Login to your student account',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Expanded(child: Container()),
                            TextBox(
                              labelText: "Email",
                              controller: emailController,
                              error: !validEmail,
                              errorText: 'Your email or password is not correct',
                              onChanged: (value) => setState(() {
                                validEmail = value;
                              }),
                            ),
                            TextBox(
                              labelText: "Password",
                              controller: passwordController,
                              error: !validPassword,
                              isPassword: true,
                              errorText: "",
                              onChanged: (value) => setState(() {
                                validPassword = value;
                              }),
                            ),
                            Expanded(child: Container()),
                            Button(
                              function: () async {
                                validEmail = _getEmailError() == null;
                                validPassword = _getPasswordError() == null;
                                if (validEmail && validPassword) {
                                  var data = {
                                    'username': emailController.text,
                                    'password': passwordController.text,
                                  };
                                  setState(() {
                                    loading = true;
                                  });
                                  var response = await http.post(Uri.parse('${domain}login'), body: data);

                                  if (response.statusCode == 400) {
                                    setState(() {
                                      authErr = true;
                                      loading = false;
                                    });
                                  } else {
                                    var json = jsonDecode(response.body);
                                    String token = json['token'];
                                    Response res = await http.post(
                                      Uri.parse('${domain}get_account_info'),
                                      headers: {
                                        'Authorization': 'Token $token',
                                      },
                                    );
                                    var acc = jsonDecode(res.body);
                                    myAccount = Account(acc['email'], null, null);
                                    myAccount.semigrupa = Semigrupa(acc['semigrupa']['id'], acc['semigrupa']['nume'], acc['semigrupa']['grupa']);
                                    res = await http.get(
                                      Uri.parse('${domain}grupe/get/${acc['semigrupa']['grupa']}'),
                                    );
                                    acc = jsonDecode(res.body);
                                    myAccount.grupa = Grupa(acc['id'], acc['num'], acc['serie']);
                                    res = await http.get(
                                      Uri.parse('${domain}serii/get/${acc['serie']}'),
                                    );
                                    acc = jsonDecode(res.body);
                                    myAccount.serie = Serie(acc['id'], acc['nume'], acc['an']);
                                    res = await http.get(
                                      Uri.parse('${domain}ani/get/${acc['an']}'),
                                    );
                                    acc = jsonDecode(res.body);
                                    myAccount.an = An(acc['id'], acc['num'], acc['facultate']);
                                    res = await http.get(
                                      Uri.parse('${domain}facultati/get/${acc['facultate']}'),
                                    );
                                    acc = jsonDecode(res.body);
                                    myAccount.facultate = Facultate(acc['id'], acc['num'], acc['name']);

                                    myAccount.token = token;

                                    Directory dir = await FileHandler.getRoot();
                                    final String str = await rootBundle.loadString('assets/data.json');

                                    final data = await jsonDecode(str);

                                    data['token'] = token;
                                    data['email'] = myAccount.email;
                                    data['facultate']['id'] = myAccount.facultate.id;
                                    data['facultate']['num'] = myAccount.facultate.num;
                                    data['facultate']['name'] = myAccount.facultate.name;
                                    data['an']['id'] = myAccount.an.id;
                                    data['an']['num'] = myAccount.an.num;
                                    data['serie']['id'] = myAccount.serie.id;
                                    data['serie']['name'] = myAccount.serie.name;
                                    data['grupa']['id'] = myAccount.grupa.id;
                                    data['grupa']['num'] = myAccount.grupa.num;
                                    data['semigrupa']['id'] = myAccount.semigrupa.id;
                                    data['semigrupa']['num'] = myAccount.semigrupa.name;

                                    File file = File('${dir.path}/data.json');
                                    await file.writeAsString(jsonEncode(data));
                                    page = 0;
                                    _animationController.reverse();
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                } else {
                                  if (emailController.text == '') {
                                    setState(() {
                                      noEmail = true;
                                    });
                                  }
                                  if (passwordController.text == '') {
                                    setState(() {
                                      noPassword = true;
                                    });
                                    return;
                                  }
                                  setState(() {
                                    authErr = true;
                                  });
                                }
                              },
                              text: "Login",
                            ),
                            GestureDetector(
                              onTap: () {
                                page = 1;
                                _animationController.reverse();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5.0,
                                ),
                                child: SizedBox(
                                  child: Center(
                                    child: Text.rich(
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Don\'t have an account? ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'register',
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
                      ),
                      Transform.translate(
                        offset: loading ? const Offset(0, 0) : const Offset(1000, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, .5),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).highlightColor,
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
    );
  }
}
