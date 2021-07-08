//
//  GitHubRepoSearchApp.swift
//  GitHubRepoSearch
//
//  Created by YuHan Hsiao on 2021/07/06.
//

import SwiftUI

@main
struct GitHubRepoSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GitHubSearch(apiKey: "your_github_access_token"))
        }
    }
}
