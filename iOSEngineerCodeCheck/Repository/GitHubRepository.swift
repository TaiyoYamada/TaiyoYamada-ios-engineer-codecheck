//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/26.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

protocol GitHubRepositoryProtocol {
    func searchRepositories(query: String) -> AnyPublisher<[Repository], Error>
}

class GitHubRepository: GitHubRepositoryProtocol {
    private let apiService: GitHubAPIServiceProtocol
    
    init(apiService: GitHubAPIServiceProtocol = GitHubAPIService()) {
        self.apiService = apiService
    }
    
    func searchRepositories(query: String) -> AnyPublisher<[Repository], Error> {
        return Future<[Repository], Error> { [weak self] promise in
            self?.apiService.searchRepositories(query: query) { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
}
