//
//  GithubSearchResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/26.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//


import Foundation

struct GitHubSearchResponse: Codable {
    let items: [Repository]
}
