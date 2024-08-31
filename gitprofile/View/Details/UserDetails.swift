//
//  UserDetails.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/25/24.
//

import SwiftUI

struct UserDetails: View {

    @ObservedObject private var viewModel = UserDetailsViewModel()

    @State private var selectedTabIndex = 0
    @State private var isDisplayNameVisible = true
    
    let user: String

    private func headerView(parentProxy: GeometryProxy) -> some View {
        VStack {
            VStack(alignment: .leading) {
                veiledCoverPhoto()
                HStack {
                    AsyncImage(url: URL(string: viewModel.details.avatarURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    VStack(
                        alignment: .leading
                    ) {
                        Text(user)
                            .font(.title)
                            .lineLimit(1)
                            .fontWeight(.bold)
                        Text(viewModel.details.name ?? "")
                            .font(.subheadline)
                            .padding(.bottom, 20)
                            .onVisibilityChange(proxy: parentProxy) { isVisible in
                                isDisplayNameVisible = isVisible
                            }
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                }
                .offset(y: -20)
                .padding(.bottom, -100)
                .padding(.horizontal, 16)
            }

            let topPadding: CGFloat = viewModel.details.bio != nil ? 86 : 46

            Text(viewModel.details.bio ?? "")
                .lineLimit(4)
                .padding(EdgeInsets(top: topPadding, leading: 16, bottom: 16, trailing: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            InfoContainerView(
                workTitle: viewModel.details.company,
                address: viewModel.details.location,
                url: (viewModel.details.htmlURL ?? "").replacingOccurrences(of: "https://", with: ""),
                email: viewModel.details.email,
                followers: "\(viewModel.details.followers ?? 0)",
                following: "\(viewModel.details.following ?? 0)"
            )

        }
    }
    
    private func veiledCoverPhoto() -> some View {
        AsyncImage(url: URL(string: viewModel.details.avatarURL ?? "")) { image in
            image
                .resizable()
                .scaledToFit()
                .blur(radius: 60)
                .frame(maxWidth: .infinity, maxHeight: 180)
                .clipped()
                .edgesIgnoringSafeArea(.horizontal)
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
 
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    ScrollView {
                        Section {
                            SlidingTabView(selection: $selectedTabIndex)
                            if selectedTabIndex == 0 {
                                RepositoryListView(repositories: viewModel.repositories) { next in
                                    viewModel.onLoadMore(page: next)
                                }
                            } else if selectedTabIndex == 1 {
                                StarredRepositoriesListView()
                            } else {
                                StarredRepositoriesListView()
                            }
                        } header: {
                            headerView(parentProxy: geometry)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .toolbarTitleDisplayMode(.inline)
                    .navigationTitle(isDisplayNameVisible ? "" : user)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                withAnimation {
                                    
                                }
                            }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                }
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .isHidden(!viewModel.isLoading)
            }
        }.task {
            try? await viewModel.fetchDetails(username: user)
        }
    }
}

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}

#Preview {
    UserDetails(user: "forceporquillo")
}
