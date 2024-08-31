//
//  UserListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import SwiftUI

struct UserListView: View {

    @ObservedObject private var viewModel = UsersViewModel()
    @State private var searchQuery = ""

    var body: some View {
        NavigationStack {
            List(viewModel.users, id: \.id) { user in
                NavigationLink(destination: {
                    UserDetails(user: user.login!)
                }, label: {
                    UserCardView(user: user)
                })
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle("GitHub Users")
            .searchable(text: $searchQuery, prompt: "Search profile (e.g. strongforce1)")
        }.task {
            try? await viewModel.fetchUsers()
        }
    }
}
