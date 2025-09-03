//
//  SearchViewController.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

//
//  SearchViewController.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import UIKit
import SnapKit

// MARK: - SearchViewController
class SearchViewController: UIViewController {

    private let viewModel = SearchViewModel()
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        viewModel.categories.forEach { category in
            let button = CategoryButton(category: category)
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        return stackView
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "카테고리를 먼저 선택해주세요."
        sb.searchBarStyle = .minimal
        sb.isUserInteractionEnabled = false
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
        tv.keyboardDismissMode = .onDrag
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDelegates()
        setupUI()
        fetchAllData()
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(16)
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
    
    private func fetchAllData() {
        Task {
            do {
                try await viewModel.fetchAllStamps()
                if let firstButton = categoryStackView.arrangedSubviews.first as? CategoryButton {
                    selectCategoryButton(firstButton)
                }
            } catch {
                print("Error fetching stamps: \(error)")
            }
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: CategoryButton) {
        selectCategoryButton(sender)
    }
    
    private func selectCategoryButton(_ button: CategoryButton) {
        categoryStackView.arrangedSubviews.forEach { ($0 as? CategoryButton)?.isSelected = false }
        button.isSelected = true
        
        if let category = button.category {
            viewModel.selectCategory(category)
            searchBar.isUserInteractionEnabled = true
            searchBar.placeholder = "\(category.title)에서 검색"
            searchBar.text = ""
            updateViewForSearchBarState()
        }
    }
    
    private func updateViewForSearchBarState() {
        let isSearchBarEmpty = searchBar.text?.isEmpty ?? true
        recentSearchesTitleLabel.isHidden = !isSearchBarEmpty
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isSearchBarEmpty = searchBar.text?.isEmpty ?? true
        return isSearchBarEmpty ? viewModel.recentSearches.count : viewModel.filteredStamps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isSearchBarEmpty = searchBar.text?.isEmpty ?? true
        
        if isSearchBarEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
            cell.queryLabel.text = viewModel.recentSearches[indexPath.row]
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            let stamp = viewModel.filteredStamps[indexPath.row]
            cell.configure(with: stamp)
            
            cell.onBookmarkTapped = { [weak self] (contentId, isBookmarked) in
                guard let self = self else { return }
                
                Task {
                    do {
                        if isBookmarked {
                            try await StampService.shared.addWishlist(contentId: contentId)
                        } else {
                            try await StampService.shared.deleteWishlist(contentId: contentId)
                        }
                        self.viewModel.updateBookmarkStatus(contentId: contentId, isBookmarked: isBookmarked)
                    } catch {
                        print("북마크 업데이트 실패: \(error)")
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let isSearchBarEmpty = searchBar.text?.isEmpty ?? true
        
        if isSearchBarEmpty {
            let selectedTerm = viewModel.recentSearches[indexPath.row]
            searchBar.text = selectedTerm
            viewModel.performSearch(with: selectedTerm)
            updateViewForSearchBarState()
            viewModel.addRecentSearch(term: selectedTerm)
            searchBar.resignFirstResponder()
        } else {
            let detailVC = StampDetailViewController()
            detailVC.stamp = viewModel.filteredStamps[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.performSearch(with: searchText)
        updateViewForSearchBarState()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        viewModel.addRecentSearch(term: searchTerm)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.performSearch(with: "")
        updateViewForSearchBarState()
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: RecentSearchCellDelegate {
    func didTapDeleteButton(on cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.removeRecentSearch(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

class CategoryButton: UIButton {
    
    var category: SearchCategory?
    
    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }
    
    private let iconImageView = UIImageView()
    private let categoryTitleLabel = UILabel()

    init(category: SearchCategory) {
        self.category = category
        super.init(frame: .zero)
        
        self.categoryTitleLabel.text = category.title
        self.categoryTitleLabel.font = .systemFont(ofSize: 14)
        self.categoryTitleLabel.textColor = .darkGray
        
        setupUI()
        updateSelectionState(animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconImageView)
        addSubview(categoryTitleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(58)
        }
        
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateSelectionState(animated: Bool = true) {
        guard let category = category else { return }
        
        let targetImageName = isSelected ? category.selectedIconName : category.iconName
        let targetImage = UIImage(named: targetImageName)
        
        if animated {
            UIView.transition(with: self.iconImageView,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                  self.iconImageView.image = targetImage
                              },
                              completion: nil)
        } else {
            self.iconImageView.image = targetImage
        }
    }
}
