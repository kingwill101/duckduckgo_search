import 'package:dio/dio.dart';
import 'package:duckduckgo_search/src/models/search_result.dart';
import 'package:duckduckgo_search/src/utilities.dart';

/// Performs a text-based search using the DuckDuckGo API.
///
/// This function sends a search request to the DuckDuckGo API and returns a list of
/// [SearchResult] objects representing the search results.
///
/// The [keywords] parameter specifies the search query.
/// The [region] parameter specifies the region to search in.
/// The [safesearch] parameter specifies the safe search level (one of 'moderate', 'off', or 'on').
/// The [timelimit] parameter specifies a time limit for the search (e.g. 'w' for the past week).
/// The [maxResults] parameter specifies the maximum number of results to return.
///
/// The function returns a [Future] that completes with a list of [SearchResult] objects.
Future<List<SearchResult>> textApi(
  Dio dio,
  String keywords,
  String region,
  String safesearch,
  String? timelimit,
  int? maxResults,
) async {
  final vqd = await getVqd(keywords);
  final payload = {
    'q': keywords,
    'kl': region,
    'l': region,
    'p': '',
    's': '0',
    'df': '',
    'vqd': vqd,
    'bing_market': region,
    'ex': '',
  };

  if (safesearch == 'moderate') {
    payload['ex'] = '-1';
  } else if (safesearch == 'off') {
    payload['ex'] = '-2';
  } else if (safesearch == 'on') {
    payload['p'] = '1';
  }
  if (timelimit != null) {
    payload['df'] = timelimit;
  }

  final cache = <String>{};
  final results = <SearchResult>[];

  Future<List<SearchResult>> _textApiPage(int s) async {
    payload['s'] = '$s';

    var uri = Uri.https("links.duckduckgo.com", "/d.js", payload);

    var response = await dio.getUri(uri, data: payload);

    if (response.data.contains("No more results.")) {
      return [];
    }

    final pageData = textExtractJson(response.data, keywords);
    final pageResults = <SearchResult>[];
    for (final row in pageData) {
      final href = row['u'];
      if (href != null &&
          !cache.contains(href) &&
          href != 'http://www.google.com/search?q=$keywords') {
        cache.add(href);
        final body = normalize(row['a'] ?? '');
        if (body.isNotEmpty) {
          pageResults.add(SearchResult(
              title: normalize(row['t'] ?? ''),
              body: normalize(body),
              link: normalizeUrl(href)));
        }
      }
    }
    return pageResults;
  }

  final slist = [0];
  if (maxResults != null) {
    final max = maxResults.clamp(0, 2023);
    slist.addAll(List.generate((max - 23) ~/ 50, (i) => 23 + i * 50));
  }

  for (final s in slist) {
    final r = await _textApiPage(s);
    results.addAll(r);
  }

  return results.take(maxResults ?? results.length).toList();
}
