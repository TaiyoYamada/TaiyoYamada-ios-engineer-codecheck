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
    private var imageLoadTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRepositoryDetails()
    }
    
    deinit {
        // メモリリーク防止：進行中の画像読み込みタスクをキャンセル
        imageLoadTask?.cancel()
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
        guard let imageURL = URL(string: repository.owner.avatarURL) else {
            // 画像URLが取得できない場合はデフォルト画像を設定
            avatarImageView.image = UIImage(systemName: "person.circle")
            return
        }
        
        // 既存のタスクがあればキャンセル
        imageLoadTask?.cancel()
        
        imageLoadTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // キャンセルされた場合は処理を中断
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                return
            }
            
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
        }
        imageLoadTask?.resume()
    }
}
