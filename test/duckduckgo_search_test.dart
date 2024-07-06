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
