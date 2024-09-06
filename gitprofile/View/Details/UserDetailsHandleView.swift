//
//  UserDetailsHandleView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import SwiftUI

struct UserDetailsHandleView : View {
    
    var workTitle: String? = nil
    var address: String? = nil
    var url: String? = nil
    var twitterHandle: String? = nil
    var email: String? = nil
    var followers: Int = 0
    var following: Int = 0

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            if let title = workTitle, ((workTitle?.isEmpty) == false) {
                HStack(
                    alignment: .top
                ) {
                    Image(systemName: "building")
                        .padding(.trailing, 6)
                    Text(title)
                        .lineLimit(2)
                        .bold()
                }
            }
            if let location = address, ((address?.isEmpty) == false) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .padding(.trailing, 6)
                    Text(location)
                }
            }
            if let twitterUsername = twitterHandle, ((twitterHandle?.isEmpty) == false) {
                HStack {
                    Image(.xTwitter)
                        .padding(.trailing, 6)
                    Text("@\(twitterUsername)").bold()
                }
            }
            if let link = url, ((url?.isEmpty) == false) {
                HStack {
                    Image(.githubFill)
                        .padding(.trailing, 3)
                    Text(link).bold()
                }
            }
            if let email = self.email, ((self.email?.isEmpty) == false) {
                HStack {
                    Image(systemName: "envelope")
                        .padding(.trailing, 0)
                    Text(email).bold()
                }
            }
            HStack {
                HStack {
                    Image(systemName: "person").padding(.trailing, 6)
                    Text("\(followers)").bold()
                    Text("Followers")
                    Circle().frame(width: 6, height: 6)
                    Text("\(following )").bold()
                    Text("Following")
                       
                }
            }
        }.frame(
            maxWidth: .infinity,
            alignment: .leading
        ).padding(.horizontal, 16)
    }
    
    func formatValue(number: String?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let numberString = number, let numberValue = Int(numberString) {
            if let formatted = formatter.string(from: NSNumber(value: numberValue)) {
                return formatted
            }
        }
        return ""
    }

}

#Preview {
    UserDetailsHandleView(
        workTitle: "FEU Institute of Technology",
        address: "Manila, Philippines",
        url: "github.com/forceporquillo",
        twitterHandle: "/@twitter_handle",
        email: "henlofren@gmail.com",
        followers: 149,
        following: 12
    )
}
