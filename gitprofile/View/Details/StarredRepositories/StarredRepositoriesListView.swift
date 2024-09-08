//
//  StarredRepositoriesListView.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 8/30/24.
//

import SwiftUI

struct StarredRepositoriesListView: View {
    
    let starredRepos: LoadableViewState<[UserStarredReposUiModel]>
    let requestMore: () -> Void
    
    var body: some View {
        LazyVStack {
            if case let LoadableViewState.loaded(oldRepos) = starredRepos {
                displayStarredRepositories(oldRepos, true)
            } else if case let LoadableViewState.success(repos) = starredRepos {
                displayStarredRepositories(repos, false)
            } else if case let LoadableViewState.endOfPaginatedReached(lastData) = starredRepos {
                displayStarredRepositories(lastData, false, true)
            }
        }
        .padding(.horizontal)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listRowSeparator(/*@START_MENU_TOKEN@*/.visible/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    private func displayStarredRepositories(_ repos: [UserStarredReposUiModel], _ showLoading: Bool, _ endOfPaginationReached: Bool = false) -> some View {
        if showLoading {
            ProgressView().progressViewStyle(.circular)
        }
        ForEach(repos, id: \.id) { repository in
            StarredReposItemView(starredRepoUiModel: repository)
                .onAppear {
                    if repository.id == repos.last?.id {
//                       requestMore()
                    }
                }
        }
        if !endOfPaginationReached {
            ProgressView().progressViewStyle(.circular).onAppear {
                print("StarredRepositoriesListView \(repos.count)")
                print("OnAppear...")
                requestMore()
            }
        }
    }
}

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
                        .frame(width: 24, height: 24, alignment: .center)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                } placeholder: {
                    ProgressView()
                }
                Text(starredRepoUiModel.ownerName)
                    .padding(.leading, 2)
                    .bold()
            }.padding(.bottom, 6)
            
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

//#Preview {
////    LazyVStack {
////        StarredReposItemView()
////        StarredReposItemView()
////        StarredReposItemView()
////    }.padding()
//    //StarredRepositoriesListView()
//}
