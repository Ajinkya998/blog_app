import 'dart:io';

import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecase/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });

    on<BlogUpload>((event, emit) async {
      final res = await _uploadBlog(
        UploadBlogParams(
            title: event.title,
            content: event.content,
            posterId: event.posterId,
            image: event.imageUrl,
            topics: event.topics),
      );

      res.fold((failure) => emit(BlogFailure(failure.message)),
          (success) => emit(BlogUploadSuccess()));
    });

    on<BlogFetchAllBlogs>((event, emit) async {
      final res = await _getAllBlogs(NoParams());

      res.fold((failure) => emit(BlogFailure(failure.message)),
          (blogs) => emit(BlogDisplaySuccess(blogs)));
    });
  }
}
