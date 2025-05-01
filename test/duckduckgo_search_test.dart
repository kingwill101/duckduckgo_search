import 'package:duckduckgo_search/duckduckgo_search.dart';
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
}
