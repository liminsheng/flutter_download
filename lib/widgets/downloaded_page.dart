import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download/models/episode.dart';
import 'package:flutter_download/utils/download_provider.dart';

class DownloadedPage extends StatefulWidget {
  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('没有已下载的视频哦！',
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
    var list = await downloadProvider.getEpisodes(true);
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
      title: Text(episode.title),
      subtitle: Text('第${episode.episode}集'),
      onTap: () {
        // Navigator.pushNamed(context, 'downloadPlay', arguments: episode);
      },
    );
  }
}
