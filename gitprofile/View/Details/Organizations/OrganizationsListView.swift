//
//  UserOrganizationsListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import SwiftUI

struct UserOrganizationsListView: View {
    
    let stateStore: UserOrgsStore
    let username: String
    
    var body: some View {
        LazyVStack {
            switch stateStore.state.viewState {
            case .initial:
                ProgressView().progressViewStyle(.circular)
            case .loaded(let oldOrgs):
                displayOrganizations(oldOrgs, true)
            case .success(let orgs):
                displayOrganizations(orgs, false)
            case .failure(let message):
                EmptyView()
            case .endOfPaginatedReached(let lastData):
                displayOrganizations(lastData, false, true)
            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(/*@START_MENU_TOKEN@*/.visible/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    private func displayOrganizations(_ orgs: [UserOrgsUiModel], _ showLoading: Bool, _ endOfPaginationReached: Bool = false) -> some View {
        if showLoading {
            ProgressView().progressViewStyle(.circular)
        }
        ForEach(orgs, id: \.id) { org in
            UserOrganizationsView(org: org)
                .onAppear {
                    if org.id == orgs.last?.id {
                        stateStore.send(.loadPage(username: username))
                    }
                }
        }
        
        if !endOfPaginationReached {
            ProgressView().progressViewStyle(.circular).onAppear {
//                requestMore()
                print("UserOrganizationsListView \(orgs.count)")
                print("OnAppear...")
            }
        }
    }
}

struct UserOrgsListView_Previews: PreviewProvider {
    static var previews: some View {
        let store = GenericStore(
            initialState: UserDetailsGenericState<UserOrgsUiModel>(viewState: .initial),
            reduce: userOrgReducer
        )
        ScrollView {
            UserOrganizationsListView(stateStore: store, username: "forceporquillo")
        }
        .task {
            store.send(.loadPage(username: "forceporquillo"))
        }
    }
}
