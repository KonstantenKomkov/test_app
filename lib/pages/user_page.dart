// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/helpers/album_preview.dart';
import 'package:test_app/helpers/get_logo_by_id.dart';
import 'package:test_app/helpers/post_preview.dart';
import 'package:test_app/prefs.dart';
import 'package:test_app/helpers/text_element.dart';

class UserPage extends StatefulWidget {
  static const routeName = '/user';
  const UserPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLoading = false;
  final sharedPrefs = SharedPrefs();
  List<Post>? posts;
  List<Album>? albums;
  Map<int, String> albumsLogo = {};

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  Future<Map<int, String>> getThumbnail(List<Album> albums) async {
    final Map<int, String> _map = {};
    for (final Album album in albums) {
      final _photos = await sharedPrefs.getPhotos(album.id);
      _map[album.id] = _photos[0].thumbnailUrl;
    }
    return _map;
  }

  Future<void> initSharedPrefs() async {
    setState(() {
      isLoading = true;
    });
    await sharedPrefs.init();
    final _posts = await sharedPrefs.getPosts(widget.user.id);
    final _albums = await sharedPrefs.getAlbums(widget.user.id);
    final _albumsLogo = await getThumbnail(_albums);

    setState(() {
      posts = _posts;
      albums = _albums;
      albumsLogo = _albumsLogo;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List currentPosts = findElements(posts, widget.user, 3);
    final List currentAlbums = findElements(albums, widget.user, 3);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.user.userName),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextElement(
                context,
                widget.user.name,
                24,
                FontWeight.bold,
                kDefaultPadding * 2,
                kDefaultPadding * 2,
              ),
              buildTextElement(
                context,
                widget.user.email.toLowerCase(),
                18,
                FontWeight.w300,
                kDefaultPadding * 2,
                kDefaultPadding,
              ),
              _buildRichTextElement(
                context,
                'Phone: ',
                widget.user.phone,
              ),
              _buildRichTextElement(
                context,
                'Website: ',
                widget.user.website,
              ),
              _buildHeader(
                context,
                'Company:',
                Icons.work,
              ),
              _buildRichTextElement(
                context,
                'Name: ',
                widget.user.company.name,
              ),
              _buildRichTextElement(
                context,
                'Bs: ',
                widget.user.company.bs,
              ),
              _buildRichTextElement(
                context,
                'Catch phrase: ',
                '— "${widget.user.company.catchPhrase}" —',
                FontStyle.italic,
              ),
              _buildHeader(
                context,
                'Address:',
                Icons.location_on,
              ),
              buildTextElement(
                context,
                '${widget.user.address.city}, ${widget.user.address.street}, ${widget.user.address.suite}, ${widget.user.address.zipCode}',
                14,
                FontWeight.normal,
                kDefaultPadding * 2,
              ),
              _buildHeader(
                context,
                'Posts:',
                Icons.message,
              ),
              ...currentPosts
                  .map<Widget>(
                      (post) => buildPostPreview(context, post as Post))
                  .toList(),
              _buildButton(context, widget.user, '/posts', 'View more'),
              _buildHeader(
                context,
                'Albums:',
                Icons.album,
              ),
              ...currentAlbums
                  .map<Widget>((album) => buildAlbumPreview(
                      context,
                      album as Album,
                      getThumbnailUrlById(album.id, albumsLogo)))
                  .toList(),
              _buildButton(context, widget.user, '/albums', 'View more'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title, IconData? icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRichTextElement(
      BuildContext context, String boldText, String text,
      [FontStyle? fontStyle = FontStyle.normal]) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kDefaultPadding * 2,
        top: kDefaultPadding,
      ),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: boldText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text, style: TextStyle(fontStyle: fontStyle)),
        ]),
      ),
    );
  }

  List<dynamic> findElements(List<dynamic>? elements, User user,
      [int? countElements]) {
    if (elements != null) {
      final List<dynamic> usersElements = [];
      for (final item in elements) {
        if (item.userId == user.id) {
          usersElements.add(item);
        }
      }
      if (countElements != null) {
        elements = elements.sublist(0,
            countElements > elements.length ? elements.length : countElements);
      }
      return elements;
    } else {
      return [];
    }
  }

  Widget _buildButton(
      BuildContext context, User user, String path, String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding * 2),
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 140),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                path,
                arguments: user,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.remove_red_eye),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
