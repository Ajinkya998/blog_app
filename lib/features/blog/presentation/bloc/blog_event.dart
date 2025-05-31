part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String title;
  final String content;
  final File imageUrl;
  final String posterId;
  final List<String> topics;

  BlogUpload({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.posterId,
    required this.topics,
  });
}
