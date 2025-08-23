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
    
    var repositories: [[String: Any]] = []
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRepositoryDetails()
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
    
    private func setupLabels(with repository: [String: Any]) {
        titleLabel.text = repository["full_name"] as? String
        
        let language = repository["language"] as? String ?? "Unknown"
        languageLabel.text = "Written in \(language)"
        
        let starCount = repository["stargazers_count"] as? Int ?? 0
        starsLabel.text = "\(starCount) stars"
        
        let watcherCount = repository["watchers_count"] as? Int ?? 0
        watchersLabel.text = "\(watcherCount) watchers"
        
        let forkCount = repository["forks_count"] as? Int ?? 0
        forksLabel.text = "\(forkCount) forks"
        
        let issueCount = repository["open_issues_count"] as? Int ?? 0
        issuesLabel.text = "\(issueCount) open issues"
    }
    
    private func loadOwnerImage(from repository: [String: Any]) {
        guard let owner = repository["owner"] as? [String: Any],
              let imageURLString = owner["avatar_url"] as? String,
              let imageURL = URL(string: imageURLString) else {
            // 画像URLが取得できない場合はデフォルト画像を設定
            avatarImageView.image = UIImage(systemName: "person.circle")
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // エラーハンドリングを改善
            if let error = error {
                print("画像読み込みエラー: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(systemName: "person.circle")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("画像データの変換に失敗しました")
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(systemName: "person.circle")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }.resume()
    }
}
