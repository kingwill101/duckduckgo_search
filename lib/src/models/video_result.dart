class VideoStatistics {
  final int viewCount;
  const VideoStatistics({required this.viewCount});
  factory VideoStatistics.fromJson(Map<String, dynamic> json) {
    return VideoStatistics(viewCount: json['viewCount'] ?? 0);
  }
  Map<String, dynamic> toJson() {
    return {
      'viewCount': viewCount,
    };
  }
}

class VideoResult {
  final String content;
  final String description;
  final String duration;
  final String embedHtml;
  final String embedUrl;
  final String imageToken;
  final Map<String, dynamic> images;
  final String provider;
  final String published;
  final String publisher;
  final VideoStatistics statistics;
  final String title;
  final String uploader;

  VideoResult({
    required this.content,
    required this.description,
    required this.duration,
    required this.embedHtml,
    required this.embedUrl,
    required this.imageToken,
    required this.images,
    required this.provider,
    required this.published,
    required this.publisher,
    required this.statistics,
    required this.title,
    required this.uploader,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'description': description,
      'duration': duration,
      'embed_html': embedHtml,
      'embed_url': embedUrl,
      'image_token': imageToken,
      'images': images,
      'provider': provider,
      'published': published,
      'publisher': publisher,
      'statistics': statistics,
      'title': title,
      'uploader': uploader,
    };
  }

  factory VideoResult.fromJson(Map<String, dynamic> json) {
    return VideoResult(
      content: json['content'],
      description: json['description'],
      duration: json['duration'],
      embedHtml: json['embed_html'],
      embedUrl: json['embed_url'],
      imageToken: json['image_token'],
      images: json['images'],
      provider: json['provider'],
      published: json['published'],
      publisher: json['publisher'],
      statistics: VideoStatistics.fromJson(json['statistics']),
      title: json['title'],
      uploader: json['uploader'],
    );
  }
}
