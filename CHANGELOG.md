# Changelog

## 0.2.0

* Added image search support with filters for size, color, type, layout, and license
* Added sleep between requests (0.75s) to prevent rate limiting
* Improved error handling:
  * Better detection and reporting of rate limits (status codes 202, 301, 403, 400, 429, 418)
  * Proper timeout error handling
  * More descriptive error messages with URLs and status codes
* Added User-Agent header to better mimic browser requests

## 0.1.4
- Support both DuckDuckGo response formats for JSON extraction #6 

## 0.1.3
- fix missing converter on properties

## 0.1.1
- Add model converters
- fix html to text conversion

## 0.1.0

* Initial version.
* Support for text search with multiple backends (JSON, HTML, Lite)
* Support for suggestions and answers
