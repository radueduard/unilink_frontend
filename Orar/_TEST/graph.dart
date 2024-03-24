// import 'dart:ui';

// import 'package:flutter/material.dart';

// class MyCurve extends Curve {
//   final List<Offset> points;
//   late final List<double> integrale;

//   MyCurve({required this.points}) {
//     // initialize integrale to empty list
//     integrale = [];
//     // initialize accumulator to 0.0
//     double acc = 0.0;
//     // iterate over points
//     for (int i = 0; i < points.length; i++) {
//       // add dy to accumulator
//       acc += points[i].dy;
//       // add current accumulator value to integrale
//       integrale.add(acc);
//     }
//     // normalize integrale
//     for (int i = 0; i < points.length; i++) {
//       integrale[i] /= integrale[integrale.length - 1];
//     }
//   }

//   @override
//   double transformInternal(double t) {
//     int index = (t * integrale.length).toInt();
//     if (index == integrale.length) index--;
//     return integrale[index];
//   }
// }

// class Graph extends StatefulWidget {
//   final List<Color> colors;
//   final List<double> values;
//   final double width;
//   final double height;
//   const Graph({Key? key, required this.values, required this.width, required this.height, this.colors = const [Colors.white, Colors.black]})
//       : super(key: key);

//   @override
//   State<Graph> createState() => _GraphState();
// }

// class _GraphState extends State<Graph> with TickerProviderStateMixin {
//   late final AnimationController _animationController;
//   late List<Offset> points;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..forward();

//     points = [];
//     for (int i = 0; i < widget.values.length; i++) {
//       points.add(
//         Offset(
//           i * (widget.width / (widget.values.length - 1)),
//           (1 - widget.values[i]) * widget.height,
//         ),
//       );
//     }
//     CatmullRomSpline spline = CatmullRomSpline(points);
//     List<Offset> samples = [];
//     for (double d = .0; d < 1.0; d += .001) {
//       samples.add(spline.transformInternal(d));
//     }
//     points = samples;
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Curve curve = MyCurve(
//       points: points,
//     );

//     Animation animation = CurvedAnimation(parent: _animationController, curve: curve);

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: AnimatedBuilder(
//         animation: animation,
//         builder: (context, child) {
//           return Stack(
//             children: [
//               Row(
//                 children: [
//                   Expanded(child: Container()),
//                   SizedBox(
//                     height: widget.height,
//                     width: widget.width,
//                     child: CustomPaint(
//                       painter: GraphPainter(
//                         context,
//                         highlightPoints: widget.values
//                             .map((e) =>
//                                 Offset((widget.values.indexOf(e) * widget.width / (widget.values.length - 1)).toDouble(), (1 - e) * widget.height))
//                             .toList(),
//                         points: points.sublist(0, (animation.value * points.length).toInt()),
//                         value: animation.value,
//                         colors: widget.colors,
//                       ),
//                     ),
//                   ),
//                   Expanded(child: Container()),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// /// Draws the graph path and the points for the graph

// class GraphPainter extends CustomPainter {
//   BuildContext context;
//   List<Offset> highlightPoints;
//   final List<Color> colors;
//   final List<Offset> points;
//   final double value;

//   GraphPainter(this.context, {required this.points, required this.value, this.highlightPoints = const [], required this.colors});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 10
//       ..shader = LinearGradient(
//         colors: colors.map((e) => e.withAlpha(150)).toList(),
//       ).createShader(Offset(0, size.height) & size);

//     Path path = Path();
//     path.moveTo(0, size.height);
//     for (Offset point in points) {
//       path.lineTo(point.dx, point.dy);
//     }
//     path.lineTo(points.last.dx, size.height);
//     path.close();
//     canvas.drawPath(path, paint);

//     paint.shader = LinearGradient(
//       colors: colors,
//     ).createShader(Offset(0, size.height) & size);

//     canvas.drawPoints(
//       PointMode.polygon,
//       points,
//       paint,
//     );

//     canvas.drawLine(
//       Offset(0, size.height),
//       Offset(points.last.dx, size.height),
//       paint,
//     );

//     canvas.drawLine(
//       Offset(points.last.dx, points.last.dy),
//       Offset(points.last.dx, size.height),
//       paint,
//     );

//     for (int i = 0; i < highlightPoints.length; i++) {
//       if (value * size.width >= highlightPoints[i].dx) {
//         canvas.drawCircle(
//           highlightPoints[i],
//           10.0,
//           paint
//             ..style = PaintingStyle.stroke
//             ..shader = LinearGradient(colors: colors).createShader(Offset(0, size.height) & size)
//             ..strokeWidth = 10.0,
//         );
//         canvas.drawCircle(
//           highlightPoints[i],
//           5.0,
//           paint
//             ..style = PaintingStyle.fill
//             ..strokeWidth = 0
//             ..shader = null
//             ..color = Theme.of(context).colorScheme.background,
//         );
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
