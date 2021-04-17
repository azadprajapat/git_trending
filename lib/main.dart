import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:git_trending/Modal/repository_modal.dart';
import 'package:git_trending/services/trending_repo.dart';
import 'package:git_trending/widgets/repo_card.dart';
import 'package:path_provider/path_provider.dart';

Directory appDocsDir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appDocsDir = await getApplicationDocumentsDirectory();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Github Trending Repositories'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EasyRefreshController _controller;
  bool remote = false;
  List<RepositoryModal> search_data;
  bool fetching = false;
  List<RepositoryModal> formatted_list = [];
  TextEditingController search_controller = new TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    fetch_data();

    super.initState();
    _controller = EasyRefreshController();
  }

  void fetch_data() async {
    setState(() {
      fetching = true;
    });
    var list = remote
        ? await TrendingRepo().get_trending_repo_remote()
        : await TrendingRepo().get_trending_repo();
    setState(() {
      search_data = list;
      formatted_list = list;
    });
    formatted_list != null ? format_list() : null;
    setState(() {
      fetching = false;
    });
  }

  void format_list() {
    setState(() {
      remote = false;
      formatted_list = [];
    });
    search_data.forEach((element) {
      if (element.name.contains(search_controller.text)) {
        setState(() {
          formatted_list.add(element);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              child: TextFormField(
                controller: search_controller,
                onChanged: (key) {
                  format_list();
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: InkWell(
                      child: Icon(Icons.search),
                    )),
              ),
            ),
          ),
        ),
        body: fetching
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : formatted_list == null
                ? AlertDialog(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    content: Text("error while fetching trending repositories",style: TextStyle(color: Colors.red),),
                    actions: [
                      MaterialButton(
                        onPressed: () async {
                          setState(() {
                            remote = true;
                            fetching = true;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          await fetch_data();
                        },
                        child: Text("Refresh"),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: EasyRefresh.custom(
                        key: _refreshIndicatorKey,
                        header: BallPulseHeader(color: Colors.green),
                        onRefresh: _handleRefresh,
                        slivers: <Widget>[
                          SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return InkWell(
                                onLongPress: () {
                                  showDialog(context: context, builder: (_){
                                    return AlertDialog(
                                      contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                      content: Text("Are you sure you want to delete this repositories",style: TextStyle(color: Colors.red),),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("No"),
                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            setState(() {
                                              formatted_list.removeAt(index);
                                              search_data.removeAt(index);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    );
                                  });

                                },
                                child: RepoCard(
                                  modal: formatted_list[index],
                                ),
                              );
                            }, childCount: formatted_list.length),
                          ),
                        ]),
                  ));
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    setState(() {
      remote = true;
    });
    await fetch_data();
  }
}
