import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orar/account.dart';
import 'package:orar/themes.dart';
import 'Main/mainpage.dart';
import 'welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAccount(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: !logedIn ? const WelcomePage() : const MainPage(),
          );
        } else {
          return const CircularProgressIndicator(
            color: Colors.black,
          );
        }
      },
    );
  }
}
