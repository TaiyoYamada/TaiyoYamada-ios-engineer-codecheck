//
//  GitHubSearchResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/24.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//


import Foundation

// MARK: - Data Models

struct GitHubSearchResponse: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner
    }
}

struct Owner: Codable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}