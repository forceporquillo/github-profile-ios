//
//  UserListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import SwiftUI

struct UserListView: View {
    
    @State private var store = UserStore(
        initialState: .init(viewState: LoadableViewState.initial),
        reduce: userReducer
    )

    @State private var selectedUser = ""
    @State private var shouldShowDestination = false
    @State private var searchQuery = ""

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("GitHub Users")
                .navigationDestination(isPresented: $shouldShowDestination) {
                    UserDetailsView(user: selectedUser)
                }
        }
        .searchable(text: $searchQuery, prompt: "Search profile (e.g. \(String(describing: Bundle.main.infoDictionary?["USERNAME"] ?? "")))")
        .onSubmit(of: .search) {
            store.send(.search(query: searchQuery))
        }
        .onChange(of: searchQuery) {
            if searchQuery.isEmpty {
                store.send(.paginate)
            }
        }
        .task {
            store.send(.paginate)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch store.state.viewState {
        case.initial:
            ProgressView()
                .progressViewStyle(.circular)
        case .success(let repos):
            listView(repos: repos, true)
        case .failure(let message):
            VStack {
                Text("Ops! Sorry, we run into an error")
                    .font(.title2)
                Text(message)
                    .multilineTextAlignment(.center)
                    .font(.caption)
            }.padding(.horizontal, 16)
        case .loaded(let oldUsers):
            listView(repos: oldUsers, false)
        case .endOfPaginatedReached(_):
            EmptyView()
        }
    }
 
    @ViewBuilder
    private func listView(repos: [UserUiModel], _ showLoading: Bool) -> some View {
        List {
            ForEach(repos, id: \.id) { user in
                UserCardView(user: user) {
                    self.selectedUser = user.login
                    self.shouldShowDestination = true
                }.listRowSeparator(.hidden)
            }
            if showLoading {
                HStack {
                    ProgressView().onAppear {
                        Task {
                            if searchQuery.isEmpty {
                                store.send(.paginate)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}
