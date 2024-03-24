import 'package:flutter/material.dart';

class TemaTile extends StatelessWidget {
  final dynamic tema;

  const TemaTile({super.key, required this.tema});

  @override
  Widget build(BuildContext context) {
    if (tema == null) {
      return Padding(
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
              "You have no assignments scheduled\nfor this semmester",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tema['title'] + ' - ' + tema['curs']['nume'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Due: ${tema['due_date'].toString().replaceAll('T', ' at ').replaceAll('Z', '')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
