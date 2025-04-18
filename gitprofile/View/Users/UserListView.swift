//
//  UserListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import SwiftUI

struct UserListView: View {
    
    @State private var usersStore: UserStore
    @StateObject private var searchAppStore: SearchUserProxyStore
    
    @State private var selectedUser = ""
    @State private var shouldShowDestination = false
    @State private var searchQuery = ""
    @State private var defaultQueryHint = String(describing: Bundle.main.infoDictionary?["USERNAME"] ?? "")
    
    @Environment(\.isSearching) private var isSearching
    
    init() {
        let initialUsersStore = UserStore(
            initialState: .init(viewState: .initial),
            reduce: userReducer
        )
        _usersStore = State(initialValue: initialUsersStore)
        _searchAppStore = StateObject(wrappedValue: SearchUserProxyStore(userStore: initialUsersStore))
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("GitHub Users")
                .navigationDestination(isPresented: $shouldShowDestination) {
                    UserDetailsView(user: selectedUser)
                }
        }
        .searchable(text: $searchQuery, prompt: "Search profile (e.g. \(defaultQueryHint))")
        .onSubmit(of: .search) {
            searchAppStore.dispatch(query: searchQuery)
        }
        .onChange(of: searchQuery) {
            if searchQuery.isEmpty {
                usersStore.send(.paginate)
            } else {
                searchAppStore.dispatch(query: searchQuery)
            }
        }
        .task {
            usersStore.send(.paginate)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch usersStore.state.viewState {
        case.initial:
            ProgressView()
                .progressViewStyle(.circular)
        case .success(let users):
            listView(users: users, true)
        case .failure(let message):
            VStack {
                Text("Ops! Sorry, we run into an error")
                    .font(.title2)
                Text(message)
                    .multilineTextAlignment(.center)
                    .font(.caption)
            }.padding(.horizontal, 16)
        case .loaded(let users):
            listView(users: users, false)
        case .endOfPaginatedReached(_):
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func listView(users: [UserUiModel], _ showLoading: Bool) -> some View {
        SearchAwareListView(
            users: users,
            showLoading: showLoading,
            showRecentSearchTitle: usersStore.state.lastAction == .recentSearch,
            selectedUser: $selectedUser,
            shouldShowDestination: $shouldShowDestination,
            searchQuery: $searchQuery,
            onSearchAction: { action in
                usersStore.send(action)
            }
        )
    }
}

struct SearchAwareListView : View {
    
    @Environment(\.isSearching) private var isSearching
    
    let users: [UserUiModel]
    let showLoading: Bool
    let showRecentSearchTitle: Bool
    
    @Binding var selectedUser: String
    @Binding var shouldShowDestination: Bool
    @Binding var searchQuery: String
    
    let onSearchAction: (UserAction) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            if !users.isEmpty, showRecentSearchTitle {
                Text("Recent Searches...")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)
            }
            List {
                ForEach(users, id: \.id) { user in
                    UserCardView(user: user) {
                        self.selectedUser = user.login
                        self.shouldShowDestination = true
                    }
                }
                if showLoading {
                    HStack {
                        ProgressView().onAppear {
                            Task {
                                if searchQuery.isEmpty {
                                    onSearchAction(.paginate)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
        .onChange(of: isSearching) { _, isSearching in
            onSearchAction(isSearching ? .recentSearch : .paginate)
        }
    }
}
