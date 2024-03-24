// import 'dart:math';

// import 'package:flutter/material.dart';

// class DonutChart extends StatefulWidget {
//   /// Creates a widget that displays a donut chart.
//   ///
//   /// The [width] and [height] arguments must not be null.
//   const DonutChart({
//     super.key,
//     required this.width,
//     required this.height,
//     required this.value,
//   });

//   /// The width of the chart.
//   final double width;

//   /// The height of the chart.
//   final double height;

//   /// The value to display on the chart.
//   final double value;

//   @override
//   State<DonutChart> createState() => _DonutChartState();
// }

// class _DonutChartState extends State<DonutChart> with TickerProviderStateMixin {
//   late final AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: widget.width,
//         height: widget.height,
//         child: AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return Transform.rotate(
//               angle: -pi / 2,
//               child: CustomPaint(
//                 painter: DCPainter(
//                   value: _animationController.value * widget.value,
//                 ),
//                 //painter: FacePainter(),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // Draw a circular progress indicator with a gradient and a blur
// // The gradient interpolates between red and green, and the blur
// // is applied to the entire indicator. The blur is created by
// // drawing the indicator twice, once with a blur applied.

// class DCPainter extends CustomPainter {
//   final double value;

//   const DCPainter({required this.value});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Create a rect that fills the canvas
//     final Rect rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));

//     // Create a paint object with the desired color and blur
//     final Paint paint = Paint()
//       ..isAntiAlias = true
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = (sqrt((pow(size.width, 2) + pow(size.height, 2))) / sqrt2 / 5)
//       ..color = Colors.teal
//       ..shader = LinearGradient(
//         colors: [
//           ColorTween(
//             begin: const Color.fromARGB(255, 140, 0, 0),
//             end: const Color.fromARGB(255, 0, 140, 0),
//           ).lerp(value.clamp(0, 1))!,
//           ColorTween(
//             begin: const Color.fromARGB(255, 210, 0, 0),
//             end: const Color.fromARGB(255, 0, 210, 0),
//           ).lerp(value.clamp(0, 1))!,
//         ],
//       ).createShader(rect);

//     // Draw an arc with the given paint
//     canvas.drawArc(
//       rect,
//       0,
//       value.clamp(0, 1) * 2 * pi,
//       false,
//       paint,
//     );

//     // Draw a second arc with the same paint, but with a blur
//     canvas.drawArc(
//       rect,
//       0,
//       2 * pi,
//       false,
//       paint..maskFilter = MaskFilter.blur(BlurStyle.outer, size.height / 15),
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
