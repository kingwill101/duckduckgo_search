import 'package:duckduckgo_search/src/utilities.dart';

class NewsResult {
  final DateTime date;
  final String title;
  final String body;
  final String url;
  final String image;
  final String source;
  final bool isOld;
  final String relativeTime;
  final String syndicate;
  final bool useRelevancy;

  NewsResult({
    required this.date,
    required this.title,
    required this.body,
    required this.url,
    required this.image,
    required this.source,
    required this.isOld,
    required this.relativeTime,
    required this.syndicate,
    required this.useRelevancy,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'body': body,
      'url': url,
      'image': image,
      'source': source,
      'isOld': isOld,
      'relativeTime': relativeTime,
      'syndicate': syndicate,
      'useRelevancy': useRelevancy,
    };
  }

  factory NewsResult.fromMap(Map<String, dynamic> map) {
    final imageUrl = map['image'] as String?;
    final timestamp = map['date'] as int;
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);

    return NewsResult(
      date: date,
      title: map['title'] ?? '',
      body: normalize(map['excerpt'] ?? ''),
      url: normalizeUrl(map['url'] ?? ''),
      image: normalizeUrl(imageUrl ?? ''),
      source: map['source'] ?? '',
      isOld: map['is_old'] == 1,
      relativeTime: map['relative_time'] ?? '',
      syndicate: map['syndicate'] ?? '',
      useRelevancy: map['use_relevancy'] == 1,
    );
  }
} 