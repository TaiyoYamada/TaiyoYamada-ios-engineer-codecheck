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
    
    private var repositories: [Repository] = []
    private var selectedRepositoryIndex: Int = 0
    private let apiService: GitHubAPIServiceProtocol = GitHubAPIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    deinit {
        // メモリリーク防止：進行中のタスクをキャンセル
        apiService.cancelCurrentSearch()
    }
    
    private func setupSearchBar() {
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    private func searchRepositories(with query: String) {
        apiService.searchRepositories(query: query) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let repositories):
                    self.updateRepositories(repositories)
                case .failure(let error):
                    self.handleSearchError(error)
                }
            }
        }
    }
    
    private func updateRepositories(_ repositories: [Repository]) {
        self.repositories = repositories
        tableView.reloadData()
    }
    
    private func handleSearchError(_ error: Error) {
        print("検索エラー: \(error.localizedDescription)")
        repositories = []
        tableView.reloadData()
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
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language ?? "Unknown"
        
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
        apiService.cancelCurrentSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchRepositories(with: searchText)
        searchBar.resignFirstResponder()
    }
}
