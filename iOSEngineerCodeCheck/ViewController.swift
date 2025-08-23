//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var repositories: [[String: Any]] = []
    private var searchTask: URLSessionTask?
    private var selectedRepositoryIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    private func searchRepositories(with query: String) {
        guard !query.isEmpty else { return }
        
        searchTask?.cancel()
        
        // URLエンコーディングを安全に行う
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.github.com/search/repositories?q=\(encodedQuery)") else {
            print("無効なURL: \(query)")
            return
        }
        
        searchTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // エラーハンドリングを改善
            if let error = error {
                print("ネットワークエラー: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    // エラー時は空の配列を設定してテーブルをクリア
                    self.repositories = []
                    self.tableView.reloadData()
                }
                return
            }
            
            guard let data = data else {
                print("データが取得できませんでした")
                DispatchQueue.main.async {
                    self.repositories = []
                    self.tableView.reloadData()
                }
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let items = json["items"] as? [[String: Any]] else {
                    print("JSONの形式が期待されるものと異なります")
                    DispatchQueue.main.async {
                        self.repositories = []
                        self.tableView.reloadData()
                    }
                    return
                }
                
                self.repositories = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON解析エラー: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.repositories = []
                    self.tableView.reloadData()
                }
            }
        }
        searchTask?.resume()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Detail",
              let detailViewController = segue.destination as? ViewController2 else { return }
        
        detailViewController.repositories = repositories
        detailViewController.selectedIndex = selectedRepositoryIndex
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repository") ?? UITableViewCell(style: .value1, reuseIdentifier: "Repository")
        
        // 配列の範囲外アクセスを防ぐ安全なチェック
        guard indexPath.row < repositories.count else {
            return cell
        }
        
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String
        cell.detailTextLabel?.text = repository["language"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 配列の範囲外アクセスを防ぐ安全なチェック
        guard indexPath.row < repositories.count else {
            return
        }
        
        selectedRepositoryIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchRepositories(with: searchText)
        searchBar.resignFirstResponder()
    }
}
