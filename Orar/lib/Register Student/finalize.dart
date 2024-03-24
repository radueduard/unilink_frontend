// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orar/account.dart';
import 'package:http/http.dart' as http;
import 'package:orar/Register%20Student/success.dart';
import 'package:orar/custom_components.dart';
import 'package:orar/links.dart';

import '../file_handler.dart';

class FinalizeRegistration extends StatefulWidget {
  final Account account;

  const FinalizeRegistration({super.key, required this.account});

  @override
  State<FinalizeRegistration> createState() => _FinalizeRegistrationState();
}

class _FinalizeRegistrationState extends State<FinalizeRegistration> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  double _offset = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.animateTo(
      1.0,
      duration: Duration.zero,
    );

    _animationController.addListener(() {
      if (_animationController.isDismissed) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const RegistrationSuccessPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        _animationController.animateTo(
          1.0,
          duration: Duration.zero,
        );
      }
    });

    _scrollController.addListener(() {
      setState(() {
        _offset = _scrollController.offset;
      });
    });
  }

  _getOpacity() {
    if (150.0 - 2.0 * _offset >= 150.0) {
      return 1.0;
    }
    if (150.0 - 2.0 * _offset <= 0.0) {
      return 0.0;
    }
    return (150.0 - 2.0 * _offset) / 150.0;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
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
            appBar: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width,
                210 - 2 * _offset > 0 ? 210 - 2 * _offset : 0,
              ),
              child: Center(
                child: Opacity(
                  opacity: _getOpacity(),
                  child: Text(
                    'Confirm',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Container(
                          height: 100,
                        ),
                        TextBox(
                          labelText: 'Email',
                          controller: null,
                          initialValue: widget.account.email,
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        TextBox(
                          labelText: 'Username',
                          controller: null,
                          initialValue: widget.account.email.split('@').first,
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        TextBox(
                          labelText: 'Password',
                          controller: null,
                          initialValue: widget.account.password!,
                          isPassword: true,
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        TextBox(
                          labelText: 'Facultatea',
                          controller: null,
                          initialValue: widget.account.facultate.toString(),
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        TextBox(
                          labelText: 'Anul',
                          controller: null,
                          initialValue: widget.account.an.toString(),
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        TextBox(
                          labelText: 'Seria',
                          controller: null,
                          initialValue: widget.account.serie.toString(),
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        TextBox(
                          labelText: 'Gruoa',
                          controller: null,
                          initialValue: widget.account.grupa.toString(),
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        TextBox(
                          labelText: 'Semigrupa',
                          controller: null,
                          initialValue: widget.account.semigrupa.toString(),
                          isReadOnly: true,
                          onChanged: (value) => true,
                        ),
                        Button(
                          text: "Create account",
                          function: () async {
                            setState(() {
                              isLoading = true;
                            });

                            var json = {
                              'email': widget.account.email,
                              'username': widget.account.email.split('@').first,
                              'password': widget.account.password,
                              'password_verify': widget.account.passwordVerify,
                              'semigrupa': widget.account.semigrupa.id,
                            };
                            var response = await http.post(
                              Uri.parse('${domain}student/register'),
                              body: json,
                            );
                            if (response.statusCode == 200) {
                              myAccount = widget.account;
                              String token = await jsonDecode(response.body)['token'];

                              myAccount.token = token;

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

                              Directory dir = await FileHandler.getRoot();
                              File file = File('${dir.path}/data.json');
                              await file.writeAsString(jsonEncode(data));

                              setState(() {
                                isLoading = false;
                              });

                              _animationController.reverse();
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            child: Center(
                              child: Text.rich(
                                TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    const TextSpan(
                                      text: 'I\'ve got something wrong. ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'go back',
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
                Transform.translate(
                  offset: isLoading ? const Offset(0, 0) : const Offset(1000, 0),
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
    );
  }
}
