//
//  UserOrganizationsView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/6/24.
//

import Foundation
import SwiftUI

struct UserOrganizationsView: View {
    
    let org: UserOrgsUiModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: org.avatar)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                        .clipShape(Rectangle())
                } placeholder: {
                    ProgressView()
                        
                }
                .frame(width: 56, height: 56, alignment: .center)
                VStack(alignment: .leading) {
                    Text(org.name)
                        .bold()
                    Text(.init("[github/\(org.name)](https://github.com/\(org.name))"))
                    Text(org.description)
                        .font(.subheadline)
                        .padding(.top, 5)
                }
                .padding(4)
            }
            Divider().padding(.vertical, 8)
        }
    }
}

#Preview {
    VStack {
        UserOrganizationsView(
        org: UserOrgsUiModel(
            id: 69243933,
            name: "turbogiants",
            avatar: "https://avatars.githubusercontent.com/u/69243933?v=4",
            description: "")
        )
    }.padding()
}
