//
//  NewsVC.swift
//  NewsApp
//
//  Created by Emirhan İpek on 10.04.2025.
//

import UIKit

protocol NewsViewVCProtocol: AnyObject {
    func reloadData()
}

final class NewsVC: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: NewsViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        tableView.rowHeight = 200
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: NewsViewModel = NewsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureView()
        viewModel.fetchTopNews()
    }
}

private extension NewsVC {
    func configureView() {
        view.backgroundColor = .systemBackground
        addViews()
        configureLayout()
    }
    
    func addViews() {
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.setupAnchors(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
    }
}

extension NewsVC: NewsViewVCProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        cell.configure(with: viewModel.articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = viewModel.articles[indexPath.row]
        let detailVM = DetailViewModel(article: selectedArticle)
        let detailVC = DetailVC(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

