import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download/models/episode.dart';
import 'package:flutter_download/utils/download_provider.dart';

class DownloadingPage extends StatefulWidget {
  @override
  _DownloadingPageState createState() => _DownloadingPageState();
}

class _DownloadingPageState extends State<DownloadingPage> {
  DownloadProvider downloadProvider = DownloadProvider();
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
        child: Wrap(
          children: [
            Text('没有下载中的视频哦！'),
            InkWell(
              child: Icon(Icons.refresh),
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
    return ListTile(
      leading: ClipRRect(
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
      title: Text(episode.title + '第${episode.episode}集'),
      subtitle: _buildSubtitle(context, episode),
      onTap: () {
        // Navigator.pushNamed(context, 'downloadPlay', arguments: episode);
      },
    );
  }

  Widget _buildSubtitle(BuildContext context, Episode episode) {
    return StreamBuilder<int>(
      stream: counter(), //
      //initialData: ,// a Stream<int> or null
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('没有Stream');
          case ConnectionState.waiting:
            return Text('等待下载...');
          case ConnectionState.active:
            return _buildProgress(context, snapshot.data, episode);
          case ConnectionState.done:
            return Text('下载完成');
        }
        return null; // unreachable
      },
    );
  }

  Widget _buildProgress(BuildContext context, int data, Episode episode) {
    getFormatSize(size) {
      String formatSize = "";
      String suffix = "  B";
      //内存转换
      if (size < 0.1 * 1024) {
        //小于0.1KB，则转化成B
        formatSize = size.toString();
        suffix = " B";
      } else if (size < 0.1 * 1024 * 1024) {
        //小于0.1MB，则转化成KB
        formatSize = (size / 1024).toString();
        suffix = " KB";
      } else if (size < 0.1 * 1024 * 1024 * 1024) {
        //小于0.1GB，则转化成MB
        formatSize = (size / (1024 * 1024)).toString();
        suffix = " MB";
      } else {
        //其他转化成GB
        formatSize = (size / (1024 * 1024 * 1024)).toString();
        suffix = " GB";
      }
      if (formatSize.contains('.') &&
          formatSize.length - formatSize.indexOf('.') > 2) {
        formatSize = formatSize.substring(0, formatSize.indexOf('.') + 3);
      }
      return formatSize + suffix;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
          child: LinearProgressIndicator(value: data.toDouble() / 100),
        ),
        Text('${getFormatSize(data * 1024 * 100)}/${getFormatSize(episode.size)}'),
      ],
    );
  }

  Stream<int> counter() {
    return Stream.periodic(Duration(seconds: 1), (i) {
      return i;
    });
  }
}
