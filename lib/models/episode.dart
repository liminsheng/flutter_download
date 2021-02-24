import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable()
class Episode {
    Episode();

    String episode;
    String cover;
    String title;
    String url;
    num id;
    String parentId;
    String type;
    num size;
    num progress;
    bool finish;
    String path;
    num state;
    
    factory Episode.fromJson(Map<String,dynamic> json) => _$EpisodeFromJson(json);
    Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
