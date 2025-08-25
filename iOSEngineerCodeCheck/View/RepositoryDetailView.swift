//
//  RepositoryDetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/26.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository
    @StateObject private var viewModel: RepositoryDetailViewModel
    
    init(repository: Repository) {
        self.repository = repository
        self._viewModel = StateObject(wrappedValue: RepositoryDetailViewModel(repository: repository))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Avatar Image - 上部中央、元のサイズに近づける
            VStack {
                if viewModel.isLoadingImage {
                    ProgressView()
                        .frame(width: 100, height: 100)
                } else {
                    if let avatar = viewModel.avatarImage {
                        Image(uiImage: avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
            .padding(.bottom, 30)
            
            // Repository Details - 元のUIKitの単純なレイアウトを再現
            VStack(alignment: .leading, spacing: 20) {
                // Title Label
                Text(viewModel.titleText)
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(alignment: .leading)
                
                // Language Label
                Text(viewModel.languageText)
                    .font(.body)
                    .frame(alignment: .leading)
                
                // Stars Label
                Text(viewModel.starsText)
                    .font(.body)
                    .frame(alignment: .leading)
                
                // Watchers Label
                Text(viewModel.watchersText)
                    .font(.body)
                    .frame(alignment: .leading)
                
                // Forks Label
                Text(viewModel.forksText)
                    .font(.body)
                    .frame(alignment: .leading)
                
                // Issues Label
                Text(viewModel.issuesText)
                    .font(.body)
                    .frame(alignment: .leading)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
//
//#Preview {
//    NavigationView {
//        RepositoryDetailView(
//            repository: Repository(
//                fullName: "apple/swift",
//                language: "Swift",
//                stargazersCount: 65000,
//                watchersCount: 2500,
//                forksCount: 10500,
//                openIssuesCount: 150,
//                owner: Owner(avatarURL: "https://avatars.githubusercontent.com/u/10639145?v=4")
//            )
//        )
//    }
//}
