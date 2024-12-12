import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/blocs/post/post_bloc/post_bloc.dart';
import '../../shared/blocs/post/post_bloc/post_state.dart';

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key});

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: _onPostBlocListener,
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Write what you're thinking...",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                      hintText: 'Title of your post',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text for the title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      label: Text('Content'),
                      hintText: 'Write what you want to say',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text for the description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  state.status == PostStatus.creatingPost
                      ? const LinearProgressIndicator()
                      : ElevatedButton(
                          onPressed: onCreatePostSubmit,
                          child: const Text('Post'),
                        ),
                  const SizedBox(height: 8),
                  errorMessage != null
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                              style: const TextStyle(color: Colors.white),
                              errorMessage!),
                        )
                      : Container()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onPostBlocListener(BuildContext context, PostState state) {
    switch (state.status) {
      case PostStatus.errorCreatingPost:
        displayErrorMessage();
        break;
      case PostStatus.successCreatingPost:
        Navigator.pop(context);
      default:
        break;
    }
  }

  void displayErrorMessage() {
    setState(() {
      errorMessage = "Error in the creation of the post. Please try again";
    });
  }

  void onCreatePostSubmit() {
    if (_formKey.currentState!.validate()) {
      createNewPost(
        title: _titleController.text,
        description: _descriptionController.text,
      );
    }
  }

  void createNewPost({required String title, required String description}) {
    final postListBloc = context.read<PostBloc>();
    postListBloc.add(CreateNewPost(title: title, description: description));
  }
}
