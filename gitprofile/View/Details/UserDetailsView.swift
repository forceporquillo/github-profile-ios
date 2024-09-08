//
//  UserDetailsView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/25/24.
//

import SwiftUI

struct UserDetailsView: View {
   
    @State private var detailsStore = UserDetailsStore(
        initialState: .init(viewState: GenericViewState.initial),
        reduce: detailsReducer
    )

    @State private var selectedTabIndex = 0
    @State private var isDisplayNameVisible = true

    let user: String

    private func headerView(parentProxy: GeometryProxy, _ details: UserDetailsUiModel) -> some View {
        VStack {
            VStack(alignment: .leading) {
                veiledCoverPhoto(details)
                HStack {
                    AsyncImage(url: URL(string: details.avatarUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
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
                        Text(details.name)
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
            
            let topPadding: CGFloat = !details.bio.isEmpty ? 86 : 46
            
            Text(details.bio)
                .lineLimit(4)
                .padding(EdgeInsets(top: topPadding, leading: 16, bottom: 16, trailing: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            UserDetailsHandleView(
                workTitle: details.company,
                address: details.location,
                url: details.htmlUrl,
                twitterHandle: details.twitterHandle,
                email: details.email,
                followers: details.followers,
                following: details.following
            )
            
        }
    }

    @ViewBuilder
    private func veiledCoverPhoto(_ details: UserDetailsUiModel) -> some View {
        AsyncImage(url: URL(string: details.avatarUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .blur(radius: 40)
                .frame(maxWidth: .infinity, maxHeight: 180)
                .clipped()
                .edgesIgnoringSafeArea(.all)
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }

    var body: some View {
        NavigationStack {
            self.content
        }
        .scrollIndicators(.hidden)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle(isDisplayNameVisible ? "" : user)
        .toolbar {
            // TODO: Add share functionality
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: {
//                    withAnimation {
//                        
//                    }
//                }) {
//                    Image(systemName: "square.and.arrow.up")
//                }
//            }
        }
        .task {
            detailsStore.send(.fetch(username: user))
        }
    }

    @ViewBuilder private var content: some View {
        switch detailsStore.state.viewState {
        case .initial:
            loadingView
        case .failure(let message):
            VStack {
                Text("Ops! Sorry, we run into an error")
                    .font(.title2)
                Text(message)
                    .multilineTextAlignment(.center)
                    .font(.caption)
            }.padding(.horizontal, 16)
        case .success(let details):
            mainDetailView(details)
        }
    }

    private func mainDetailView(_ details: UserDetailsUiModel) -> some View {
        GeometryReader { geometry in
            ScrollView {
                headerView(parentProxy: geometry, details)
//                SlidingTabView(onSelect: { tab in
//                    self.selectedTabIndex = tab
////                    self.loadTabData(tab: tab)
//                })
                
                UserDetailsTabView(username: user)
                
            }
        }
    }

    private var loadingView: some View {
        return ProgressView()
            .progressViewStyle(.circular)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
    }
    
//    private func loadTabData(tab: Int) {
//        let page: DetailPage
//        if tab == 0 {
//            page = DetailPage.repositories
//        } else if tab == 1 {
//            page = DetailPage.organizations
//        } else {
//            page = DetailPage.starred
//        }
////        viewModel.loadSubDetails(page: page)
//    }
}

public extension View {
    
    func onVisibilityChange(proxy: GeometryProxy, perform action: @escaping (Bool)->Void)-> some View {
        modifier(BecomingVisible(parentProxy: proxy, action: action))
    }
}

private struct BecomingVisible: ViewModifier {
    var parentProxy: GeometryProxy
    var action: ((Bool)->Void)
    
    @State var isVisible: Bool = false
    
    func checkVisible(proxy: GeometryProxy) {
        
        let parentFrame = self.parentProxy.frame(in: .global)
        let childFrame = proxy.frame(in: .global)
        
        let isVisibleNow = parentFrame.intersects(childFrame)
        
        if (self.isVisible != isVisibleNow) {
            self.isVisible = isVisibleNow
            self.action(isVisibleNow)
        }
    }
    
    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                Color.clear
                    .onAppear() {
                        self.checkVisible(proxy: proxy)
                    }
                    .onChange(of: proxy.frame(in: .global)) {
                        self.checkVisible(proxy: proxy)
                    }
            }
        }
    }
}

#Preview {
    UserDetailsView(user: "jakewharton")
}
