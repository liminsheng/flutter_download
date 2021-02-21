import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_download/models/index.dart';

class VideoListRoute extends StatefulWidget {
  @override
  _VideoListRouteState createState() => _VideoListRouteState();
}

class _VideoListRouteState extends State<VideoListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('视频列表'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<Video>>(
        future: _loadDownloadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '不好意思，程序出小差了...',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              );
            } else {
              var downloadList = snapshot.data;
              return ListView.builder(
                itemCount: downloadList.length,
                  itemBuilder: (BuildContext context, int index) {
                return _buildItem(downloadList[index]);
              });
            }
          } else {
            return _loading;
          }
        },
      ),
    );
  }

  Widget get _loading => Center(
        child: CircularProgressIndicator(),
      );

  Future<List<Video>> _loadDownloadData() async {
    var value = await rootBundle.loadString('assets/download_list.json');
    var list = json.decode(value) as List;
    return list.map((e) => Video.fromJson(e)).toList();
  }

  Widget _buildItem(Video video) {
    return ListTile(title: Text(video.title));
  }
}
