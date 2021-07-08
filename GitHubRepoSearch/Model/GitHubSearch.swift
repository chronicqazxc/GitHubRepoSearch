//
//  GitHubSearch.swift
//  GitHubRepoSearch
//
//  Created by YuHan Hsiao on 2021/07/06.
//

import Foundation
import Combine

enum Status {
    case idle, getMore
}

final class GitHubSearch: ObservableObject {
    @Published var searchType: String = "owner"
    @Published var keyword: String! = ""
    @Published var display: String = "Start type to search"
    @Published var repos = [GitHubRepo]()
    let searchTypes = ["owner", "keyword"]
    var urlSession: URLSessionProtocol = URLSession.shared
    private var status = Status.idle
    private var disposables: Set<AnyCancellable> = Set()
    private var currentPage = 1
    private let apiKey: String
    private var headers: [String: String]? {
        apiKey == "your_github_access_token" ? nil : ["Authorization": "token \(apiKey)"]
    }
    private var url: URL {
        let searchKeyword = keyword.contains(" ") ? "\"\(keyword!)\"" : keyword
        let searchValue = searchType == "owner" ? "user:\(searchKeyword!) org:\(searchKeyword!) fork:true" : "\(searchKeyword!) fork:true"
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/search/repositories"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(searchValue)"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "per_page", value: "100"),
        ]
        return urlComponents.url!
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
        $searchType
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
                self?.refresh()
            })
            .store(in: &self.disposables)

        $keyword
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
                self?.refresh()
            })
            .store(in: &self.disposables)
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.display = "Searching..."
        }
        self.currentPage = 1
        API.shared.get(url: self.url, headers: self.headers, session: urlSession) { data, response in
            self.status = .idle
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    let gitHubRepos = try! JSONDecoder().decode(GitHubRepos.self, from: data)
                    self.display = "Finished"
                    self.repos = gitHubRepos.items
                } else {
                    let messageData = try! JSONDecoder().decode(Message.self, from: data)
                    self.display = messageData.errors?.first?.message ?? messageData.message
                    self.repos = []
                }
            }
        }
    }
    
    func getMore() {
        guard status == .idle else {
            return
        }
        currentPage += 1
        self.display = "Getting next page"
        self.status = .getMore
        API.shared.get(url: self.url, headers: self.headers, session: urlSession) { data, response in
            self.status = .idle
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    let gitHubRepos = try? JSONDecoder().decode(GitHubRepos.self, from: data)
                    self.display = "Finished"
                    self.repos += gitHubRepos?.items ?? []
                } else {
                    let errorData = try! JSONDecoder().decode(Message.self, from: data)
                    self.display = errorData.message
                    self.currentPage -= 1
                }
            }
        }
    }
}
