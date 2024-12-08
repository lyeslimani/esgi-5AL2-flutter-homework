import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyes_slimani_dm/screens/post_list/post_list_page.dart';
import 'package:lyes_slimani_dm/shared/blocs/post_bloc/post_list_bloc.dart';
import 'package:lyes_slimani_dm/shared/services/remote_posts/api_post_source/fake_posts_data_source.dart';
import 'package:lyes_slimani_dm/shared/services/repositories/PostRepository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          PostRepository(remotePostDataSource: FakePostDataSource()),
      child: BlocProvider(
          create: (context) =>
              PostListBloc(postRepository: context.read<PostRepository>()),
          child: MaterialApp(
            debugShowCheckedModeBanner: true,
            routes: {
              '/': (context) => const PostListPage(),
            },
          )),
    );
  }
}
