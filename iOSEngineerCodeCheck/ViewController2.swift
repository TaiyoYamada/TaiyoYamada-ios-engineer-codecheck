//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var repositories: [Repository] = []
    var selectedIndex: Int = 0
    private let imageLoader: ImageLoaderProtocol = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRepositoryDetails()
    }
    
    deinit {
        // メモリリーク防止：進行中の画像読み込みタスクをキャンセル
        imageLoader.cancelCurrentLoad()
    }
    
    private func setupRepositoryDetails() {
        // 配列の範囲外アクセスを防ぐより厳密なチェック
        guard selectedIndex >= 0,
              selectedIndex < repositories.count,
              !repositories.isEmpty else {
            print("無効なリポジトリインデックス: \(selectedIndex), 配列サイズ: \(repositories.count)")
            return
        }
        
        let repository = repositories[selectedIndex]
        
        setupLabels(with: repository)
        loadOwnerImage(from: repository)
    }
    
    private func setupLabels(with repository: Repository) {
        titleLabel.text = repository.fullName
        
        let language = repository.language ?? "Unknown"
        languageLabel.text = "Written in \(language)"
        
        starsLabel.text = "\(repository.stargazersCount) stars"
        watchersLabel.text = "\(repository.watchersCount) watchers"
        forksLabel.text = "\(repository.forksCount) forks"
        issuesLabel.text = "\(repository.openIssuesCount) open issues"
    }
    
    private func loadOwnerImage(from repository: Repository) {
        imageLoader.loadImage(from: repository.owner.avatarURL) { [weak self] image in
            self?.avatarImageView.image = image
        }
    }
}
