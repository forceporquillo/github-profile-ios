//
//  StarredRepositoriesListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import SwiftUI

struct StarredRepositoriesListView: View {
    
    let stateStore: UserStarredStore
    let username: String
    
    var body: some View {
        LazyVStack {
            switch stateStore.state.viewState {
            case .initial:
                ProgressView().progressViewStyle(.circular)
            case .loaded(let oldRepos):
                displayStarredRepositories(oldRepos, true)
            case .success(let repos):
                displayStarredRepositories(repos, false)
            case .failure(let message):
                EmptyView()
            case .endOfPaginatedReached(let lastData):
                displayStarredRepositories(lastData, false, true)
            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(/*@START_MENU_TOKEN@*/.visible/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    private func displayStarredRepositories(_ repos: [UserStarredReposUiModel], _ showLoading: Bool, _ endOfPaginationReached: Bool = false) -> some View {
        if showLoading {
            ProgressView().progressViewStyle(.circular)
        }
        ForEach(repos, id: \.id) { repository in
            StarredReposItemView(starredRepoUiModel: repository)
        }
        if !endOfPaginationReached {
            ProgressView().progressViewStyle(.circular).onAppear {
                stateStore.send(.loadPage(username: username))
            }
        }
    }
}
