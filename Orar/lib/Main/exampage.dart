import 'package:flutter/material.dart';
import 'package:orar/Main/examtile.dart';
import 'package:orar/Main/mainpage.dart';

class ExamPage extends StatefulWidget {
  final dynamic exams;
  const ExamPage({super.key, required this.exams});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
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
    dynamic nextExam = getSoonestExam(widget.exams);
    List examene = widget.exams['examene'];
    examene.sort(
      (a, b) {
        if (DateTime.parse(a['date']).isBefore(DateTime.parse(b['date']))) return -1;
        return 1;
      },
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: ClipRRect(
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: PreferredSize(
                preferredSize: Size(
                  MediaQuery.of(context).size.width,
                  200 - _offset > 0 ? 200 - _offset : 0,
                ),
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Center(
                      child: Opacity(
                        opacity: _getOpacity(),
                        child: Text(
                          'Exams',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.exams['examene'].length + 1,
                itemBuilder: ((context, index) {
                  if (index == 0) {
                    return Container(
                      height: 200,
                    );
                  }
                  if (nextExam != null && nextExam['id'] == examene[index - 1]['id']) {
                    return Hero(
                      tag: "nextExam",
                      child: Material(
                        type: MaterialType.transparency,
                        child: ExamTile(
                          exam: examene[index - 1],
                        ),
                      ),
                    );
                  }
                  return ExamTile(exam: examene[index - 1]);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
