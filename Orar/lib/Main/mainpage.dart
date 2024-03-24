import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orar/Main/exampage.dart';
import 'package:orar/Main/examtile.dart';
import 'package:orar/Main/schedtile.dart';
import 'package:orar/Main/schedule.dart';
import 'package:orar/Main/tematile.dart';
import 'package:orar/Main/temepage.dart';
import 'package:orar/account.dart';
import 'package:orar/file_handler.dart';
import 'package:orar/netservice.dart';
import 'package:orar/welcome.dart';

import '../custom_components.dart';
import 'announcementtile.dart';

DateTime initialTime = DateTime(2022, 10, 3);

String toName(String username) {
  String rez = '';
  List<String> names = username.split(RegExp(r"[_.]"));
  for (String name in names) {
    rez = rez + name.replaceFirst(name[0], name[0].toUpperCase());
    rez = '$rez ';
  }
  rez = rez.substring(0, rez.length - 1);
  return rez;
}

int getWeekType() {
  DateTime now = DateTime.now();
  int days = now.difference(initialTime).inDays;
  return (days / 7).floor() % 2;
}

int getDayOfWeek() {
  int day = DateTime.now().weekday;
  return day;
}

int timeToHour() {
  int hour = DateTime.now().hour;
  if (hour < 8) {
    return 0;
  }
  if (hour > 18) {
    return 6;
  } else {
    return ((hour - 8) / 2).floor();
  }
}

getNextMaterie(var orar) {
  int week = getWeekType();
  int day = getDayOfWeek() - 1;
  int hour = timeToHour();

  if (day == 5 || day == 6) {
    day = 0;
    hour = 0;
    week = (week + 1) % 2;
  } else if (hour == 6 && day == 4) {
    week = (week + 1) % 2;
    day = 0;
    hour = 0;
  } else if (hour == 6) {
    day++;
    hour = 0;
  }

  dynamic nextMaterie;
  while ((nextMaterie = orar['orar'][week]['zile'][day]['ore'][hour]).toString() == {}.toString()) {
    hour++;
    if (hour == 6) {
      if (day == 4) {
        week = (week + 1) % 2;
        day = 0;
        hour = 0;
      } else {
        day++;
        hour = 0;
      }
    }
  }
  return nextMaterie;
}

getSoonestTema(var teme) {
  List<dynamic> temas = teme['teme'];
  temas.sort((a, b) => DateTime.parse(a['due_date']).compareTo(DateTime.parse(b['due_date'])));
  for (var t in temas) {
    if (DateTime.parse(t['due_date']).isAfter(DateTime.now())) return t;
  }
  return null;
}

