//
//  ContentView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/18/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var users: [UserResponse] = []
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            List(users, id: \.id) { user in
                CardView(user: user)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("GitHub Profile")
            .listStyle(.plain)
            .searchable(text: $searchQuery, prompt: "Search profile (e.g. strongforce1)")
        }.task {
            users = await fetchUsers()
        }
    }
    
    func fetchUsers() async -> [UserResponse] {
        let url = URL(string: "https://api.github.com/users")!
        let (data, _) = try! await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return try! decoder.decode([UserResponse].self, from: data)
    }
}

struct CardView: View {
    
    var avatarUrl: String
    var name: String
    var url: String
    
    init(user: UserResponse) {
        self.avatarUrl = user.avatarUrl ?? ""
        self.name = user.login ?? ""
        self.url = "github.com/\(name)"
        print("avatar \(avatarUrl) name: \(name)")
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: avatarUrl)) { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } placeholder: {
                Color.gray
            }
            .cornerRadius(16)
            .frame(width: 72, height: 72)
                
            VStack(
                alignment: .leading
            ) {
                Text(name)
                    .font(.headline)
                Text(url)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }.padding(.leading, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(5)
        .listRowSeparator(.hidden)
        .background(RoundedRectangle(cornerRadius: 16).fill(.card))
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing:16))
        .listRowBackground(Color.clear)
    }
}

//
#Preview {
    ContentView()
}
