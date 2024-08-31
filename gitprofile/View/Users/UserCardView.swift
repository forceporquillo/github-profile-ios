//
//  UserCardView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import SwiftUI

struct UserCardView: View {
    
    @State private var isTapped = false
    
    var avatarUrl: String
    var name: String
    var url: String

    init (user: UserResponse) {
        self.init(avatarUrl: user.avatarUrl, name: user.login)
    }

    init(avatarUrl: String?, name: String?) {
        self.avatarUrl = avatarUrl ?? ""
        self.name = name ?? ""
        self.url = "github.com/\(name ?? "")"
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
    }
}

#Preview {
    UserCardView(avatarUrl: "https://avatars.githubusercontent.com/u/51302519?v=4", name: "forceporquillo"
    )
}
