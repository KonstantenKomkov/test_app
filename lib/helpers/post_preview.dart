// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';

Widget buildPostPreview(BuildContext context, Post post) {
  return ListTile(
    onTap: () {
      Navigator.of(context).pushNamed(
        '/post',
        arguments: post,
      );
    },
    title: Text(
      '${post.title[0].toUpperCase()}${post.title.substring(1)}',
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      post.body,
      maxLines: 1,
    ),
    trailing: const Icon(Icons.comment),
  );
}
