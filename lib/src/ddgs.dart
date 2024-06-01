import 'dart:async';
import 'package:dio/dio.dart';
import 'package:duckduckgo_search/src/exceptions.dart';
import 'package:duckduckgo_search/src/backends/html.dart';
import 'package:duckduckgo_search/src/backends/json.dart';
import 'package:duckduckgo_search/src/models/answer.dart';
import 'package:duckduckgo_search/src/models/search_result.dart';
import 'dart:convert';
import 'backends/lite.dart';

class DuckDuckGoSearch {
  final Dio _dio;
  final String? proxy;
  final Map<String, String> headers;
  final int timeout;

  DuckDuckGoSearch({
    Map<String, String>? headers,
    this.proxy,
    this.timeout = 10000,
  })  : headers = headers ?? {},
        _dio = Dio(BaseOptions(
          headers: headers ?? {},
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        )) {
    this.headers['Referer'] = 'https://duckduckgo.com/';
    _dio.options.headers = this.headers;
    if (proxy != null) {
      // _dio.options.proxy = proxy;
    }
  }

  /// Performs a search on DuckDuckGo and returns a list of search results.
  ///
  /// This method supports different backends for the search, including the DuckDuckGo API,
  /// HTML parsing, and a lightweight version. The method takes various parameters to
  /// customize the search, such as the keywords, region, safe search setting, time limit,
  /// and maximum number of results.
  ///
  /// If an invalid backend is specified, a [DuckDuckGoSearchException] is thrown.
  ///
  /// Parameters:
  /// - [keywords]: The search keywords.
  /// - [region]: The region to search in, defaults to 'wt-wt'.
  /// - [safesearch]: The safe search setting, defaults to 'moderate'.
  /// - [timelimit]: An optional time limit for the search.
  /// - [backend]: The backend to use for the search, defaults to 'api'.
  /// - [maxResults]: An optional maximum number of results to return.
  ///
  /// Returns:
  /// A list of [SearchResult] objects representing the search results.
  Future<List<SearchResult>> text(
    String keywords, {
    String region = 'wt-wt',
    String safesearch = 'moderate',
    String? timelimit,
    String backend = 'api',
    int? maxResults,
  }) async {
    if (backend == 'api') {
      return textApi(_dio, keywords, region, safesearch, timelimit, maxResults);
    } else if (backend == 'html') {
      return textHtml(_dio, keywords, region, timelimit, maxResults);
    } else if (backend == 'lite') {
      return textLite(_dio, keywords, region, timelimit, maxResults);
    } else {
      throw DuckDuckGoSearchException('Invalid backend: $backend');
    }
  }

  /// Retrieves a list of suggestions based on the provided keywords.
  ///
  /// This function sends a request to the DuckDuckGo autocomplete API to fetch a list of suggestions
  /// matching the provided keywords. The suggestions are returned as a list of strings.
  ///
  /// Parameters:
  /// - `keywords`: The search keywords to use for retrieving suggestions.
  /// - `region`: The region code to use for the search, defaults to "wt-wt".
  ///
  /// Returns:
  /// A Future that completes with a list of suggestion strings.
  Future<List> suggestions(
    String keywords, {
    String region = "wt-wt",
  }) async {
    assert(keywords.isNotEmpty, "keywords is mandatory");

    var payload = {
      "q": keywords,
      "kl": region,
    };

    var uri = Uri.https("duckduckgo.com", "/ac/", payload);

    var response = await _dio.getUri(uri);

    if (response.statusCode == 200) {
      var decoded = json.decode(response.data) as List<dynamic>;
      return decoded.map((e) => e['phrase']).toList();
    } else {
      return [];
    }
  }

  /// Fetches answers from the DuckDuckGo API based on the provided keywords.
  ///
  /// This method sends a request to the DuckDuckGo API to retrieve information related to the
  /// provided keywords. It returns an [Answer] object containing the API response data.
  ///
  /// Throws an [Exception] if the API request fails or the response status code is not 200 (OK).
  ///
  /// Parameters:
  /// - [keywords]: The search keywords to use for the API request.
  ///
  /// Returns:
  /// A [Future] that completes with an [Answer] object containing the API response data.
  Future<Answer> answers(String keywords) async {
    assert(keywords.isNotEmpty, "keywords is mandatory");

    var payload = {
      "q": keywords,
      "format": "json",
    };

    var uri = Uri.https("api.duckduckgo.com", "/", payload);
    var response = await _dio.getUri(uri);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch related topics");
    }

    var pageData = json.decode(response.data) as Map<String, dynamic>;

    return Answer.fromJson(pageData);
  }
}
