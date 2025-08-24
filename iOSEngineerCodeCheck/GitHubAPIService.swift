//
//  GitHubAPIServiceProtocol.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/24.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//


import Foundation

// MARK: - Network Service

protocol GitHubAPIServiceProtocol {
    func searchRepositories(query: String, completion: @escaping (Result<[Repository], Error>) -> Void)
    func cancelCurrentSearch()
}

class GitHubAPIService: GitHubAPIServiceProtocol {
    private var searchTask: URLSessionDataTask?
    
    func searchRepositories(query: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        guard !query.isEmpty else {
            completion(.success([]))
            return
        }
        
        cancelCurrentSearch()
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.github.com/search/repositories?q=\(encodedQuery)") else {
            completion(.failure(GitHubAPIError.invalidURL))
            return
        }
        
        searchTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(GitHubAPIError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(GitHubSearchResponse.self, from: data)
                completion(.success(searchResponse.items))
            } catch {
                completion(.failure(error))
            }
        }
        searchTask?.resume()
    }
    
    func cancelCurrentSearch() {
        searchTask?.cancel()
    }
}

// MARK: - Custom Errors

enum GitHubAPIError: LocalizedError {
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .noData:
            return "データが取得できませんでした"
        }
    }
}