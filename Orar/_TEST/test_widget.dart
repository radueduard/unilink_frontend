// // This code creates a widget that displays a circular progress indicator
// // with a 2 second animation.
// // The progress indicator is displayed in the center of the screen.
// // The progress indicator is displayed when the screen is first displayed.

// import 'package:flutter/material.dart';
// import 'package:orar/_TEST/donut_bar.dart';
// import 'package:orar/themes.dart';

// void main() {
//   runApp(const TestApp());
// }

// class TestApp extends StatelessWidget {
//   const TestApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Grade> grades = const [
//       Grade(name: "Fizica", value: .9),
//       Grade(name: "Sisteme de Operare", value: 1),
//       Grade(name: "Programare Orientata pe Obiecte", value: .001),
//       Grade(name: "Dispozitive Electronice si Electronica Analogica", value: .001),
//       Grade(name: "Analiza Algoritmilor", value: .001),
//       Grade(name: "Comunicare Tehnica in Limba Straina", value: 1),
//       Grade(name: "Educatie Fizica si Sport", value: 1),
//       Grade(name: "Informatica Aplicata 4", value: 1),
//     ];
//     return MaterialApp(
//       home: TestPage(
//         grades: grades,
//       ),
//       theme: lightTheme,
//       darkTheme: darkTheme,
//     );
//   }
// }

// class Grade {
//   const Grade({
//     required this.name,
//     required this.value,
//   });

//   final String name;
//   final double value;
// }

// String shortName(String name) {
//   if (name.length < 8) return name;
//   String shortName = '';
//   name.split(' ').forEach((element) {
//     if (element[0] == element[0].toUpperCase()) shortName = shortName + element[0];
//   });
//   return shortName;
// }

// class TestPage extends StatefulWidget {
//   const TestPage({Key? key, required this.grades}) : super(key: key);
//   final List<Grade> grades;

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Scaffold(
//           appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(200),
//             child: Center(
//               child: Text(
//                 'Orar',
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: GridView.builder(
//               itemCount: widget.grades.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: .75,
//                 crossAxisCount: 2,
//               ),
//               itemBuilder: (context, index) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.surface,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Column(
//                         children: [
//                           Expanded(child: Container()),
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: DonutChart(
//                               width: 100,
//                               height: 100,
//                               value: widget.grades[index].value,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Text(
//                               shortName(widget.grades[index].name),
//                               textAlign: TextAlign.center,
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                           ),
//                           Expanded(child: Container()),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
