import 'dart:io';

import 'package:blog_app/core/theme/app_pallette.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _blogTitleController = TextEditingController();
  final TextEditingController _blogContentController = TextEditingController();
  List<String> selectedTopics = [];
  File? selectedImage;
  void imagePicker() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _blogTitleController.dispose();
    _blogContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.done))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              selectedImage != null
                  ? Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            imagePicker();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child:
                                  Image.file(selectedImage!, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppPallete.backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedImage = null;
                                });
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        imagePicker();
                      },
                      child: DottedBorder(
                        color: AppPallete.borderColor,
                        dashPattern: const [10, 4],
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        child: const SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open_outlined, size: 35),
                              SizedBox(height: 10),
                              Text(
                                "Select your Image",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    "Technology",
                    "Business",
                    "Programming",
                    "Entertainment"
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedTopics.contains(e)) {
                                selectedTopics.remove(e);
                              } else {
                                selectedTopics.add(e);
                              }
                              setState(() {});
                            },
                            child: Chip(
                              label: Text(e),
                              color: WidgetStatePropertyAll(
                                  selectedTopics.contains(e)
                                      ? AppPallete.gradient1
                                      : null),
                              side: selectedTopics.contains(e)
                                  ? null
                                  : const BorderSide(
                                      color: AppPallete.borderColor),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              BlogEditor(
                  controller: _blogTitleController, hintText: "Blog Title"),
              const SizedBox(height: 10),
              BlogEditor(
                  controller: _blogContentController, hintText: "Blog Title"),
            ],
          ),
        ),
      ),
    );
  }
}
