import 'package:flutter/material.dart';
import 'package:flutter_download/widgets/downloaded_page.dart';
import 'package:flutter_download/widgets/downloading_page.dart';

class DownloadRoute extends StatefulWidget {
  @override
  _DownloadRouteState createState() => _DownloadRouteState();
}

class _DownloadRouteState extends State<DownloadRoute>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('我的下载'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [Tab(text: '已下载'), Tab(text: '下载中')],
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).primaryColor,
            ),
            Expanded(
                flex: 1,
                child: TabBarView(
                    controller: _tabController, children: _buildTabBarViews()))
          ],
        ));
  }

  List<Widget> _buildTabBarViews() {
    List<Widget> list = [];
    list.add(DownloadedPage());
    list.add(DownloadingPage());
    return list;
  }
}
