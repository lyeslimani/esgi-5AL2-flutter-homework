import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyes_slimani_dm/screens/post/post_page.dart';
import 'package:lyes_slimani_dm/screens/post_list/post_list_page.dart';
import 'package:lyes_slimani_dm/shared/blocs/post/post_bloc/post_bloc.dart';
import 'package:lyes_slimani_dm/shared/blocs/post/post_list_bloc/post_list_bloc.dart';
import 'package:lyes_slimani_dm/shared/models/post.dart';
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
              PostBloc(postRepository: context.read<PostRepository>()),
          child: BlocProvider(
            create: (context) => PostListBloc(
                postRepository: context.read<PostRepository>(),
                postBloc: context.read<PostBloc>()),
            child: MaterialApp(
              debugShowCheckedModeBanner: true,
              routes: {
                '/': (context) => const PostListPage(),
              },
              onGenerateRoute: (routeSettings) {
                final argument = routeSettings.arguments;
                switch (routeSettings.name) {
                  case 'post':
                    if (argument is Post) {
                      return MaterialPageRoute(
                        builder: (context) => PostPage(
                          post: argument,
                        ),
                      );
                    }
                    break;
                  case 'post?view=edit':
                    if (argument is Post) {
                      return MaterialPageRoute(
                        builder: (context) => PostPage(
                          post: argument,
                          initialMode: PostPageMode.editing,
                        ),
                      );
                    }
                    break;
                }
                return null;
              },
            ),
          )),
    );
  }
}
