// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) {
  return Episode()
    ..episode = json['episode'] as String
    ..cover = json['cover'] as String
    ..title = json['title'] as String
    ..url = json['url'] as String
    ..id = json['id'] as num
    ..parentId = json['parentId'] as String
    ..type = json['type'] as String
    ..size = json['size'] as num
    ..progress = json['progress'] as num
    ..finish = json['finish'] as bool
    ..path = json['path'] as String;
}

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'episode': instance.episode,
      'cover': instance.cover,
      'title': instance.title,
      'url': instance.url,
      'id': instance.id,
      'parentId': instance.parentId,
      'type': instance.type,
      'size': instance.size,
      'progress': instance.progress,
      'finish': instance.finish,
      'path': instance.path
    };
