import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/blocs/post/post_bloc/post_bloc.dart';
import '../../shared/blocs/post/post_bloc/post_state.dart';
import '../../shared/models/post.dart';

enum PostPageMode { view, editing }

class PostPage extends StatefulWidget {
  final PostPageMode initialMode;
  final Post post;

  const PostPage({
    super.key,
    required this.post,
    this.initialMode = PostPageMode.view,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late PostPageMode mode;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post.title;
    _descriptionController.text = widget.post.description;
    mode = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: blockListenerHandler,
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: switchMode,
                    icon: Icon(
                        mode == PostPageMode.view ? Icons.edit : Icons.cancel),
                  )
                ],
              ),
            ),
            body: getCurrentPageWidgets(state.status),
          );
        },
      ),
    );
  }

  void switchMode() {
    setState(() {
      if (mode == PostPageMode.editing) {
        mode = PostPageMode.view;
        return;
      }
      mode = PostPageMode.editing;
      return;
    });
  }

  Widget getCurrentPageWidgets(PostStatus stateStatus) {
    if (mode == PostPageMode.view) {
      return SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      widget.post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.post.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
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
                  : Container(),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text for the title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    label: Text('Description'),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text for the description';
                    }
                    return null;
                  },
                  expands: false,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    stateStatus == PostStatus.updatingPost
                        ? const Expanded(child: LinearProgressIndicator())
                        : ElevatedButton(
                            onPressed: onUpdatePostSubmit,
                            child: const Text('Valider les modifications'),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  void onUpdatePostSubmit() {
    if (_formKey.currentState!.validate()) {
      updateNewPost(
        id: widget.post.id,
        title: _titleController.text,
        description: _descriptionController.text,
      );
    }
  }

  void updateNewPost(
      {required String id,
      required String title,
      required String description}) {
    final postListBloc = context.read<PostBloc>();
    postListBloc
        .add(UpdatePost(id: id, title: title, description: description));
  }

  void blockListenerHandler(BuildContext context, PostState state) {
    switch (state.status) {
      case PostStatus.errorUpdatingPost:
        displayErrorMessage();
        break;
      case PostStatus.successUpdatingPost:
        Navigator.pop(context);
      default:
        break;
    }
  }

  void displayErrorMessage() {
    setState(() {
      errorMessage =
          "Error in saving the modifications¬ of the post. Please try again";
    });
  }
}
