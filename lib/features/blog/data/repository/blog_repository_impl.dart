import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_sources.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_sources.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSources blogRemoteDataSources;
  final BlogLocalDataSources blogLocalDataSources;
  final ConnectionChecker connectionChecker;
  const BlogRepositoryImpl(this.blogRemoteDataSources,
      this.blogLocalDataSources, this.connectionChecker);
  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        title: title,
        content: content,
        imageUrl: '',
        posterId: posterId,
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSources.uploadBlogImage(
          image: image, blog: blogModel);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final blog = await blogRemoteDataSources.uploadBlog(blogModel);
      return right(blog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSources.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSources.getAllBlogs();
      blogLocalDataSources.uploadBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
