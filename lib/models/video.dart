import 'package:json_annotation/json_annotation.dart';
import "episode.dart";
part 'video.g.dart';

@JsonSerializable()
class Video {
    Video();

    String episode;
    String img;
    String cover;
    String title;
    String h5_h5_url;
    String url;
    List<Episode> episodes;
    String type;
    String year;
    String sub_title;
    String id;
    
    factory Video.fromJson(Map<String,dynamic> json) => _$VideoFromJson(json);
    Map<String, dynamic> toJson() => _$VideoToJson(this);
}
