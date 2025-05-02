class ImageResult {
  final String title;
  final String image;
  final String thumbnail;
  final String url;
  final int height;
  final int width;
  final String source;

  ImageResult({
    required this.title,
    required this.image,
    required this.thumbnail,
    required this.url,
    required this.height,
    required this.width,
    required this.source,
  });

  Map<String, String> toJson() {
    return {
      'title': title,
      'image': image,
      'thumbnail': thumbnail,
      'url': url,
      'height': height.toString(),
      'width': width.toString(),
      'source': source,
    };
  }

  factory ImageResult.fromJson(Map<String, dynamic> json) {
    return ImageResult(
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      url: json['url'] ?? '',
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
      source: json['source'] ?? '',
    );
  }
}
