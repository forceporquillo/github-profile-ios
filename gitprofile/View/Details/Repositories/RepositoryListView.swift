//
//  RepositoryListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/31/24.
//

import SwiftUI

struct RepositoryListView : View {
    
    var repositories: [RepositoriesResponse] = []
    var onLoadMore: (Int) -> Void

    var body: some View {
        LazyVStack {
            ForEach(repositories, id: \.id) { repository in
                RepositoryItemView(repository: repository)
                    .onAppear {
                        if repository.id == repositories.last?.id {
                            print("This is last \(repository.name ?? "")")
                            onLoadMore(repositories.count + 1)
                        }
                    }
            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.visible)
    }
}

//#Preview {
//    //RepositoryListView()
//}
