import 'package:dio/dio.dart';
import 'package:duckduckgo_search/src/models/search_result.dart';
import 'package:duckduckgo_search/src/utilities.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

/// Performs a search on the HTML backend using the provided [dio] client.
///
/// The [keywords] parameter specifies the search terms.
/// The [region] parameter specifies the region to search in, defaulting to "wt-wt".
/// The [timelimit] parameter specifies an optional time limit for the search.
/// The [maxResults] parameter specifies an optional maximum number of results to return.
///
/// Returns the search results asynchronously.
Future<List<SearchResult>> textHtml(
  Dio dio,
  String keywords, [
  String region = "wt-wt",
  String? timelimit,
  int? maxResults,
]) async {
  assert(keywords.isNotEmpty, "keywords is mandatory");
  final vqd = await getVqd(keywords);
  var payload = {
    "q": keywords,
    "s": "0",
    "o": "json",
    "api": "d.js",
    "vqd": vqd,
    "kl": region,
    "bing_market": region,
  };

  if (timelimit != null) {
    payload["df"] = timelimit;
  }

  var results = <SearchResult>[];

  Future<List<SearchResult>> textHtmlPage(int s) async {
    payload["s"] = "$s";

    var uri = Uri.https("html.duckduckgo.com", "/html/", payload);

    var response = await dio.postUri(uri, data: payload);

    if (response.data.contains("No more results.")) {
      return [];
    }

    String respContent = response.data;

    if (respContent.contains("No  results.")) {
      return [];
    }

    var pageResults = <SearchResult>[];

    var xpath = HtmlXPath.html(respContent);
    var elements = xpath.root
        .queryXPath(
            "//div[contains(@class, 'result results_links results_links_deep web-result')]")
        .nodes;

    for (var e in elements) {
      var titleElements = e
          .queryXPath(
              './/h2[@class="result__title"]/a[@class="result__a"]/text()')
          .nodes;
      var title = titleElements.isNotEmpty ? titleElements.first.text : "";

      var snippetElements =
          e.queryXPath('.//a[@class="result__snippet"]/text()').nodes;
      var snippet =
          snippetElements.isNotEmpty ? snippetElements.first.text : "";

      var urlElements = e.queryXPath('.//a[@class="result__url"]/@href').nodes;
      var url =
          urlElements.isNotEmpty ? urlElements.first.attributes['href'] : "";

      var iconElements = e
          .queryXPath(
              './/span[@class="result__icon"]/a/img[@class="result__icon__img"]/@src')
          .nodes;
      var icon =
          iconElements.isNotEmpty ? iconElements.first.attributes['src'] : "";

      if (url != null && url.isNotEmpty) {
        pageResults.add(SearchResult(
            title: normalize(title),
            body: normalize(snippet),
            link: normalizeUrl(url),
            icon: normalizeUrl(icon)));
      }
    }

    return pageResults;
  }

  var slist = [0];
  if (maxResults != null) {
    maxResults = maxResults.clamp(0, 2023);
    for (var s = 23; s < maxResults; s += 50) {
      slist.add(s);
    }
  }

  try {
    for (var s in slist) {
      var r = await textHtmlPage(s);
      results.addAll(r);
    }
  } catch (e) {
    rethrow;
  }

  return results.take(maxResults ?? results.length).toList();
}
