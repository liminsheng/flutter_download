import 'package:flutter_download/models/episode.dart';
import 'package:sqflite/sqflite.dart';

class DownloadProvider {
  String dbName = 'video.db';
  String tableDownload = 'download';
  Database db;

  Future open() async {
    db = await openDatabase(dbName, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableDownload ( 
  tableId integer primary key autoincrement, 
  episode text,
  cover text,
  title text,
  url text,
  id integer,
  parentId text,
  type text,
  path text,
  size long,
  progress long,
  finish integer)
''');
        });
  }

  Future<Episode> insert(Episode episode) async {
    print('insert ${episode.title}');
    if (db == null || !db.isOpen) {
      await open();
    }
    var queryEpisode = await getEpisode(episode.url);
    if (queryEpisode != null) {
      print('insert ${queryEpisode.title} exist');
      return queryEpisode;
    }
    episode.id = await db.insert(tableDownload, toMap(episode));
    return episode;
  }

  Future<Episode> getEpisode(String url) async {
    if (db == null || !db.isOpen) {
      await open();
    }
    List<Map> maps =
    await db.query(tableDownload, where: 'url = ?', whereArgs: [url]);
    if (maps.length > 0) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<List<Episode>> getEpisodes(bool downloaded) async {
    if (db == null || !db.isOpen) {
      await open();
    }
    List<Map> maps = await db.query(tableDownload,
        where: 'finish = ?', whereArgs: [downloaded ? 1 : 0]);
    if (maps.length > 0) {
      var list = maps.map((e) => fromMap(e)).toList();
      return list;
    }
    return null;
  }

  Future<int> delete(String url) async {
    if (db == null || !db.isOpen) {
      await open();
    }
    return await db.delete(tableDownload, where: 'url = ?', whereArgs: [url]);
  }

  Future<int> update(Episode episode) async {
    if (db == null || !db.isOpen) {
      await open();
    }
    return await db.update(tableDownload, toMap(episode),
        where: 'url = ?', whereArgs: [episode.url]);
  }

  Future close() async => db?.close();

  Map<String, dynamic> toMap(Episode episode) {
    var map = <String, dynamic>{
      'episode': episode.episode,
      'cover': episode.cover,
      'title': episode.title,
      'url': episode.url,
      'id': episode.id,
      'parentId': episode.parentId,
      'type': episode.type,
      'path': episode.path,
      'size': episode.size,
      'progress': episode.progress,
      'finish': episode.finish ? 1 : 0
    };
    return map;
  }

  Episode fromMap(Map<String, dynamic> map) {
    return Episode()
      ..episode = map['episode']
      ..cover = map['cover']
      ..title = map['title']
      ..url = map['url']
      ..id = map['id']
      ..parentId = map['parentId']
      ..type = map['type']
      ..path = map['path']
      ..size = map['size']
      ..progress = map['progress']
      ..finish = map['finish'] == 1;
  }
}