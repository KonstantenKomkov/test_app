// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';
import 'package:test_app/helpers/album_preview.dart';
import 'package:test_app/helpers/get_logo_by_id.dart';

class AlbumsPage extends StatefulWidget {
  static const routeName = '/albums';
  final User user;
  AlbumsPage({Key? key, required this.user}) : super(key: key);

  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  Map<int, String> albumsLogo = {};
  List<Album>? albums;
  bool isLoading = false;
  final sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  Future<Map<int, String>> getThumbnail(List<Album> albums) async {
    Map<int, String> _map = {};
    for (Album album in albums) {
      var _photos = await sharedPrefs.getPhotos(album.id);
      _map[album.id] = _photos[0].thumbnailUrl;
    }
    return _map;
  }

  Future<void> initSharedPrefs() async {
    setState(() {
      isLoading = true;
    });
    await sharedPrefs.init();
    final _albums = await sharedPrefs.getAlbums(widget.user.id);
    final _albumsLogo = await getThumbnail(_albums);
    setState(() {
      albums = _albums;
      albumsLogo = _albumsLogo;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.user.userName}'s albums"),
        ),
        body: Container(
          child: _buildViewList(context, albums),
        ),
      ),
    );
  }

  Widget _buildViewList(BuildContext context, List<Album>? albums) {
    if (albums == null) {
      return Center(
        child: Text('Loading...'),
      );
    } else {
      return ListView.separated(
        itemCount: albums.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, index) => buildAlbumPreview(context,
            albums[index], getThumbnailUrlById(albums[index].id, albumsLogo)),
      );
    }
  }
}
