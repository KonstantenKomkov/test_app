String getThumbnailUrlById(int albumId, Map<int, String> albumsLogo) {
  if (albumsLogo.isNotEmpty) {
    for (final key in albumsLogo.keys) {
      if (key == albumId) {
        return albumsLogo[key]!;
      }
    }
    return '';
  } else {
    return '';
  }
}
