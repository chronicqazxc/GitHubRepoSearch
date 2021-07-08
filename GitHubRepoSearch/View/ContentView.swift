//
//  ContentView.swift
//  GitHubRepoSearch
//
//  Created by YuHan Hsiao on 2021/07/06.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var githubSearch: GitHubSearch
    
    var body: some View {
        VStack {
            VStack {
                Text(githubSearch.display)
                    .frame(alignment: .center)
                Picker("Search Type", selection: $githubSearch.searchType) {
                    ForEach(githubSearch.searchTypes, id: \.self) { keyword in
                        Text(keyword)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Search", text: $githubSearch.keyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            .padding()
            
            List {
                ForEach(githubSearch.repos, id: \.self.id) { repo in
                    RepoView(repo: repo)
                        .onAppear {
                            if repo.id == self.githubSearch.repos.last?.id {
                                self.githubSearch.getMore()
                            }
                        }
                }
            }
        }
    }
}
