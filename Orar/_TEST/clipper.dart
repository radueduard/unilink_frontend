// import 'dart:ui';

// import 'package:flutter/material.dart';

// class Clipper extends CustomClipper<Path> {
//   double value;

//   Clipper(this.value);

//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0.0, size.height);
//     Offset off1 = Offset(size.width / 6 + value * size.width / 6, size.height * .75 + value * size.height * .25);
//     path.quadraticBezierTo(off1.dx, off1.dy, size.width * .5, size.height * .75);
//     Offset off2 = Offset(5 * size.width / 6 - value * size.width / 6, size.height * .75 - value * size.height * .25);
//     path.quadraticBezierTo(off2.dx, off2.dy, size.width, size.height * .5);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }

// class TestPainter extends CustomPainter {
//   double value;

//   TestPainter(this.value);

//   @override
//   void paint(Canvas canvas, Size size) {
//     var path = Path();
//     path.lineTo(0.0, size.height);
//     Offset off1 = Offset(size.width / 6 + value * size.width / 6, size.height * .75 + value * size.height * .25);
//     path.quadraticBezierTo(off1.dx, off1.dy, size.width * .5, size.height * .75);
//     Offset off2 = Offset(5 * size.width / 6 - value * size.width / 6, size.height * .75 - value * size.height * .25);
//     path.quadraticBezierTo(off2.dx, off2.dy, size.width, size.height * .5);
//     path.lineTo(size.width, 0);
//     path.close();

//     Paint paint = Paint()
//       ..color = Colors.red
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5.0;

//     canvas.drawPath(path, paint);
//     canvas.drawPoints(PointMode.points, [off1, off2], paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// void main() {
//   runApp(const ClipApp());
// }

// class ClipApp extends StatefulWidget {
//   const ClipApp({super.key});

//   @override
//   State<ClipApp> createState() => _ClipAppState();
// }

// class _ClipAppState extends State<ClipApp> with SingleTickerProviderStateMixin {
//   late final AnimationController _ac;

//   @override
//   void initState() {
//     super.initState();
//     _ac = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _ac.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           // child: SizedBox(
//           //   width: 300,
//           //   height: 300,
//           //   child: CustomPaint(
//           //     painter: TestPainter(0.0),
//           //   ),
//           // ),

//           child: AnimatedBuilder(
//             animation: _ac,
//             builder: (BuildContext context, Widget? child) {
//               return ClipPath(
//                 clipper: Clipper(_ac.value),
//                 child: Image.asset('assets/darkPattern.png', fit: BoxFit.fitWidth),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
