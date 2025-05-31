import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.posterId,
    required super.topics,
    required super.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'blog_title': title,
      'blog_content': content,
      'image_url': imageUrl,
      'poster_id': posterId,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      title: map['blog_title'] as String,
      content: map['blog_content'] as String,
      imageUrl: map['image_url'] as String,
      posterId: map['poster_id'] as String,
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  BlogModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    String? posterId,
    List<String>? topics,
    DateTime? updatedAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      posterId: posterId ?? this.posterId,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
