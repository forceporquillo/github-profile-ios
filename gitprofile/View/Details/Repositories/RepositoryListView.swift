//
//  RepositoryListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/31/24.
//

import SwiftUI

struct RepositoryListView : View {
    
    let repositories: LoadableViewState<[UserReposUiModel]>
    let requestMore: () -> Void
    
    var body: some View {
        LazyVStack {
            if case LoadableViewState.initial = repositories {
                self.showLoadingView
            } else if case let LoadableViewState.loaded(oldRepos) = repositories {
                displayRepositories(oldRepos, true)
            } else if case let LoadableViewState.success(repos) = repositories {
                displayRepositories(repos, false)
            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.visible)
        
    }

    @ViewBuilder
    private func displayRepositories(_ repos: [UserReposUiModel], _ showLoading: Bool) -> some View {
        if showLoading {
            showLoadingView
        }
        ForEach(repos, id: \.id) { repository in
            RepositoryItemView(repository: repository)
                .onAppear {
                    if repository.id == repos.last?.id {
                        requestMore()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var showLoadingView: some View {
        ProgressView()
            .padding(10)
            .progressViewStyle(.circular)
    }
}

#Preview {
    RepositoryListView(repositories: LoadableViewState.initial) {}
}
