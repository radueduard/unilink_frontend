import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:orar/Structures/an.dart';
import 'package:orar/Structures/facultate.dart';
import 'package:orar/Structures/grupa.dart';
import 'package:orar/Structures/semigrupa.dart';
import 'package:orar/Structures/serie.dart';
import 'package:orar/file_handler.dart';

late bool logedIn;

class Account {
  String email;
  late String token;
  String? password;
  String? passwordVerify;
  late Facultate facultate;
  late An an;
  late Serie serie;
  late Grupa grupa;
  late Semigrupa semigrupa;

  Account(this.email, this.password, this.passwordVerify);
}

late Account myAccount;

Future<bool> getAccount() async {
  Directory dir = await FileHandler.getRoot();
  File file = File('${dir.path}/data.json');
  final String response;
  try {
    response = await rootBundle.loadString('${dir.path}/data.json');
  } catch (e) {
    await file.writeAsString(await rootBundle.loadString('assets/data.json'));
    logedIn = false;
    return logedIn;
  }
  final data = await jsonDecode(response);
  if (data['token'] == null) {
    logedIn = false;
  } else {
    myAccount = Account(data['email'], null, null);
    myAccount.token = data['token'];
    myAccount.facultate = Facultate(data['facultate']['id'], data['facultate']['num'], data['facultate']['name']);
    myAccount.an = An(data['an']['id'], data['an']['num'], data['facultate']['id']);
    myAccount.serie = Serie(data['serie']['id'], data['serie']['name'], data['an']['id']);
    myAccount.grupa = Grupa(data['grupa']['id'], data['grupa']['num'], data['serie']['id']);
    myAccount.semigrupa = Semigrupa(data['semigrupa']['id'], data['semigrupa']['num'], data['grupa']['id']);
    logedIn = true;
  }
  return logedIn;
}
