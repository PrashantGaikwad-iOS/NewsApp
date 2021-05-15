//
//  ViewController.swift
//  NewsApp
//
//  Created by Prashant Gaikwad on 15/05/21.
//

import UIKit
import SafariServices
//api key - 4434b3d2f3da459e93f62f2762c90cfb

class ViewController: UIViewController, UISearchControllerDelegate {
    
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        return tableview
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    private let searchVC = UISearchController(searchResultsController:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        
        getTopHeadlines()
        createSearchView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
}

extension ViewController: UISearchBarDelegate {
    
    private func createSearchView() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles) :
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title ?? "No title",
                        subTitle: $0.description ?? "No description",
                        imageUrl: $0.urlToImage ?? ""
                    )
                })
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    private func getTopHeadlines() {
        APICaller.shared.getTopstories { [weak self] result in
            switch result {
            case .success(let articles) :
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title ?? "No title",
                        subTitle: $0.description ?? "No description",
                        imageUrl: $0.urlToImage ?? ""
                    )
                })
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard  let url = URL(string:article.url ?? "") else {
            return
        }
        let sv = SFSafariViewController(url: url)
        present(sv, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

