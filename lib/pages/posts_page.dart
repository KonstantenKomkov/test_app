// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';
import 'package:test_app/helpers/post_preview.dart';

class PostsPage extends StatefulWidget {
  static const routeName = '/posts';
  final User user;
  const PostsPage({Key? key, required this.user}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post>? posts;
  bool isLoading = false;
  final sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  Future<void> initSharedPrefs() async {
    setState(() {
      isLoading = true;
    });
    await sharedPrefs.init();
    final _data = await sharedPrefs.getPosts(widget.user.id);
    setState(() {
      posts = _data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.user.userName}'s posts"),
        ),
        body: Container(
          child: _buildViewList(context, posts),
        ),
      ),
    );
  }

  Widget _buildViewList(BuildContext context, List<Post>? posts) {
    if (posts == null) {
      return const Center(
        child: Text('Loading...'),
      );
    } else {
      return ListView.separated(
        itemCount: posts.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, index) =>
            buildPostPreview(context, posts[index]),
      );
    }
  }
}
