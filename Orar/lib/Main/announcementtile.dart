import 'package:flutter/material.dart';

import 'mainpage.dart';

class AnnouncementTile extends StatelessWidget {
  final dynamic announcement;
  final String type;

  const AnnouncementTile({super.key, required this.announcement, required this.type});

  @override
  Widget build(BuildContext context) {
    String owner = 'profesor';
    if (type == 'seminar') {
      owner = 'seminarist';
    } else if (type == 'lab') {
      owner = 'asistent';
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: Container(
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
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 13),
              children: [
                TextSpan(
                  text: toName('${announcement['sender'][owner]['username']}'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const TextSpan(
                  text: ' in ',
                ),
                TextSpan(
                  text: '${announcement['sender']['nume']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const TextSpan(
                  text: ':\n',
                ),
                TextSpan(
                  text: '${announcement['mesaj']}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
