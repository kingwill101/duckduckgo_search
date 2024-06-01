import 'dart:math';
import 'package:dio/dio.dart';
import 'package:duckduckgo_search/src/models/search_result.dart';
import 'package:duckduckgo_search/src/utilities.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

/// Performs a text-based search using the DuckDuckGo Lite API.
///
/// This function sends a search request to the DuckDuckGo Lite API and returns a list of [SearchResult] objects
/// representing the search results.
///
/// Parameters:
/// - [dio]: A [Dio] instance used to make the HTTP request.
/// - [keywords]: The search keywords.
/// - [region]: The region code for the search (default is "wt-wt").
/// - [timelimit]: An optional time limit for the search.
/// - [maxResults]: The maximum number of results to return.
///
/// Returns:
/// A [Future] that completes with a list of [SearchResult] objects representing the search results.
Future<List<SearchResult>> textLite(
  Dio dio,
  String keywords, [
  String region = "wt-wt",
  String? timelimit,
  int? maxResults,
]) async {
  assert(keywords.isNotEmpty, "keywords is mandatory");

  var payload = {
    "q": keywords,
    "s": "0",
    "o": "json",
    "api": "d.js",
    "vqd": "",
    "kl": region,
    "bing_market": region,
  };

  if (timelimit != null) {
    payload["df"] = timelimit;
  }

  var cache = <String>{};
  var results = <SearchResult>[];

  Future<List<SearchResult>> textLitePage(int s) async {
    payload["s"] = "$s";

    var uri = Uri.https("lite.duckduckgo.com", "/lite/", payload);

    var response = await dio.postUri(uri, data: payload);

    if (response.data.contains("No more results.")) {
      return [];
    }

    var pageResults = <SearchResult>[];
    var xpath = HtmlXPath.html(response.data).root;
    var elements = xpath.queryXPath("//table[last()]//tr").nodes;

    for (var i = 0; i < elements.length; i++) {
      var e = elements[i];
      if (i % 4 == 0) {
        var hrefXpath = e.queryXPath(".//a//@href").nodes;
        var href = hrefXpath.isNotEmpty ? hrefXpath.first.text : null;

        if (href == null ||
            cache.contains(href) ||
            href.startsWith("http://www.google.com/search?q=") ||
            href.startsWith("https://duckduckgo.com/y.js?ad_domain")) {
          i += 3; // Skip next 3 elements
        } else {
          cache.add(href);
          var titleXpath = e.queryXPath(".//a//text()").nodes;
          var title = titleXpath.isNotEmpty ? titleXpath.first.text : "";
          if (i + 1 < elements.length) {
            var bodyXpath = elements[i + 1]
                .queryXPath(".//td[@class='result-snippet']//text()")
                .nodes;
            var body = bodyXpath.map((x) => x.text).join("");

            pageResults.add(SearchResult(
                title: normalize(title),
                body: normalize(body),
                link: normalizeUrl(href)));
          }
        }
      }
    }

    return pageResults;
  }

  var slist = [0];
  if (maxResults != null) {
    maxResults = min(maxResults, 2023);
    for (var s = 23; s < maxResults; s += 50) {
      slist.add(s);
    }
  }

  try {
    for (var s in slist) {
      var r = await textLitePage(s);
      results.addAll(r);
    }
  } catch (e) {
    rethrow;
  }

  return results.take(maxResults ?? results.length).toList();
}
