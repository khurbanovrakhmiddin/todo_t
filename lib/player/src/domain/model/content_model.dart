import 'package:equatable/equatable.dart';

class ContentModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String url;
  final int like;
  final int disLike;

  const ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.like,
    required this.disLike,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      like: json['like'] as int,
      disLike: json['disLike'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'like': like,
      'disLike': disLike,
    };
  }

  ContentModel copyWith({
    int? id,
    String? title,
    String? description,
    String? url,
    int? like,
    int? disLike,
  }) {
    return ContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      like: like ?? this.like,
      disLike: disLike ?? this.disLike,
    );
  }

  @override
  List<Object?> get props => [id, title, description, url, like, disLike];
}
