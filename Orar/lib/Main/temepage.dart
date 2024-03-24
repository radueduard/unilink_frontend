import 'package:flutter/material.dart';
import 'package:orar/Main/mainpage.dart';
import 'package:orar/Main/tematile.dart';

class TemePage extends StatefulWidget {
  final dynamic teme;
  const TemePage({super.key, required this.teme});

  @override
  State<TemePage> createState() => _TemePageState();
}

class _TemePageState extends State<TemePage> {
  late final ScrollController _scrollController;
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _offset = _scrollController.offset;
      });
    });
  }

  _getOpacity() {
    if (150.0 - 2.0 * _offset >= 150.0) {
      return 1.0;
    }
    if (150.0 - 2.0 * _offset <= 0.0) {
      return 0.0;
    }
    return (150.0 - 2.0 * _offset) / 150.0;
  }

  @override
  Widget build(BuildContext context) {
    dynamic nextAssignment = getSoonestTema(widget.teme);
    List assignments = widget.teme['teme'];
    assignments.sort(
      (a, b) {
        if (DateTime.parse(a['due_date']).isBefore(DateTime.parse(b['due_date']))) return -1;
        return 1;
      },
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              200 - _offset > 0 ? 200 - _offset : 0,
            ),
            child: Center(
              child: Opacity(
                opacity: _getOpacity(),
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      'Assignments',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: ListView.builder(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.teme['teme'].length + 1,
            itemBuilder: ((context, index) {
              if (index == 0) {
                return Container(
                  height: 200,
                );
              }
              if (nextAssignment != null && nextAssignment['id'] == assignments[index - 1]['id']) {
                return Hero(
                  tag: "nextAssignment",
                  child: Material(
                    type: MaterialType.transparency,
                    child: TemaTile(
                      tema: assignments[index - 1],
                    ),
                  ),
                );
              }
              return TemaTile(tema: assignments[index - 1]);
            }),
          ),
        ),
      ),
    );
  }
}
