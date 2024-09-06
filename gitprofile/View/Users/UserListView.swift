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
    
    @State private var selectedUser = "" {
        didSet {
            Task {
               // await detailsViewModel.fetchDetails(username: selectedUser)
            }
        }
    }

    @State private var shouldShowDestination = false
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            Section {
                switch userViewModel.viewState {
                case.initial:
                    ProgressView()
                        .progressViewStyle(.circular)
                case .success(let repos):
                    List(repos, id: \.id) { user in
                        UserCardView(user: user) {
                            self.selectedUser = user.login
                            self.shouldShowDestination = true
                        }.onAppear {
                            if user.id == repos.last?.id {
                                userViewModel.onLoadMore()
                            }
                        }
                    }
                case .failure(let message):
                    VStack {
                        Text("Ops! Sorry, we run into an error")
                            .font(.title2)
                        Text(message)
                            .multilineTextAlignment(.center)
                            .font(.caption)
                    }.padding(.horizontal, 16)
                }
            } footer: {
                if userViewModel.showFooter {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    EmptyView()
                }
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .navigationTitle("GitHub Users")
            .searchable(text: $searchQuery, prompt: "Search profile (e.g. strongforce1)")
            .navigationDestination(isPresented: $shouldShowDestination) {
                UserDetailsView(user: selectedUser)
            }
        }
        .task {
            await userViewModel.fetchUsers()
        }
    }
}

struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
