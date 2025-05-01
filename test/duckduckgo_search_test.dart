import 'package:duckduckgo_search/duckduckgo_search.dart';
import 'package:duckduckgo_search/src/models/video_result.dart';
import 'package:duckduckgo_search/src/models/news_result.dart';
import 'package:test/test.dart';

void main() {
  var search = DuckDuckGoSearch();
  var term = 'reddit.com/r/dartlang';
  group('Text search', () {
    test('api backend', () async {
      expect(await search.text(term), isNotEmpty);
    });

    test('html backend', () async {
      expect(await search.text(term, backend: 'html'), isNotEmpty);
    });

    test('lite backend', () async {
      expect(await search.text(term, backend: 'lite'), isNotEmpty);
    });
  });

  group('Image search', () {
    test('basic image search', () async {
      var results = await search.images('dart programming language');
      expect(results, isNotEmpty);
      expect(results.first.title, isNotEmpty);
      expect(results.first.image, contains('http'));
      expect(results.first.thumbnail, contains('http'));
      expect(results.first.url, contains('http'));
      expect(results.first.height, greaterThan(0));
      expect(results.first.width, greaterThan(0));
      expect(results.first.source, isNotEmpty);
    });

    test('image search with filters', () async {
      var results = await search.images(
        'nature',
        size: 'Wallpaper',
        color: 'Green',
        typeImage: 'photo',
        layout: 'Wide',
        maxResults: 5,
      );
      expect(results, isNotEmpty);
      expect(results.length, lessThanOrEqualTo(5));
    });

    test('image search respects maxResults', () async {
      var maxResults = 3;
      var results = await search.images(
        'programming',
        maxResults: maxResults,
      );
      expect(results.length, lessThanOrEqualTo(maxResults));
    });

    test('image search handles empty keywords', () async {
      expect(
        () => search.images(''),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('suggestions', () {
    test('get suggestions', () async {
      expect(await search.suggestions('reddit.com'), isNotEmpty);
    });
  });
  group('answers', () {
    test('get answers', () async {
      expect((await search.answers('reddit.com')).toJson(), isNotEmpty);
    });

    test('get answers without quick answers', () async {
      expect((await search.answers('tesla')).toJson(), isNotEmpty);
    });

    group('issues', () {
      test('#1', () async {
        expect(await search.text('who is the ceo of tesla'), isNotEmpty);
      });
    });
  });

  group('Video search', () {
    test('basic video search', () async {
      var results = await search.videos('dart programming tutorial');
      expect(results, isNotEmpty);
      expect(results.first.title, isNotEmpty);
      expect(results.first.content, isNotEmpty);
      expect(results.first.description, isA<String>());
      expect(results.first.duration, isA<String>());
      expect(results.first.embedHtml, isA<String>());
      expect(results.first.provider, isNotEmpty);
      expect(results.first.published, isA<String>());
      expect(results.first.statistics, isA<VideoStatistics>());
      expect(results.first.uploader, isA<String>());
      expect(results.first.embedUrl, contains('http'));
      expect(results.first.images, isA<Map<String, dynamic>>());
      expect(results.first.images.length, greaterThan(0));
    });

    test('video search with filters', () async {
      var results = await search.videos(
        'nature documentary',
        resolution: 'high',
        duration: 'long',
        timelimit: 'm',
        maxResults: 5,
      );
      expect(results, isNotEmpty);
      expect(results.length, lessThanOrEqualTo(5));
    });

    test('video search respects maxResults', () async {
      var maxResults = 3;
      var results = await search.videos(
        'cooking tutorials',
        maxResults: maxResults,
      );
      expect(results.length, lessThanOrEqualTo(maxResults));
    });

    test('video search handles empty keywords', () async {
      expect(
        () => search.videos(''),
        throwsA(isA<AssertionError>()),
      );
    });

    test('video search with different safesearch levels', () async {
      var results = await search.videos(
        'educational content',
        safesearch: 'strict',
      );
      expect(results, isNotEmpty);
    });
  });

  group('News search', () {
    test('basic news search', () async {
      var results = await search.news('dart programming language');
      expect(results, isNotEmpty);
      expect(results.first.title, isNotEmpty);
      expect(results.first.body, isNotEmpty);
      expect(results.first.date, isA<DateTime>());
      expect(results.first.url, contains('http'));
      expect(results.first.source, isNotEmpty);
    });

    test('news search with timelimit', () async {
      var results = await search.news(
        'technology news',
        timelimit: 'd',
        maxResults: 5,
      );
      expect(results, isNotEmpty);
      expect(results.length, lessThanOrEqualTo(5));
    });

    test('news search respects maxResults', () async {
      var maxResults = 3;
      var results = await search.news(
        'science discoveries',
        maxResults: maxResults,
      );
      expect(results.length, lessThanOrEqualTo(maxResults));
    });

    test('news search handles empty keywords', () async {
      expect(
        () => search.news(''),
        throwsA(isA<AssertionError>()),
      );
    });

    test('news search with different safesearch levels', () async {
      var results = await search.news(
        'world news',
        safesearch: 'strict',
      );
      expect(results, isNotEmpty);
    });
  });
}
