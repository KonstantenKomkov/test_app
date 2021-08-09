// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/helpers/text_element.dart';

class PostPage extends StatefulWidget {
  static const routeName = '/post';
  PostPage({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLoading = false;
  final sharedPrefs = SharedPrefs();
  List<Comment>? comments;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _controller;

  void toggleBottomSheet() {
    if (_controller == null) {
      _controller = scaffoldKey.currentState?.showBottomSheet(
          (BuildContext context) => _buildBottomSheet(context));
    } else {
      _controller!.close();
      _controller = null;
    }
  }

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
    final _data = await sharedPrefs.getComments(widget.post.id);
    setState(() {
      comments = _data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        '${widget.post.title[0].toUpperCase()}${widget.post.title.substring(1)}';
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextElement(
                context,
                title,
                24,
                FontWeight.bold,
                kDefaultPadding * 2,
                kDefaultPadding * 2,
                kDefaultPadding * 2,
              ),
              buildTextElement(
                context,
                widget.post.body,
                18,
                FontWeight.normal,
                kDefaultPadding * 2,
                kDefaultPadding * 2,
                kDefaultPadding * 2,
              ),
              buildTextElement(
                context,
                'Comments',
                20,
                FontWeight.bold,
                kDefaultPadding * 2,
                kDefaultPadding * 2,
                kDefaultPadding * 2,
                kDefaultPadding,
              ),
              ..._buildComments(context, comments),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: kDefaultPadding * 2,
                    bottom: kDefaultPadding,
                  ),
                  child: ElevatedButton(
                    onPressed: toggleBottomSheet,
                    child: Text('Add comment'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildComments(BuildContext context, List<Comment>? comments) {
    if (comments == null) {
      return [
        Center(
          child: Text(
            'Loading...',
          ),
        )
      ];
    } else {
      List<Widget> listOfComments = [];
      for (Comment comment in comments) {
        listOfComments.add(_buildComment(context, comment));
      }
      return listOfComments;
    }
  }

  Widget _buildComment(BuildContext context, Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kDefaultPadding * 2,
        top: kDefaultPadding,
        right: kDefaultPadding * 2,
        bottom: kDefaultPadding,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildTextElement(
          context,
          '${comment.name[0].toUpperCase()}${comment.name.substring(1)}',
          14,
          FontWeight.bold,
        ),
        buildTextElement(
          context,
          comment.email.toLowerCase(),
          14,
          FontWeight.normal,
          0.0,
          0.0,
          0.0,
          kDefaultPadding,
        ),
        buildTextElement(
          context,
          comment.body,
          14,
        ),
      ]),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return BottomSheet(
      builder: (context) => Container(
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(
            kDefaultPadding * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTextField(context, 'name'),
              _buildTextField(context, 'email'),
              _buildTextField(context, 'comment'),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Send"),
                ),
              )
            ],
          ),
        ),
      ),
      onClosing: () {},
    );
  }

  Widget _buildTextField(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Input your $name',
          labelText: name,
          labelStyle: TextStyle(color: Colors.blueGrey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Colors.blueGrey,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Colors.blueGrey,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}