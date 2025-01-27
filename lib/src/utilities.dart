import 'dart:convert';

import 'package:duckduckgo_search/src/exceptions.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html_unescape/html_unescape_small.dart';
import 'package:http/http.dart' as http;

/// Normalizes a raw HTML string by stripping HTML tags and unescaping HTML entities.
///
/// If the [rawHtml] parameter is `null` or an empty string, an empty string is returned.
///
/// The function first strips all HTML tags from the input string using a regular expression.
/// It then unescapes any HTML entities in the resulting string using the [HtmlUnescape] class.
///
/// This function is useful for cleaning up HTML content before displaying it in a user interface.
///
/// Parameters:
/// - [rawHtml]: The raw HTML string to be normalized.
///
/// Returns:
/// The normalized string with HTML tags removed and HTML entities unescaped.
String normalize(String? rawHtml) {
  if (rawHtml == null || rawHtml.isEmpty) return "";
  var parsedHtml = htmlParser.parse(rawHtml).body?.text ?? '';
  return parsedHtml;
}

/// Normalizes a URL by decoding any encoded characters and replacing spaces with plus signs.
///
/// If the input [url] is `null` or empty, an empty string is returned.
///
/// Throws an exception if the URL cannot be normalized for any reason.
String normalizeUrl(String? url) {
  if (url == null || url.isEmpty) return "";
  try {
    return Uri.decodeFull(url.replaceAll(" ", "+"));
  } catch (e) {
    return "";
  }
}

/// Retrieves the VQD (Vague Query Detection) value from the DuckDuckGo search engine
/// for the given keywords.
///
/// The VQD is a value returned by DuckDuckGo that indicates how vague or ambiguous
/// the search query is. A higher VQD value suggests the query is more ambiguous.
///
/// This function sends a POST request to the DuckDuckGo search endpoint with the
/// provided keywords, and then extracts the VQD value from the response body.
///
/// Args:
///   keywords (String): The search keywords to retrieve the VQD for.
///
/// Returns:
///   Future<String>: The VQD value as a string.
Future<String> getVqd(String keywords) async {
  var data = await http.post(Uri.parse('https://duckduckgo.com'), body: {'q': keywords});

  return _extractVqd(data.body, keywords);
}

/// Extracts the 'vqd' value from the given response content and keywords.
///
/// The 'vqd' value is a unique identifier used by DuckDuckGo for search queries.
/// This method attempts to extract the 'vqd' value from the provided response content
/// using a regular expression. If the 'vqd' value is not found or is null, a
/// [DuckDuckGoSearchException] is thrown.
///
/// Parameters:
/// - [respContent]: The response content to search for the 'vqd' value.
/// - [keywords]: The search keywords used to generate the response content.
///
/// Returns:
/// The extracted 'vqd' value as a string.
///
/// Throws:
/// - [DuckDuckGoSearchException] if the 'vqd' value is not found or is null.
String _extractVqd(String respContent, String keywords) {
  var s = RegExp(r'&vqd=([0-9,-]+)&');
  // s.hasMatch(b);
  var m = s.firstMatch(respContent);

  if (m != null) {
    var vqd = m.group(1); // Group 1 contains the value of vqd

    if (vqd == null) throw DuckDuckGoSearchException('vqd value is null');
    return vqd;
  } else {
    throw DuckDuckGoSearchException('_extractVqd() failed to extract vqd for: $keywords');
  }
}

/// Extracts a list of dynamic objects from a JSON string within a larger string.
///
/// This function takes a [content] string and a [keywords] string, and extracts a
/// JSON-encoded list of dynamic objects from the [content] string. It does this by
/// finding the substring that starts with "DDG.pageLayout.load('d'," and ends with
/// ");DDG.duckbar.load(", and then decoding that substring as a JSON list.
///
/// The extracted list is returned as a [List<dynamic>].
List<dynamic> textExtractJson(String content, String keywords) {
  int start = content.indexOf("DDG.pageLayout.load('d',") + 24;
  // int end = content.indexOf(");DDG.duckbar.load(", start);

// End condition 1: );DDG.duckbar.load(
  int end1 = content.indexOf(");DDG.duckbar.load(", start);
// End condition 2: );DDG.duckbar.loadModule(
  int end2 = content.indexOf(");DDG.duckbar.loadModule(", start);
// Select the earliest end position
  int end;
  if (end1 != -1 && (end2 == -1 || end1 < end2)) {
    end = end1;
  } else if (end2 != -1) {
    end = end2;
  } else {
    throw ArgumentError("End tag not found.");
  }

  String data = content.substring(start, end);
  var aa = jsonDecode(data) as List<dynamic>;
  return aa;
}
