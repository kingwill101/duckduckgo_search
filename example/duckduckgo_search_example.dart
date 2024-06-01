import 'package:duckduckgo_search/duckduckgo_search.dart';

void main() {
  var search = DuckDuckGoSearch();
  search.text('reddit.com/r/dartlang', maxResults: 1).then((value) {
    for (var entry in value) {
      print("Title: ${entry.title}");
      print("Link: ${entry.link}");
      print("Body: ${entry.body}");
    }
  });
}
