import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'account.dart';
import 'file_handler.dart';
import 'links.dart';

class NetService {
  static Future<String?> getJson(String url) {
    return http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    });
  }

  static Future<dynamic> updateOrar() async {
    Directory dir = await FileHandler.getRoot();
    dynamic localSchedule;
    try {
      localSchedule = await jsonDecode(await rootBundle.loadString('${dir.path}/schedule.json'));
    } catch (e) {
      localSchedule = await jsonDecode(await rootBundle.loadString('assets/schedule.json'));
    }
    dynamic localExclusions;
    try {
      localExclusions = await jsonDecode(await rootBundle.loadString('${dir.path}/excluded.json'));
    } catch (e) {
      localExclusions = await jsonDecode(await rootBundle.loadString('assets/excluded.json'));
    }

    for (var exclusion in localExclusions) {
      for (var saptamana in localSchedule['orar']) {
        for (var zi in saptamana['zile']) {
          for (var sch in zi['ore']) {
            if (sch['id'] == exclusion) {
              sch = {};
            }
          }
        }
      }
    }

    dynamic remoteSchedule;
    dynamic remoteExclusions;

    try {
      remoteSchedule = await jsonDecode((await http.get(
        Uri.parse('${domain}schedule/get_personal'),
        headers: {
          'Authorization': 'Token ${myAccount.token}',
        },
      ))
          .body);
      remoteExclusions = await jsonDecode((await http.get(
        Uri.parse(('${domain}schedule/exclude/get_personal')),
        headers: {
          'Authorization': 'Token ${myAccount.token}',
        },
      ))
          .body);
    } catch (e) {
      File sch = File('${dir.path}/schedule.json');
      File exc = File('${dir.path}/excluded.json');

      await sch.writeAsString(jsonEncode(localSchedule));
      await exc.writeAsString(jsonEncode(localExclusions));
      return localSchedule;
    }

    for (var zi in localSchedule['orar']) {
      for (var ore in zi['zile']) {
        ore['ore'] = [{}, {}, {}, {}, {}, {}];
      }
    }

    for (var schedule in remoteSchedule['cursuri']) {
      schedule['tip'] = 'curs';
      if (schedule['week'] == 0) {
        localSchedule['orar'][0]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
      if (schedule['week'] == 1) {
        localSchedule['orar'][1]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
      if (schedule['week'] == 2) {
        localSchedule['orar'][0]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
        localSchedule['orar'][1]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
    }

    for (var schedule in remoteSchedule['seminare']) {
      schedule['tip'] = 'seminar';
      if (schedule['week'] == 0) {
        localSchedule['orar'][0]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
      if (schedule['week'] == 1) {
        localSchedule['orar'][1]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
      if (schedule['week'] == 2) {
        localSchedule['orar'][0]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
        localSchedule['orar'][1]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
    }

    for (var schedule in remoteSchedule['laboratoare']) {
      schedule['tip'] = 'laborator';
      if (schedule['week'] == 0) {
        localSchedule['orar'][0]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
      if (schedule['week'] == 1) {
        localSchedule['orar'][1]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
      if (schedule['week'] == 2) {
        localSchedule['orar'][0]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
        localSchedule['orar'][1]['zile'][schedule['day']]['ore'][schedule['startingHour']] = schedule;
      }
    }

    localSchedule['exists'] = true;

    localExclusions = [];
    for (var exclusion in remoteExclusions) {
      localExclusions.add(exclusion['schedule']);
    }

    File sch = File('${dir.path}/schedule.json');
    File exc = File('${dir.path}/excluded.json');

    await sch.writeAsString(jsonEncode(localSchedule));
    await exc.writeAsString(jsonEncode(localExclusions));

    for (var exclusion in localExclusions) {
      for (var saptamana in localSchedule['orar']) {
        for (var zi in saptamana['zile']) {
          for (var sch in zi['ore']) {
            if (sch['id'] == exclusion) {
              zi['ore'][sch['startingHour']] = {};
            }
          }
        }
      }
    }

    return localSchedule;
  }

  static updateTeme() async {
    Directory dir = await FileHandler.getRoot();
    dynamic local;
    try {
      local = await jsonDecode(await rootBundle.loadString('${dir.path}/teme.json'));
    } catch (e) {
      local = await jsonDecode(await rootBundle.loadString('assets/teme.json'));
    }
    dynamic remote;
    try {
      remote = await jsonDecode((await http.get(
        Uri.parse('${domain}tema/get_personal'),
        headers: {
          'Authorization': 'Token ${myAccount.token}',
        },
      ))
          .body);
    } catch (e) {
      return local;
    }
    local['exists'] = true;
    local['teme'] = remote;

    File teme = File('${dir.path}/teme.json');

    await teme.writeAsString(jsonEncode(local));
    return local;
  }

  static updateExamene() async {
    Directory dir = await FileHandler.getRoot();
    dynamic local;
    try {
      local = await jsonDecode(await rootBundle.loadString('${dir.path}/examene.json'));
    } catch (e) {
      local = await jsonDecode(await rootBundle.loadString('assets/examene.json'));
    }
    dynamic remote;
    try {
      remote =
          await jsonDecode((await http.get(Uri.parse('${domain}examen/get_personal'), headers: {'Authorization': 'Token ${myAccount.token}'})).body);
    } catch (e) {
      return local;
    }
    local['exists'] = true;
    local['examene'] = remote;

    File exams = File('${dir.path}/examene.json');

    await exams.writeAsString(jsonEncode(local));
    return local;
  }

  static updateAnunturi() async {
    Directory dir = await FileHandler.getRoot();
    dynamic local;
    try {
      local = await jsonDecode(await rootBundle.loadString('${dir.path}/anunturi.json'));
    } catch (e) {
      local = await jsonDecode(await rootBundle.loadString('assets/anunturi.json'));
    }
    dynamic remote;
    try {
      remote = await jsonDecode(
          (await http.get(Uri.parse('${domain}notification/get_personal'), headers: {'Authorization': 'Token ${myAccount.token}'})).body);
    } catch (e) {
      return local;
    }
    local['exists'] = true;
    local['announcements'] = remote;

    File ann = File('${dir.path}/anunturi.json');

    await ann.writeAsString(jsonEncode(local));
    return local;
  }
}
