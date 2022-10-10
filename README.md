# News: a simple news feed application

## Getting started

This project targets iOS 16 for convenience.

You can download the project, open it and build straight away on Xcode 14, but you need to set up a `newsapi.org` API key before you're able to fetch any news articles.

TL;DR:

1. Set up an account at https://newsapi.org and get your api key
2. Clone the project
3. Open News.xcproj
4. Open `Resources/Secrets.plist` and paste your key into the `apiKey` value field
5. Run the project, you should then see a list of news articles

## What's here

- A basic SwiftUI news feed with pull to refresh - tap an article to bring the original link up
- A basic wrapper around `SFSafariViewController` to use it from SwiftUI
- A pair of vanilla XCTest-based tests for the feed ViewModel

## What can be improved
- Project generation using Tuist or Xcodegen to make commits truly atomic
- Retrieval of API keys from environment variables so we can more easily avoid including it into the repository history
- NewsAPI isn't consistent about date format - some sources include a timezone while others don't
    - This can be worked around, didn't for simplicity and hardcoded the WSJ as a source
- No caching or offline support for the feed
- We should add more tests down the stack
- This project was my first using SwiftUI in a while, so feel free to let me know what can be improved in terms of making the code simpler or more idiomatic :)

