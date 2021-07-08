//
//  RepoView.swift
//  GitHubRepoSearch
//
//  Created by YuHan Hsiao on 2021/07/08.
//

import SwiftUI

struct RepoView: View {
    @EnvironmentObject var githubSearch: GitHubSearch
    let repo: GitHubRepo
    var no: String {
        if let index = githubSearch.repos.firstIndex(where: { $0.id == repo.id }) {
            return "\(index + 1)."
        }
        return ""
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(no) \(repo.full_name)")
                .font(.title2)
            if let description = repo.description {
                Text(description)
                    .font(.subheadline)
            }
            HStack {
                if let language = repo.language {
                    Text("💻 \(language)")
                        .font(.footnote)
                }
                if repo.fork {
                    Image(systemName: "tuningfork")
                        .foregroundColor(.black)
                }
                Spacer()
            }
            HStack {
                Group {
                    if repo.watchers_count > 0 {
                        Image(systemName: "eye.fill")
                            .foregroundColor(.black)
                        Text("\(repo.watchers_count)")
                            .minimumScaleFactor(0.01)
                            .font(.footnote)
                        Divider()
                    }
                    if repo.stargazers_count > 0 {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(repo.stargazers_count)")
                            .minimumScaleFactor(0.01)
                            .font(.footnote)
                        Divider()
                    }
                }
                Group {
                    if repo.forks_count > 0 {
                        Image(systemName: "tuningfork")
                            .foregroundColor(.blue)
                        Text("\(repo.forks_count)")
                            .minimumScaleFactor(0.01)
                            .font(.footnote)
                        Divider()
                    }
                    if repo.open_issues_count > 0 {
                        Image(systemName: "ant.fill")
                            .foregroundColor(.gray)
                        Text("\(repo.open_issues_count)")
                            .minimumScaleFactor(0.01)
                            .font(.footnote)
                    }
                }
                Spacer()
            }
            .frame(height: 20)
        }
    }
}
