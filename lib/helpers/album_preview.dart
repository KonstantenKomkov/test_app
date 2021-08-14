// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';

Widget buildAlbumPreview(BuildContext context, Album album, String logo) {
  return ListTile(
    onTap: () {
      Navigator.of(context).pushNamed(
        '/album',
        arguments: album,
      );
    },
    leading: CircleAvatar(
      backgroundColor: Colors.blueGrey,
      backgroundImage: NetworkImage(logo),
    ),
    title: Text(
      '${album.title[0].toUpperCase()}${album.title.substring(1)}',
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
  );
}
