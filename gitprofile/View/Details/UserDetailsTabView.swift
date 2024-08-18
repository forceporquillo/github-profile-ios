//
//  UserDetailsTabView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/8/24.
//

import SwiftUI

struct UserDetailsTabView: View {
    
    @State private var selectedTabIndex = 0
    
    @State private var repoState = GenericStore(
        initialState: .init(viewState: .initial),
        reduce: userRepoReducer
    )

    @State private var orgState = GenericStore(
        initialState: .init(viewState: .initial),
        reduce: userOrgReducer
    )
    
    @State private var starredState = GenericStore(
        initialState: .init(viewState: .initial),
        reduce: userStarredReducer
    )
    
    let username: String
    
    var body: some View {
        VStack {
            SlidingTabView(onSelect: { tab in
                self.selectedTabIndex = tab
            })
            if selectedTabIndex == 0 {
                RepositoryListView(repoState: repoState, username: username)
            } else if selectedTabIndex == 1 {
                UserOrganizationsListView(stateStore: orgState, username: username)
            } else if selectedTabIndex == 2 {
                StarredRepositoriesListView(stateStore: starredState, username: username)
            }
        }
        .onChange(of: selectedTabIndex, initial: true) { oldIndex, newIndex in
            if newIndex == 0 {
                repoState.send(.loadPage(username: username))
            } else if newIndex == 1 {
                orgState.send(.loadPage(username: username))
            } else if newIndex == 2 {
                starredState.send(.loadPage(username: username))
            }
        }
    }
}

#Preview {
    ScrollView {
        UserDetailsTabView(username: "forceporquillo")
    }
}
