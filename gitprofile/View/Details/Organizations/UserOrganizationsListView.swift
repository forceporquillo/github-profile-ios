//
//  UserOrganizationsListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import SwiftUI

struct UserOrganizationsListView: View {
    
    let organizations: LoadableViewState<[UserOrgsUiModel]>
    
    var body: some View {
        LazyVStack {
            if case let LoadableViewState.loaded(oldOrgs) = organizations {
                displayOrganizations(oldOrgs, true)
            } else if case let LoadableViewState.success(orgs) = organizations {
                displayOrganizations(orgs, false)
            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(/*@START_MENU_TOKEN@*/.visible/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    private func displayOrganizations(_ orgs: [UserOrgsUiModel], _ showLoading: Bool) -> some View {
        ForEach(orgs, id: \.id) { org in
            UserOrganizationsView(org: org)
                .onAppear {
//                    if repository.id == repos.last?.id {
//                       // requestMore()
//                    }
                }
        }
        if showLoading {
            ProgressView().progressViewStyle(.circular)
        }
    }
}

//#Preview {
////    UserOrganizationsListView(organizations: [LoadableViewState<[UserOrgsUiModel]>])
//}
