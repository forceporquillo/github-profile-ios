//
//  StarredRepositoriesListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import SwiftUI

struct StarredRepositoriesListView: View {
    var body: some View {
        LazyVStack {
//            ForEach(1...2, id: \.self) {
//                RepositoryItemView(data: "\($0)")
//            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(/*@START_MENU_TOKEN@*/.visible/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StarredRepositoriesListView()
}
