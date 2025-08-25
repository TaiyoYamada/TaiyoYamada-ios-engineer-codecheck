//
//  RepositoryListViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/26.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

@MainActor
class RepositoryListViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: GitHubRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    init(repository: GitHubRepositoryProtocol = GitHubRepository()) {
        self.repository = repository
        setupSearchBinding()
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if !searchText.isEmpty && searchText != "GitHubのリポジトリを検索できるよー" {
                    self?.searchRepositories(query: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchRepositories(query: String) {
        guard !query.isEmpty else {
            repositories = []
            return
        }
        
        searchCancellable?.cancel()
        isLoading = true
        errorMessage = nil
        
        searchCancellable = repository.searchRepositories(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.repositories = []
                    }
                },
                receiveValue: { [weak self] repositories in
                    self?.repositories = repositories
                }
            )
    }
    
    func clearSearch() {
        searchText = ""
        repositories = []
        errorMessage = nil
    }
}