getSoonestExam(var exam) {
  List<dynamic> exams = exam['examene'];
  exams.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
  for (var e in exams) {
    if (DateTime.parse(e['date']).isAfter(DateTime.now())) return e;
  }
  return null;
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late dynamic orar;
  late dynamic teme;
  late dynamic anunturi;
  late dynamic examene;

  late AnimationController _animationController;

  bool init = false;
  Future<dynamic> getData() async {
    if (!init) {
      init = true;
      Directory dir = await FileHandler.getRoot();
      try {
        orar = await jsonDecode(await rootBundle.loadString('${dir.path}/schedule.json'));
        teme = await jsonDecode(await rootBundle.loadString('${dir.path}/teme.json'));
        examene = await jsonDecode(await rootBundle.loadString('${dir.path}/examene.json'));
        anunturi = await jsonDecode(await rootBundle.loadString('${dir.path}/anunturi.json'));
      } catch (e) {
        orar = await NetService.updateOrar();
        teme = await NetService.updateTeme();
        examene = await NetService.updateExamene();
        anunturi = await NetService.updateAnunturi();
      }
    } else {
      orar = await NetService.updateOrar();
      teme = await NetService.updateTeme();
      examene = await NetService.updateExamene();
      anunturi = await NetService.updateAnunturi();
    }
    dynamic data = {
      'orar': orar,
      'teme': teme,
      'examene': examene,
      'announcements': anunturi,
    };
    return data;
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
            pageBuilder: (context, animation1, animation2) => const WelcomePage(),
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
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).highlightColor,
                        Theme.of(context).highlightColor,
                        Theme.of(context).highlightColor,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            backgroundColor: Theme.of(context).shadowColor,
            color: Theme.of(context).highlightColor,
            onRefresh: () async {
              setState(() {});
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: FutureBuilder(
                future: getData(),
                builder: ((context, snapshot) {
                  if (snapshot.data != null) {
                    var nextMaterie = getNextMaterie(snapshot.data['orar']);
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 30,
                            top: 10.0,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome,\n',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text: toName(myAccount.email.split('@').first),
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: <Color>[
                                          Theme.of(context).highlightColor,
                                          Theme.of(context).shadowColor,
                                        ],
                                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 500.0, 100.0)),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                            left: 30,
                            right: 20,
                          ),
                          child: SizedBox(
                            width: 500,
                            child: Text(
                              'Next up:',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => ScheduleView(
                                      orar: snapshot.data['orar'],
                                    )),
                              ),
                            );
                          },
                          child: Hero(
                              tag: "next",
                              child: Material(
                                type: MaterialType.transparency,
                                child: ScheduleTile(
                                  materia: nextMaterie,
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 30,
                            right: 20,
                          ),
                          child: SizedBox(
                            width: 500,
                            child: Text(
                              'Due soon:',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                        Hero(
                          tag: "nextAssignment",
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: ((context) => TemePage(
                                        teme: snapshot.data['teme'],
                                      )),
                                ),
                              );
                            },
                            child: TemaTile(
                              tema: getSoonestTema(snapshot.data['teme']),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 30,
                            right: 20,
                          ),
                          child: SizedBox(
                            width: 500,
                            child: Text(
                              'Next exam:',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => ExamPage(
                                      exams: snapshot.data['examene'],
                                    )),
                              ),
                            );
                          },
                          child: Hero(
                            tag: "nextExam",
                            child: Material(
                              type: MaterialType.transparency,
                              child: ExamTile(
                                exam: getSoonestExam(snapshot.data['examene']),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 30,
                            right: 20,
                          ),
                          child: SizedBox(
                            width: 500,
                            child: Text(
                              'Announcements:',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: snapshot.data['announcements']['announcements']['cursuri'].length +
                                      snapshot.data['announcements']['announcements']['seminare'].length +
                                      snapshot.data['announcements']['announcements']['laboratoare'].length ==
                                  0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Container(
                                    height: 95,
                                    width: 900,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(15, 255, 255, 255),
                                          Color.fromARGB(40, 255, 255, 255),
                                        ],
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).shadowColor,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No announcements lately...",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data['announcements']['announcements']['cursuri'].length,
                                itemBuilder: ((context, index) {
                                  return AnnouncementTile(
                                      announcement: snapshot.data['announcements']['announcements']['cursuri'][index], type: 'course');
                                }),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data['announcements']['announcements']['seminare'].length,
                                itemBuilder: ((context, index) {
                                  return AnnouncementTile(
                                      announcement: snapshot.data['announcements']['announcements']['seminare'][index], type: 'seminar');
                                }),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data['announcements']['announcements']['laboratoare'].length,
                                itemBuilder: ((context, index) {
                                  return AnnouncementTile(
                                      announcement: snapshot.data['announcements']['announcements']['laboratoare'][index], type: 'lab');
                                }),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Button(
                            text: "Logout",
                            function: () async {
                              final String str = await rootBundle.loadString('assets/data.json');
                              final data = await jsonDecode(str);

                              data['token'] = null;
                              data['email'] = null;
                              data['facultate']['id'] = null;
                              data['facultate']['num'] = null;
                              data['facultate']['name'] = null;
                              data['an']['id'] = null;
                              data['an']['num'] = null;
                              data['serie']['id'] = null;
                              data['serie']['name'] = null;
                              data['grupa']['id'] = null;
                              data['grupa']['num'] = null;
                              data['semigrupa']['id'] = null;
                              data['semigrupa']['num'] = null;
                              logedIn = false;

                              Directory dir = await FileHandler.getRoot();
                              File file = File('${dir.path}/data.json');
                              final String template = await rootBundle.loadString('assets/data.json');
                              await file.writeAsString(template);
                              _animationController.reverse();
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).highlightColor,
                      ),
                    );
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
