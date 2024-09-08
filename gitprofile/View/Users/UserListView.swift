//
//  UserListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import SwiftUI

struct UserListView: View {
    
    @ObservedObject private var userViewModel = UsersViewModel()
    @ObservedObject private var detailsViewModel = UserDetailsViewModel()
    
    @State private var selectedUser = ""
    
    @State private var shouldShowDestination = false
    @State private var searchQuery = ""

    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    
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
            Task {
                await userViewModel.searchUser(query: searchQuery)
            }
        }
        .onChange(of: searchQuery) {
            if searchQuery.isEmpty {
                Task {
                    await userViewModel.fetchUsers(!isSearching)
                }
            }

        }
        .task {
            await userViewModel.fetchUsers()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch userViewModel.viewState {
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
                                await userViewModel.fetchUsers()
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
