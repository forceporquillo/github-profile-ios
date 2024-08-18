//
//  RepositoryListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/31/24.
//

import SwiftUI

struct RepositoryListView : View {
    
    let repoState: UserRepoStore
    let username: String
    
    var body: some View {
        LazyVStack {
            switch repoState.state.viewState {
            case .initial:
                showLoadingView
            case .loaded(let oldRepos):
                displayRepositories(oldRepos, true)
            case .success(let repos):
                displayRepositories(repos, false)
            case .endOfPaginatedReached(let lastData):
                displayRepositories(lastData, false, true)
            default:
                EmptyView()
            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.visible)
    }
    
    @ViewBuilder
    private func displayRepositories(_ repos: [UserReposUiModel], _ showLoading: Bool, _ endOfPaginationReached: Bool = false) -> some View {
        if showLoading {
            showLoadingView
        }
        ForEach(repos, id: \.id) { repository in
            RepositoryItemView(repository: repository)
                .onAppear {
                    if repository.id == repos.last?.id {
                        if !endOfPaginationReached {
                            // requestMore()
                        }
                    }
                }
        }
        if !endOfPaginationReached {
            showLoadingView.onAppear {
                repoState.send(.loadPage(username: username))
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

#if DEBUG
struct RepositoryListViewPreview : View {
    
    let username = "forceporquillo"
    
    let usersStore = GenericStore(
        initialState: UserDetailsGenericState<UserReposUiModel>(viewState: .initial),
        reduce: userRepoReducer
    )
    
    var body: some View {
        ScrollView {
            RepositoryListView(repoState: usersStore, username: username)
        }
        .task {
            usersStore.send(.loadPage(username: username))
        }
    }
}

#Preview {
    RepositoryListViewPreview()
}

#endif
