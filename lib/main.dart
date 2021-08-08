// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';
import 'package:test_app/pages/album_page.dart';
import 'package:test_app/pages/albums_page.dart';
import 'package:test_app/pages/not_found_page.dart';
import 'package:test_app/pages/post_page.dart';
import 'package:test_app/pages/posts_page.dart';
import 'package:test_app/pages/user_page.dart';
import 'package:test_app/pages/users_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          return NotFound();
        });
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case UsersPage.routeName:
            return MaterialPageRoute(builder: (BuildContext context) {
              return UsersPage();
            });
          case UserPage.routeName:
            final user = settings.arguments as User;
            return MaterialPageRoute(builder: (BuildContext context) {
              return UserPage(user: user);
            });
          case PostsPage.routeName:
            final user = settings.arguments as User;
            return MaterialPageRoute(builder: (BuildContext context) {
              return PostsPage(user: user);
            });
          case PostPage.routeName:
            final post = settings.arguments as Post;
            return MaterialPageRoute(builder: (BuildContext context) {
              return PostPage(post: post);
            });
          case AlbumsPage.routeName:
            final user = settings.arguments as User;
            return MaterialPageRoute(builder: (BuildContext context) {
              return AlbumsPage(user: user);
            });
          case AlbumPage.routeName:
            final album = settings.arguments as Album;
            return MaterialPageRoute(builder: (BuildContext context) {
              return AlbumPage(album: album);
            });
          default:
            return MaterialPageRoute(builder: (BuildContext context) {
              return NotFound();
            });
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      //home: UsersPage(title: 'Users'),
    );
  }
}
