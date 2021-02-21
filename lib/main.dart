import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Download',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Download Home Page'),
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
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //设置状态栏透明
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "images/bg_home.jpg",
            fit: BoxFit.contain,
          ),
          Container(
            color: Colors.black26,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(25, 120, 0, 0),
                child: Text(
                  "Flutter Download",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: Text(
                  "基于Flutter的视频下载示例",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: GridView.count(
                    padding: EdgeInsets.fromLTRB(25, 80, 25, 25),
                    crossAxisCount: 2,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 50,
                    childAspectRatio: 2,
                    children: [
                      _buildCard("视频", Icons.live_tv, Colors.pinkAccent, () {}),
                      _buildCard("下载", Icons.file_download_done,
                          Colors.blueAccent, () {}),
                    ],
                  )),
            ],
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _buildCard(
      String title, IconData icon, Color color, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 200,
          height: 80,
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 38,
                color: color,
              ),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
