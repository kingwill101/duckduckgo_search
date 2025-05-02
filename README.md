# DuckDuckGo Search

A Dart package for DuckDuckGo search API. Supports text, image, video, and news search with filters.

## Features

- Text search
- Image search with filters (size, color, type, layout, license)
- Video search with filters (resolution, duration, license)
- News search with filters (time limit, region)
- Search suggestions and instant answers
- Rate limit protection and error handling



## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  duckduckgo_search: ^0.2.0
```

Then, run `flutter pub get` or `dart pub get` to install the package.

## Usage

```dart
final search = DuckDuckGoSearch();

// Text search
final results = await search.text('dart programming');

// Image search
final images = await search.images('nature',
  size: 'Wallpaper',
  color: 'Green',
  layout: 'Wide'
);

// Video search
final videos = await search.videos('tutorials',
  resolution: 'high',
  duration: 'long'
);

// News search
final news = await search.news('technology',
  timelimit: 'd',  // last 24 hours
  region: 'wt-wt'
);

// Suggestions
final suggestions = await search.suggestions('dart');

// Instant answers
final answer = await search.answers('population of france');
```

### Contributing
Contributions are welcome! Please open an issue or submit a pull request on GitHub.

### License
This project is licensed under the MIT License. See the LICENSE file for details.

Changelog
See the CHANGELOG file for version history.

### Acknowledgements
This library is a Dart port of the Python [duckduckgo_search](https://github.com/deedy5/duckduckgo_search/) library.
