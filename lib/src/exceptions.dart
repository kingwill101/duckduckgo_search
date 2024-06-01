class DuckDuckGoSearchException implements Exception {
  String? message;

  DuckDuckGoSearchException([this.message = 'an error occured']);
  @override
  String toString() {
    return "DuckDuckGoException: $message";
  }
}

class RateLimitException extends DuckDuckGoSearchException {
  RateLimitException([super.message = 'Rate limit reached']);
}

class TimeoutException extends DuckDuckGoSearchException {
  TimeoutException([super.message = 'request timeout']);
}



