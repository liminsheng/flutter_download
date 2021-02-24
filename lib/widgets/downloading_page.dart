import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download/models/episode.dart';
import 'package:flutter_download/utils/downLoad_manage.dart';
import 'package:flutter_download/utils/download_provider.dart';

class DownloadingPage extends StatefulWidget {
  @override
  _DownloadingPageState createState() => _DownloadingPageState();
}

class _DownloadingPageState extends State<DownloadingPage> {
  DownloadProvider downloadProvider = DownloadProvider();
  DownLoadManage downLoadManage = DownLoadManage();
  Future loadDataFuture;

  @override
  void initState() {
    setState(() {
      loadDataFuture = getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    downloadProvider.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            loadDataFuture = getData();
          });
          return loadDataFuture;
        },
        child: FutureBuilder<List<Episode>>(
          future: loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return _noData;
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return _buildItem(snapshot.data[index]);
                    });
              } else {
                return _noData;
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget get _noData => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('没有下载中的视频哦！',
                style: TextStyle(color: Colors.grey, fontSize: 18)),
            InkWell(
              child: Icon(Icons.refresh, color: Colors.grey),
              onTap: () {
                setState(() {
                  loadDataFuture = getData();
                });
              },
            )
          ],
        ),
      );

  Future<List<Episode>> getData() async {
    var list = await downloadProvider.getEpisodes(false);
    return list;
  }

  Widget _buildItem(Episode episode) {
    var title = episode.type == 'movie'
        ? episode.title
        : episode.title + '第${episode.episode}集';
    return ListTile(
      leading: Stack(alignment: Alignment.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 100,
            child: CachedNetworkImage(
              imageUrl: episode.cover,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Image.asset(
                  'images/placeholder_video.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        episode.state == 1
            ? Icon(Icons.play_circle_outline, color: Colors.white, size: 36)
            : Container(
                width: 100,
              )
      ]),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _buildSubtitle(context, episode),
      onTap: () {
        setState(() {
          episode.state = episode.state == 0 ? 1 : 0;
        });
        _toggleDownload(episode);
      },
    );
  }

  Widget _buildSubtitle(BuildContext context, Episode episode) {
    return StreamBuilder<int>(
      stream: getDownloadState(episode), //
      //initialData: ,// a Stream<int> or null
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _buildState(
            context, snapshot.data ?? 0, episode, snapshot.connectionState);
      },
    );
  }

  Widget _buildState(BuildContext context, int data, Episode episode,
      ConnectionState connectionState) {
    var state = '';
    switch (connectionState) {
      case ConnectionState.waiting:
        state = '等待下载...';
        break;
      case ConnectionState.active:
        state = episode.state == 0 ? '正在下载' : '已暂停';
        break;
      case ConnectionState.done:
        state = '下载完成';
        break;
      case ConnectionState.none:
        state = '没有Stream';
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
          child: LinearProgressIndicator(value: data.toDouble() / episode.size),
        ),
        Row(children: [
          Expanded(child: Text(state)),
          Text(
              '${downLoadManage.getFormatSize(data)}/${downLoadManage.getFormatSize(episode.size)}'),
        ]),
      ],
    );
  }

  Stream<int> getDownloadState(Episode episode) {
    return Stream.periodic(Duration(seconds: 1), (i) {
      var progress =
          downLoadManage.downloadingEpisodes[episode.url]?.progress ??
              episode.progress;
      return progress;
    });
  }

  _toggleDownload(Episode episode) async {
    if (downLoadManage.downloadingUrls[episode.url]?.isCancelled == false) {
      downLoadManage.stop(episode.url);
    } else {
      var savePath = await DownLoadManage().getSavePath(context, episode);
      await downLoadManage.download(episode, savePath);
    }
  }
}
