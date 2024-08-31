//
//  RepositoryItemView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/28/24.
//

import SwiftUI



struct RepositoryItemView: View {

    var repository: RepositoriesResponse

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            Text(repository.name ?? "").bold()
                .padding(.bottom, 6)
            Text(repository.description ?? "")
                .font(.subheadline)
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .frame(alignment: .center)
                Text("\(repository.stargazersCount ?? 0)")
                    .padding(.trailing, 6)
                if let language = repository.language {
                    Circle()
                        .foregroundColor(.cyan)
                        .frame(width: 12, height: 12)
                    Text(language)
                }
            }.padding(.top, 4)
            Divider().padding(.vertical, 8)
        }
    }
}

#Preview {
    ScrollView {
        RepositoryListView(repositories: [], onLoadMore: { next in })
    }
}
