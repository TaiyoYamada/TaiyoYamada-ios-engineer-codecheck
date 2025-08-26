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
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(viewModel.titleText)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(20)
            }
            .frame(width: 300)
            
            VStack {
                if viewModel.isLoadingImage {
                    ProgressView()
                        .frame(width: 200, height: 200)
                } else {
                    if let avatar = viewModel.avatarImage {
                        Image(uiImage: avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 12)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 12)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
            .padding(.bottom, 30)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Label("言語", systemImage: "chevron.left.slash.chevron.right")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(viewModel.languageText)
                }
                HStack {
                    Label("Stars", systemImage: "star.fill")
                        .foregroundColor(.yellow)
                    Spacer()
                    Text(viewModel.starsText)
                }
                HStack {
                    Label("Watchers", systemImage: "eye.fill")
                        .foregroundColor(.blue)
                    Spacer()
                    Text(viewModel.watchersText)
                }
                HStack {
                    Label("Forks", systemImage: "tuningfork")
                        .foregroundColor(.green)
                    Spacer()
                    Text(viewModel.forksText)
                }
                HStack {
                    Label("Issues", systemImage: "exclamationmark.circle")
                        .foregroundColor(.red)
                    Spacer()
                    Text(viewModel.issuesText)
                }
            }
            .frame(width: 300)
            
            Spacer()
            
        }
        .navigationTitle("リポジトリ詳細")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let url = URL(string: "https://github.com/\(repository.fullName)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "safari")
                }
            }
        }
    }
}
