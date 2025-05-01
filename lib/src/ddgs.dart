import 'dart:async';
import 'package:dio/dio.dart';
import 'package:duckduckgo_search/src/exceptions.dart';
import 'package:duckduckgo_search/src/backends/html.dart';
import 'package:duckduckgo_search/src/backends/json.dart';
import 'package:duckduckgo_search/src/models/answer.dart';
import 'package:duckduckgo_search/src/models/search_result.dart';
import 'package:duckduckgo_search/src/models/image_result.dart';
import 'package:duckduckgo_search/src/models/video_result.dart';
import 'dart:convert';
import 'backends/lite.dart';
import 'utilities.dart';

class DuckDuckGoSearch {
  final Dio _dio;
  final String? proxy;
  final Map<String, String> headers;
  final int timeout;
  double _sleepTimestamp = 0.0;

  DuckDuckGoSearch({
    Map<String, String>? headers,
    this.proxy,
    this.timeout = 10000,
  })  : headers = headers ?? {},
        _dio = Dio(BaseOptions(
          headers: headers ??
              {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
              },
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        )) {
    this.headers['Referer'] = 'https://duckduckgo.com/';
    _dio.options.headers = this.headers;
    if (proxy != null) {
      // _dio.options.proxy = proxy;
    }

    // Add request interceptor for sleep between requests
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        await _sleep();
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final url = response.requestOptions.uri.toString();

        if (response.statusCode == 200) {
          return handler.next(response);
        }

        // Handle rate limits and related errors
        if ([202, 301, 403, 400, 429, 418].contains(response.statusCode)) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error:
                  RateLimitException('$url ${response.statusCode} Ratelimit'),
              response: response,
            ),
          );
        }

        // Handle all other non-200 responses
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: DuckDuckGoSearchException(
              '$url return None. params=${response.requestOptions.queryParameters} content=${response.data} data=${response.data}',
            ),
            response: response,
          ),
        );
      },
      onError: (error, handler) {
        final url = error.requestOptions.uri.toString();

        // Handle timeout errors
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            (error.message?.toLowerCase().contains('time') ?? false)) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: TimeoutException(
                  '$url ${error.runtimeType}: ${error.message}'),
              type: error.type,
            ),
          );
        }

        // Handle rate limit errors that might come through error callback
        if (error.response != null &&
            [202, 301, 403, 400, 429, 418]
                .contains(error.response?.statusCode)) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: RateLimitException(
                  '${error.requestOptions.uri} ${error.response?.statusCode} Ratelimit'),
              response: error.response,
            ),
          );
        }

        // Handle all other errors
        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: DuckDuckGoSearchException(
                '$url ${error.runtimeType}: ${error.message}'),
            type: error.type,
          ),
        );
      },
    ));
  }

  /// Sleep between API requests to avoid rate limiting
  Future<void> _sleep([double sleepTime = 0.75]) async {
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final delay = _sleepTimestamp == 0.0 || (now - _sleepTimestamp) >= 20
        ? 0.0
        : sleepTime;
    _sleepTimestamp = now;
    if (delay > 0) {
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
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

  /// DuckDuckGo images search. Query params: https://duckduckgo.com/params
  ///
  /// Args:
  ///   keywords: keywords for query.
  ///   region: wt-wt, us-en, uk-en, ru-ru, etc. Defaults to "wt-wt".
  ///   safesearch: on, moderate, off. Defaults to "moderate".
  ///   timelimit: Day, Week, Month, Year. Defaults to null.
  ///   size: Small, Medium, Large, Wallpaper. Defaults to null.
  ///   color: color, Monochrome, Red, Orange, Yellow, Green, Blue,
  ///       Purple, Pink, Brown, Black, Gray, Teal, White. Defaults to null.
  ///   typeImage: photo, clipart, gif, transparent, line. Defaults to null.
  ///   layout: Square, Tall, Wide. Defaults to null.
  ///   licenseImage: any (All Creative Commons), Public (PublicDomain),
  ///       Share (Free to Share and Use), ShareCommercially (Free to Share and Use Commercially),
  ///       Modify (Free to Modify, Share, and Use), ModifyCommercially (Free to Modify, Share, and
  ///       Use Commercially). Defaults to null.
  ///   maxResults: max number of results. If null, returns results only from the first response.
  ///
  /// Returns:
  ///   List of ImageResult objects with images search results.
  Future<List<ImageResult>> images(
    String keywords, {
    String region = 'wt-wt',
    String safesearch = 'moderate',
    String? timelimit,
    String? size,
    String? color,
    String? typeImage,
    String? layout,
    String? licenseImage,
    int? maxResults,
  }) async {
    assert(keywords.isNotEmpty, 'keywords is mandatory');

    final vqd = await getVqd(keywords);
    final safesearchBase = {
      'on': '1',
      'moderate': '1',
      'off': '-1',
    };

    final filters = [
      if (timelimit != null) 'time:$timelimit',
      if (size != null) 'size:$size',
      if (color != null) 'color:$color',
      if (typeImage != null) 'type:$typeImage',
      if (layout != null) 'layout:$layout',
      if (licenseImage != null) 'license:$licenseImage',
    ].join(',');

    final payload = {
      'l': region,
      'o': 'json',
      'q': keywords,
      'vqd': vqd,
      'f': filters,
      'p': safesearchBase[safesearch.toLowerCase()],
    };

    final cache = <String>{};
    final results = <ImageResult>[];

    for (var i = 0; i < 5; i++) {
      final response = await _dio.get(
        'https://duckduckgo.com/i.js',
        queryParameters: payload,
      );

      final respJson =
          json.decode(response.data.toString()) as Map<String, dynamic>;
      final pageData = respJson['results'] as List<dynamic>? ?? [];

      for (final row in pageData) {
        final imageUrl = row['image'] as String?;
        if (imageUrl != null && !cache.contains(imageUrl)) {
          cache.add(imageUrl);
          results.add(ImageResult(
            title: row['title'] ?? '',
            image: normalizeUrl(imageUrl),
            thumbnail: normalizeUrl(row['thumbnail'] ?? ''),
            url: normalizeUrl(row['url'] ?? ''),
            height: row['height'] ?? 0,
            width: row['width'] ?? 0,
            source: row['source'] ?? '',
          ));

          if (maxResults != null && results.length >= maxResults) {
            return results;
          }
        }
      }

      final next = respJson['next'] as String?;
      if (next == null || maxResults == null) {
        return results;
      }

      // Update payload with next page token
      payload['s'] = next.split('s=')[1].split('&')[0];
    }

    return results;
  }

  /// DuckDuckGo videos search. Query params: https://duckduckgo.com/params
  ///
  /// Args:
  ///   keywords: keywords for query.
  ///   region: wt-wt, us-en, uk-en, ru-ru, etc. Defaults to "wt-wt".
  ///   safesearch: on, moderate, off. Defaults to "moderate".
  ///   timelimit: d, w, m. Defaults to null.
  ///   resolution: high, standart. Defaults to null.
  ///   duration: short, medium, long. Defaults to null.
  ///   licenseVideos: creativeCommon, youtube. Defaults to null.
  ///   maxResults: max number of results. If null, returns results only from the first response.
  ///
  /// Returns:
  ///   List of VideoResult objects with videos search results.
  Future<List<VideoResult>> videos(
    String keywords, {
    String region = 'wt-wt',
    String safesearch = 'moderate',
    String? timelimit,
    String? resolution,
    String? duration,
    String? licenseVideos,
    int? maxResults,
  }) async {
    assert(keywords.isNotEmpty, 'keywords is mandatory');

    final vqd = await getVqd(keywords);
    final safesearchBase = {
      'on': '1',
      'moderate': '-1',
      'off': '-2',
    };

    final filters = [
      if (timelimit != null) 'publishedAfter:$timelimit',
      if (resolution != null) 'videoDefinition:$resolution',
      if (duration != null) 'videoDuration:$duration',
      if (licenseVideos != null) 'videoLicense:$licenseVideos',
    ].join(',');

    final payload = {
      'l': region,
      'o': 'json',
      'q': keywords,
      'vqd': vqd,
      'f': filters,
      'p': safesearchBase[safesearch.toLowerCase()],
    };

    final results = <VideoResult>[];
    final cache = <String>{};

    for (var i = 0; i < 8; i++) {
      final response = await _dio.get(
        'https://duckduckgo.com/v.js',
        queryParameters: payload,
      );

      final respJson =
          json.decode(response.data.toString()) as Map<String, dynamic>;
      final pageData = respJson['results'] as List<dynamic>? ?? [];

      for (final row in pageData) {
        final content = row['content'] as String;
        if (!cache.contains(content)) {
          cache.add(content);
          results.add(VideoResult.fromJson(row));
          if (maxResults != null && results.length >= maxResults) {
            return results;
          }
        }
      }

      final next = respJson['next'] as String?;
      if (next == null || maxResults == null) {
        return results;
      }

      // Update payload with next page token
      payload['s'] = next.split('s=')[1].split('&')[0];
    }

    return results;
  }
}
