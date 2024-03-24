import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:orar/Main/mainpage.dart';
import 'package:orar/Main/schedtile.dart';

class ScheduleView extends StatefulWidget {
  final dynamic orar;
  const ScheduleView({super.key, required this.orar});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    dynamic nextMaterie = getNextMaterie(widget.orar);
    int week = getWeekType();
    int day = getDayOfWeek();
    int hour = timeToHour();

    if (day == 5 || day == 6) {
      day = 0;
      hour = 0;
      week = (week + 1) % 2;
    } else if (hour == 6 && day == 4) {
      week = (week + 1) % 2;
      day = 0;
      hour = 0;
    } else if (hour == 6) {
      day++;
      hour = 0;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Container(
            color: Theme.of(context).colorScheme.background,
            child: CarouselSlider.builder(
              itemCount: 2,
              itemBuilder: (context, firstIndex, firstRealIndex) {
                return Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: 5,
                      itemBuilder: ((context, index, realIndex) {
                        return Scaffold(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          appBar: PreferredSize(
                            preferredSize: const Size(900, 70),
                            child: Center(
                              child: Text(
                                dayFromIndex(index),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          body: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int listIndex) {
                              if (widget.orar['orar'][firstIndex]['zile'][index]['ore'][listIndex]['id'] == nextMaterie['id']) {
                                return Hero(
                                  tag: "next",
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: ScheduleTile(
                                      materia: widget.orar['orar'][firstIndex]['zile'][index]['ore'][listIndex],
                                    ),
                                  ),
                                );
                              }
                              return ScheduleTile(materia: widget.orar['orar'][firstIndex]['zile'][index]['ore'][listIndex]);
                            },
                          ),
                        );
                      }),
                      options: CarouselOptions(
                        onPageChanged: (index, reason) => day = index + 1,
                        initialPage: day - 1,
                        scrollDirection: Axis.horizontal,
                        height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * .87,
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                      ),
                    ),
                    Center(
                      child: Text(
                        firstIndex == 0 ? 'Odd week' : 'Even week',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                );
              },
              options: CarouselOptions(
                initialPage: week,
                viewportFraction: 1,
                scrollDirection: Axis.vertical,
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String dayFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      default:
        return 'wut?';
    }
  }
}
