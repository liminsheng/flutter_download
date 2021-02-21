// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video()
    ..episode = json['episode'] as String
    ..img = json['img'] as String
    ..cover = json['cover'] as String
    ..title = json['title'] as String
    ..h5_h5_url = json['h5_h5_url'] as String
    ..url = json['url'] as String
    ..episodes = (json['episodes'] as List)
        ?.map((e) =>
            e == null ? null : Episode.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..type = json['type'] as String
    ..year = json['year'] as String
    ..sub_title = json['sub_title'] as String
    ..id = json['id'] as String;
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'episode': instance.episode,
      'img': instance.img,
      'cover': instance.cover,
      'title': instance.title,
      'h5_h5_url': instance.h5_h5_url,
      'url': instance.url,
      'episodes': instance.episodes,
      'type': instance.type,
      'year': instance.year,
      'sub_title': instance.sub_title,
      'id': instance.id
    };
