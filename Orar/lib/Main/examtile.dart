import 'package:flutter/material.dart';

class ExamTile extends StatelessWidget {
  final dynamic exam;

  const ExamTile({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    if (exam == null) {
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
          child: const Center(
            child: Text(
              "No exam has been scheduled yet",
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
        height: 100,
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
                '${exam['curs']['nume']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Date: ${exam['date'].toString().replaceAll('T', ' at ').replaceAll('Z', '')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
