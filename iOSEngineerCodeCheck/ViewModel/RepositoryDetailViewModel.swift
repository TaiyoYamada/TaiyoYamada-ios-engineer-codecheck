//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/26.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//


import Foundation
import UIKit
import Combine

@MainActor
class RepositoryDetailViewModel: ObservableObject {
    @Published var avatarImage: UIImage?
    @Published var isLoadingImage: Bool = false
    
    let repository: Repository
    private let imageLoader: ImageLoaderProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: Repository, imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.repository = repository
        self.imageLoader = imageLoader
        loadAvatarImage()
    }
    
    var titleText: String {
        repository.fullName
    }
    
    var languageText: String {
        let language = repository.language ?? "Unknown"
        return "Written in \(language)"
    }
    
    var starsText: String {
        "\(repository.stargazersCount) stars"
    }
    
    var watchersText: String {
        "\(repository.watchersCount) watchers"
    }
    
    var forksText: String {
        "\(repository.forksCount) forks"
    }
    
    var issuesText: String {
        "\(repository.openIssuesCount) open issues"
    }
    
    private func loadAvatarImage() {
        isLoadingImage = true
        
        imageLoader.loadImage(from: repository.owner.avatarURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.avatarImage = image
                self?.isLoadingImage = false
            }
        }
    }
}
