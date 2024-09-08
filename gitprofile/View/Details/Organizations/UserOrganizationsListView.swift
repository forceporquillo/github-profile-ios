//
//  UserOrganizationsListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import SwiftUI

struct UserOrganizationsListView: View {
    
    let organizations: LoadableViewState<[UserOrgsUiModel]>
    let requestMore: () -> Void
    
    var body: some View {
        LazyVStack {
            if case let LoadableViewState.loaded(oldOrgs) = organizations {
                displayOrganizations(oldOrgs, true)
            } else if case let LoadableViewState.success(orgs) = organizations {
                displayOrganizations(orgs, false)
            } else if case let LoadableViewState.endOfPaginatedReached(lastData) = organizations {
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
                        requestMore()
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

//#Preview {
////    UserOrganizationsListView(organizations: [LoadableViewState<[UserOrgsUiModel]>])
//}
