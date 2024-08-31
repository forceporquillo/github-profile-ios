//
//  InfoContentView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import SwiftUI

struct InfoContainerView : View {
    
    var workTitle: String? = nil
    var address: String? = nil
    var url: String? = nil
    var email: String? = nil
    var followers: String? = ""
    var following: String? = ""

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            if let title = workTitle, ((workTitle?.isEmpty) == false) {
                HStack(
                    alignment: .top
                ) {
                    Image(systemName: "building")
                        .padding(.trailing, 4)
                    Text(title)
                        .lineLimit(2)
                        .bold()
                }
            }
            if let location = address, ((address?.isEmpty) == false) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .padding(.trailing, 4)
                    Text(location).bold()
                }
            }
            if let email = self.email, ((self.email?.isEmpty) == false) {
                HStack {
                    Image(systemName: "envelope")
                        .padding(.trailing, 4)
                    Text(email).bold()
                }
            }
            if let link = url, ((url?.isEmpty) == false) {
                HStack {
                    Image(systemName: "link")
                        .padding(.trailing, 2)
                    Text(link).bold()
                }
            }
            HStack {
                HStack {
                    Image(systemName: "person").padding(.trailing, 4)
                    Text(formatValue(number: followers)).bold()
                    Text("Followers")
                    Circle().frame(width: 6, height: 6)
                    Text(formatValue(number: following)).bold()
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
    InfoContainerView(
        workTitle: "@amdocs, @finastra, @google @accenture @mcquarie",
        address: "Manila, Philippines",
        url: "github.com/forceporquillo",
        email: "fporquillo18@gmail.com",
        followers: "49",
        following: "152"
    )
}
