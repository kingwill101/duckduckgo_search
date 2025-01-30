# duckduckgo_search

Search using the DuckDuckGo api

## Features

- searching for text.
- search suggestions.
- quick answers

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  duckduckgo_search: ^0.1.4
```


Then, run `flutter pub get` or `dart pub get` to install the package.

### Usage
Import the package in your Dart file:
```
import 'package:duckduckgo_search /duckduckgo_search.dart';
```

Perform a search:


```dart

void main() async {
  final results = await DuckDuckGoSearch.text('dartlang');
  for (var result in results) {
    print(result.title);
    print(result.url);
    print(result.body);
    print('---');
  }
}
```

Request search suggestions:

```dart
void main() async {
  final results = await DuckDuckGoSearch.suggestions('dartlang');
  for (var suggestion in results) {
   print(suggestion);
  }
}
```

quick answer:

```dart
void main() async {
  final answer = await DuckDuckGoSearch.answer('who is miles davis');
   print(answer.answerAbstract);
}
```


### Contributing
Contributions are welcome! Please open an issue or submit a pull request on GitHub.

### License
This project is licensed under the MIT License. See the LICENSE file for details.

Changelog
See the CHANGELOG file for version history.

### Acknowledgements
This library is a Dart port of the Python [duckduckgo_search](https://github.com/deedy5/duckduckgo_search/) library.
