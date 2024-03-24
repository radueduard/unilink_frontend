import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orar/account.dart';
import 'package:orar/Register%20Student/choosean.dart';
import 'package:orar/custom_components.dart';
import 'package:orar/links.dart';
import 'package:orar/netservice.dart';
import '../Structures/facultate.dart';

class ChooseFacultate extends StatefulWidget {
  final Account account;

  const ChooseFacultate({super.key, required this.account});

  @override
  State<ChooseFacultate> createState() => _ChooseFacultateState();
}

class _ChooseFacultateState extends State<ChooseFacultate> {
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

  Future<List<Facultate>> _getFacultati() async {
    List<Facultate> facultati = [];
    var url = '${domain}facultati/get_all';
    String? json = await NetService.getJson(url);
    if (json != null) {
      var data = jsonDecode(json);
      for (var facultate in data) {
        facultati.add(Facultate(facultate['id'], facultate['num'], facultate['name']));
      }
    }
    facultati.sort(((a, b) => a.num - b.num));
    return facultati;
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: Theme.of(context).highlightColor,
          onRefresh: () async {
            setState(() {});
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width,
                210 - 2 * _offset > 0 ? 210 - 2 * _offset : 0,
              ),
              child: Center(
                child: Opacity(
                  opacity: _getOpacity(),
                  child: Text(
                    'Facultatea',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: FutureBuilder(
                future: _getFacultati(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            height: 100,
                          );
                        }
                        return InkWell(
                          onTap: () {
                            widget.account.facultate = snapshot.data![index - 1];
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChooseAn(
                                  account: widget.account,
                                ),
                              ),
                            );
                          },
                          child: IgnorePointer(
                            child: TextBox(
                              labelText: snapshot.data![index - 1].name,
                              error: false,
                              controller: null,
                              isReadOnly: true,
                              onChanged: (value) => true,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).highlightColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
