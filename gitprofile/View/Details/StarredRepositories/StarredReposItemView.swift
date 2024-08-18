//
//  SwiftUIView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/9/24.
//

import SwiftUI

struct StarredReposItemView : View {
    
    let starredRepoUiModel: UserStarredReposUiModel
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            HStack {
                AsyncImage(url: URL(string: starredRepoUiModel.avatar ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                } placeholder: {
                    ZStack {
                        Circle()
                            .foregroundColor(.card)
                        ProgressView()
                    }
                }
                .frame(width: 24, height: 24, alignment: .center)
                
                Text(starredRepoUiModel.ownerName)
                    .padding(.leading, 2)
                    .bold()
            }
            .padding(.bottom, 6)
            
            Text(starredRepoUiModel.name)
                .bold()
                .padding(.bottom, 4)
            
            Text(starredRepoUiModel.description)
                .font(.subheadline)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .frame(alignment: .center)
                Text("\(starredRepoUiModel.starredCount)")
                    .padding(.trailing, 6)
                if let language = starredRepoUiModel.language {
                    Circle()
                        .foregroundColor(language.colorForLanguage())
                        .frame(width: 12, height: 12)
                    Text(language)
                }
            }.padding(.top, 4)
            Divider().padding(.vertical, 8)
        }
    }
}
