
# GitHubRepoSearch

GitHubRepoSearch is an iOS demo project that leverage GitHub API to search GitHub repositories by user/org name or keywords.

In this project you will learn how to use **Combine**, **SwiftUI** and other iOS development skills.

## Requirements
* iOS 14.0+
* Swift 5.0+

## Installation & Configuration
Git clone and replace the GitHub access token in the `GitHubRepoSearchApp.swift`.

```swift
ContentView()
    .environmentObject(GitHubSearch(apiKey: "your_github_access_token"))
```

## Point of the project

* Incremental Search (FAYT).
* API request throttling.
* No 3rd party dependencies.
* Dependency injection in API layer for unit test. 

## Project Architecture
* **View:** `ContentView`, `RepoView` contains search text field and result list. Bind UI elements with `GitHubSearch`.
* **Model**: `GitHubSearch` interact with UI, Model, API. Update UI whenever data changed.

## License
[MIT](https://choosealicense.com/licenses/mit/)
