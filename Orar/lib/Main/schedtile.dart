import 'package:flutter/material.dart';

import 'mainpage.dart';

getMaterieName(var orar) {
  if (orar['tip'] == 'curs') {
    return orar['curs']['nume'];
  }
  if (orar['tip'] == 'seminar') {
    return orar['seminar']['nume'];
  }
  if (orar['tip'] == 'laborator') {
    return orar['laborator']['nume'];
  }
}

getProfesorName(var orar) {
  if (orar['tip'] == 'curs') {
    return orar['curs']['profesor']['username'];
  } else if (orar['tip'] == 'seminar') {
    return orar['seminar']['seminarist']['username'];
  } else {
    return orar['laborator']['asistent']['username'];
  }
}

class ScheduleTile extends StatelessWidget {
  final dynamic materia;

  const ScheduleTile({super.key, required this.materia});

  @override
  Widget build(BuildContext context) {
    if (materia.toString() == {}.toString()) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 20,
          right: 20,
        ),
        child: Container(
          height: 90,
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
              'Fereastra',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: Container(
        height: 90,
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
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        '${materia['startingHour'] * 2 + 8}:00',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${materia['startingHour'] * 2 + 9}:50',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,

                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Text(
                      '${getMaterieName(materia)}',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      toName(getProfesorName(materia)),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Stack(
                        children: [
                          Text(
                            materia['tip'].toString().characters.first.toUpperCase(),
                            style: TextStyle(
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1.5
                                ..color = Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                            ),
                          ),
                          // Text(
                          //   materia['tip'].toString().characters.first.toUpperCase(),
                          //   style: TextStyle(
                          //     foreground: Paint()
                          //       ..style = PaintingStyle.fill
                          //       ..color = getC(materia['tip']),
                          //     fontWeight: FontWeight.w900,
                          //     fontSize: 30,
                          //   ),
                          // ),
                        ],
                      ),
                      Text(
                        '${materia['sala']['cladire']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(materia['sala']['num'].toString().padLeft(3, '0')),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
