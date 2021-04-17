import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_trending/Modal/repository_modal.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../main.dart';

class RepoCard extends StatefulWidget {
  final RepositoryModal modal;

  RepoCard({this.modal});

  @override
  _RepoCardState createState() => _RepoCardState();
}

class _RepoCardState extends State<RepoCard> {
  bool isopen = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 16.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(

            //borderRadius: BorderRadius.all(Radius.circular(2.0)),
            decoration: BoxDecoration(
                //color: Color.fromRGBO(64, 75, 96, .9),
                borderRadius: BorderRadius.circular(20.0)),
            child: ExpansionTile(
              onExpansionChanged: (status) {
                setState(() {
                  isopen = status;
                });
              },
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.modal.language.toString()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.star_border),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.modal.stars.toString())
                              ],
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.ac_unit_rounded),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.modal.forks.toString())
                              ],
                            )
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("Built by"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: NetworkToFileImage(
                                    debug: true,
                                      file: File(p.join(appDocsDir.path,
                                          "${widget.modal.builtBy.username}.png")),
                                      url: widget.modal.builtBy.avatar),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                              onTap: () async {
                                await canLaunch(widget.modal.builtBy.href)
                                    ? await launch(widget.modal.builtBy.href)
                                    : throw 'Could not launch';
                              },
                              child: Text(
                                widget.modal.builtBy.username,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
              // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: NetworkToFileImage(
                            debug: true,
                              file: File(p.join(appDocsDir.path,
                                  "${widget.modal.name}.png")),
                              url: widget.modal.avatar)))),
              title: InkWell(
                onTap: () async {
                  await canLaunch(widget.modal.url)
                      ? await launch(widget.modal.url)
                      : throw 'Could not launch ';
                },
                child: Text(
                  widget.modal.name,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Text(
                !isopen
                    ? widget.modal.description.length < 30
                        ? widget.modal.description
                        : widget.modal.description.substring(0, 30)
                    : widget.modal.description,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
            )));
  }
}
