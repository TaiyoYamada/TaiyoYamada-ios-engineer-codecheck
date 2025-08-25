//
//  RepositoryListView.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/26.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel = RepositoryListViewModel()
    @State private var isSearchBarFocused = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            SearchBarView(
                text: $viewModel.searchText,
                isFocused: $isSearchBarFocused,
                onSearchButtonClicked: {
                    if !viewModel.searchText.isEmpty {
                        viewModel.searchRepositories(query: viewModel.searchText)
                    }
                }
            )
            
            // Content
            if viewModel.isLoading {
                Spacer()
                ProgressView("検索中...")
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                Text("エラー: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else if viewModel.repositories.isEmpty && !viewModel.searchText.isEmpty {
                Spacer()
                Text("検索結果がありません")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                // Repository List
                List(viewModel.repositories.indices, id: \.self) { index in
                    NavigationLink(
                        destination: RepositoryDetailView(repository: viewModel.repositories[index])
                    ) {
                        RepositoryRowView(repository: viewModel.repositories[index])
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchBarView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    let onSearchButtonClicked: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("GitHubのリポジトリを検索できるよー", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .onSubmit {
                        onSearchButtonClicked()
                        isFocused = false
                    }
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            if isFocused {
                Button("キャンセル") {
                    text = "GitHubのリポジトリを検索できるよー"
                    isFocused = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .onAppear {
            if text.isEmpty {
                text = "GitHubのリポジトリを検索できるよー"
            }
        }
    }
}

struct RepositoryRowView: View {
    let repository: Repository
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(repository.fullName)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text(repository.language ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        RepositoryListView()
    }
}
