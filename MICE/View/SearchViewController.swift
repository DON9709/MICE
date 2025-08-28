//
//  SearchViewController.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    private let viewModel = SearchViewModel()
    
    // MARK: - UI Components
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        ["박물관", "기념관", "전시관", "미술관"].forEach { title in
            let button = createCategoryButton(with: title)
            stackView.addArrangedSubview(button)
        }
        return stackView
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    private let recentSearchesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDelegates()
        setupUI()
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
    }

    private func setupUI() {
        view.addSubview(categoryStackView)
        view.addSubview(searchBar)
        view.addSubview(recentSearchesTitleLabel)
        view.addSubview(tableView)
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        recentSearchesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchesTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helper Methods
    private func createCategoryButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        // ... 버튼 UI 설정 (아이콘, 텍스트 등)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.tintColor = .black
        // 아이콘을 추가하려면 button.setImage(...)를 사용하세요.
        return button
    }
    
    // View의 상태 업데이트
    private func updateView(isSearching: Bool) {
        viewModel.isSearching = isSearching
        recentSearchesTitleLabel.isHidden = isSearching
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateView(isSearching: !searchText.isEmpty)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        viewModel.addRecentSearch(term: searchTerm)
        searchBar.resignFirstResponder() // 키보드 내리기
        updateView(isSearching: false)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.searchResults.count : viewModel.recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
            cell.configure(with: viewModel.searchResults[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else { return UITableViewCell() }
            cell.queryLabel.text = viewModel.recentSearches[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - RecentSearchCellDelegate
extension SearchViewController: RecentSearchCellDelegate {
    func didTapDeleteButton(on cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.removeRecentSearch(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
