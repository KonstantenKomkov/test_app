// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:test_app/load_data.dart';

class Company {
  String name = "";
  String catchPhrase = "";
  String bs = "";

  Company(this.name, this.catchPhrase, this.bs);

  Company.fromJson(Map<String, dynamic> json) {
    Company(
      name = json["name"] as String,
      catchPhrase = json["catchPhrase"] as String,
      bs = json["bs"] as String,
    );
  }
}

class Geo {
  double latitude = 0;
  double longitude = 0;

  Geo(this.latitude, this.longitude);

  Geo.fromJson(Map<String, dynamic> json) {
    Geo(latitude = double.parse(json["lat"]),
        longitude = double.parse(json["lng"]));
  }
}

class Address {
  String street = "";
  String suite = "";
  String city = "";
  String zipcode = "";
  Geo geo = Geo(0, 0);

  Address(this.street, this.suite, this.city, this.zipcode, this.geo);

  Address.fromJson(Map<String, dynamic> json) {
    Address(
        street = json["street"] as String,
        suite = json["suite"] as String,
        city = json["city"] as String,
        zipcode = json["zipcode"] as String,
        geo = Geo.fromJson(json["geo"]));
  }
}

class User {
  int id = 0;
  String name = "";
  String userName = "";
  String email = "";
  String phone = "";
  String website = "";
  Company company = Company("", "", "");
  Address address = Address("", "", "", "", Geo(0, 0));

  User(this.id, this.name, this.userName, this.email, this.phone, this.website,
      this.company, this.address);

  User.fromJson(Map<String, dynamic> json) {
    User(
        id = json["id"] as int,
        name = json["name"] as String,
        userName = json["username"] as String,
        email = json["email"] as String,
        phone = json["phone"] as String,
        website = json["website"] as String,
        company = Company.fromJson(json["company"]),
        address = Address.fromJson(json["address"]));
  }
}

class Post {
  int userId = 0;
  int id = 0;
  String title = '';
  String body = '';

  Post(this.userId, this.id, this.title, this.body);

