String getThumbnailUrlById(int albumId, Map<int, String> albumsLogo) {
  if (albumsLogo.isNotEmpty) {
    for (var key in albumsLogo.keys) {
      if (key == albumId) {
        return albumsLogo[key]!;
      }
    }
    return '';
  } else {
    return '';
  }
}
