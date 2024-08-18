//
//  UserCardView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/19/24.
//

import SwiftUI

struct UserCardView: View {
    
    @State private var isTapped = false
    
    let user: UserUiModel
    let onTap: () -> Void

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
                }
            }
            .cornerRadius(16)
            .frame(width: 72, height: 72)
            VStack(
                alignment: .leading
            ) {
                Text(user.login)
                    .font(.headline)
                Text("github.com/\(user.login)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }.padding(.leading, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    UserCardView(
        user: UserUiModel(
            id: 1,
            login: "forceporquillo",
            avatarUrl: "https://avatars.githubusercontent.com/u/51302519?v=4"
        ), 
        onTap: {
            
        }
    )
    .padding()
}