  Post.fromJson(Map<String, dynamic> json) {
    Post(
      userId = json["userId"] as int,
      id = json["id"] as int,
      title = json["title"] as String,
      body = json["body"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}

class Album {
  int userId = 0;
  int id = 0;
  String title = '';

  Album(this.userId, this.id, this.title);

  Album.fromJson(Map<String, dynamic> json) {
    Album(
      userId = json["userId"] as int,
      id = json["id"] as int,
      title = json["title"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
    };
  }
}

class Comment {
  int postId = 0;
  int id = 0;
  String name = '';
  String email = '';
  String body = '';

  Comment(this.postId, this.id, this.name, this.email, this.body);

  Comment.fromJson(Map<String, dynamic> json) {
    Comment(
      postId = json["postId"] as int,
      id = json["id"] as int,
      name = json["name"] as String,
      email = json["email"] as String,
      body = json["body"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }
}

class Photo {
  int albumId = 0;
  int id = 0;
  String title = '';
  String url = '';
  String thumbnailUrl = '';

  Photo(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);

  Photo.fromJson(Map<String, dynamic> json) {
    Photo(
      albumId = json["albumId"] as int,
      id = json["id"] as int,
      title = json["title"] as String,
      url = json["url"] as String,
      thumbnailUrl = json["thumbnailUrl"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

class SharedPrefs {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<User>> getUsers() async {
    if (!_prefs.containsKey('myUsers')) {
      var usersLoad = await loadData('/users');
      _prefs.setString('myUsers', usersLoad);
    }

    final fileData = _prefs.getString('myUsers');
    final fileDataDecode = fileData != null ? jsonDecode(fileData) : [];
    final List<User> array =
        fileDataDecode.map<User>((user) => User.fromJson(user)).toList();
    return array;
  }

  Future<List<Post>> getPosts(int userId) async {
    var postsLoad;

    if (!_prefs.containsKey('myPosts')) {
      postsLoad = await loadData('/users/$userId/posts');
      _prefs.setString('myPosts', postsLoad);
    }

    final fileData = _prefs.getString('myPosts');
    final fileDataDecode = fileData != null ? jsonDecode(fileData) : [];
    List<Post> array =
        fileDataDecode.map<Post>((post) => Post.fromJson(post)).toList();
    List<Post> usersPosts = [];
    for (Post post in array) {
      if (post.userId == userId) {
        usersPosts.add(post);
      }
    }

    if (usersPosts.isEmpty) {
      postsLoad = await loadData('/users/$userId/posts');
      final newLoadedPosts = jsonDecode(postsLoad);
      usersPosts =
          newLoadedPosts.map<Post>((post) => Post.fromJson(post)).toList();
      for (Post post in usersPosts) {
        array.add(post);
      }
      final listPostsString = jsonEncode(array);
      await _prefs.setString('myPosts', listPostsString);
    }
    return usersPosts;
  }

  Future<List<Comment>> getComments(int postId) async {
    var commentsLoad;

    if (!_prefs.containsKey('myComments')) {
      commentsLoad = await loadData('/post/$postId/comments');
      _prefs.setString('myComments', commentsLoad);
    }

    final fileData = _prefs.getString('myComments');
    final fileDataDecode = fileData != null ? jsonDecode(fileData) : [];
    List<Comment> array = fileDataDecode
        .map<Comment>((comment) => Comment.fromJson(comment))
        .toList();
    List<Comment> postsComments = [];
    for (Comment comment in array) {
      if (comment.postId == postId) {
        postsComments.add(comment);
      }
    }

    if (postsComments.isEmpty) {
      commentsLoad = await loadData('/post/$postId/comments');
      final newLoadedComments = jsonDecode(commentsLoad);
      postsComments = newLoadedComments
          .map<Comment>((comment) => Comment.fromJson(comment))
          .toList();
      for (Comment comment in postsComments) {
        array.add(comment);
      }
      final listCommentsString = jsonEncode(array);
      await _prefs.setString('myComments', listCommentsString);
    }
    return postsComments;
  }

  Future<List<Album>> getAlbums(int userId) async {
    var albumsLoad;

    if (!_prefs.containsKey('myAlbums')) {
      albumsLoad = await loadData('/users/$userId/albums');
      _prefs.setString('myAlbums', albumsLoad);
    }

    final fileData = _prefs.getString('myAlbums');
    final fileDataDecode = fileData != null ? jsonDecode(fileData) : [];
    List<Album> array =
        fileDataDecode.map<Album>((album) => Album.fromJson(album)).toList();
    List<Album> usersAlbums = [];
    for (Album album in array) {
      if (album.userId == userId) {
        usersAlbums.add(album);
      }
    }

    if (usersAlbums.isEmpty) {
      albumsLoad = await loadData('/users/$userId/albums');
      final newLoadedComments = jsonDecode(albumsLoad);
      usersAlbums = newLoadedComments
          .map<Album>((album) => Album.fromJson(album))
          .toList();
      for (Album album in usersAlbums) {
        array.add(album);
      }
      final listCommentsString = jsonEncode(array);
      await _prefs.setString('myAlbums', listCommentsString);
    }
    return usersAlbums;
  }

  Future<List<Photo>> getPhotos(int albumId) async {
    var photosLoad;

    if (!_prefs.containsKey('myPhotos')) {
      photosLoad = await loadData('/albums/$albumId/photos');
      _prefs.setString('myPhotos', photosLoad);
    }

    final fileData = _prefs.getString('myPhotos');
    final fileDataDecode = fileData != null ? jsonDecode(fileData) : [];
    List<Photo> array =
        fileDataDecode.map<Photo>((photo) => Photo.fromJson(photo)).toList();
    List<Photo> albumsPhoto = [];
    for (Photo photo in array) {
      if (photo.albumId == albumId) {
        albumsPhoto.add(photo);
      }
    }

    if (albumsPhoto.isEmpty) {
      photosLoad = await loadData('/albums/$albumId/photos');
      final newLoadedComments = jsonDecode(photosLoad);
      albumsPhoto = newLoadedComments
          .map<Photo>((photo) => Photo.fromJson(photo))
          .toList();
      for (Photo photo in albumsPhoto) {
        array.add(photo);
      }
      final listCommentsString = jsonEncode(array);
      await _prefs.setString('myPhotos', listCommentsString);
    }
    return albumsPhoto;
  }
}
