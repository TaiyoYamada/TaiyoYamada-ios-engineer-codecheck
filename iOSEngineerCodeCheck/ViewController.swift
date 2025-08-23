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
        
        let urlString = "https://api.github.com/search/repositories?q=\(query)"
        guard let url = URL(string: urlString) else { return }
        
        searchTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    self.repositories = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
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
        
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String
        cell.detailTextLabel?.text = repository["language"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
