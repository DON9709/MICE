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
        stackView.spacing = 12
        
        viewModel.categories.forEach { category in
            let button = CategoryButton(category: category)
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        // [수정] 초기화 시점의 충돌을 막기 위해 여기서 버튼 선택 코드를 제거했습니다.
        
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
        return tv
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDelegates()
        setupUI()
        
        // [수정] 첫 번째 버튼 선택 코드를 이곳 viewDidLoad로 이동했습니다.
        // self가 완전히 초기화된 후이므로 안전합니다.
        if let firstButton = categoryStackView.arrangedSubviews.first as? CategoryButton {
            selectCategoryButton(firstButton)
        }
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
    
    // MARK: - Actions
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
        }
        updateView(isSearching: true)
    }
    
    private func updateView(isSearching: Bool) {
        viewModel.isSearching = isSearching
        recentSearchesTitleLabel.isHidden = isSearching
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.performSearch(with: searchText)
        updateView(isSearching: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        viewModel.addRecentSearch(term: searchTerm)
        searchBar.resignFirstResponder()
        updateView(isSearching: false)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filteredResults.count : viewModel.recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
            cell.configure(with: viewModel.filteredResults[indexPath.row])
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
class CategoryButton: UIButton {
    
    var category: SearchCategory?
    
    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }
    
    private let iconImageView = UIImageView()
    
    // [수정 1] 클로저 초기화를 제거하고, 간단한 선언으로 변경
    private let title = UILabel()

    init(category: SearchCategory) {
        self.category = category
        super.init(frame: .zero)
        
        // [수정 2] title의 속성 설정을 init 안으로 이동
        self.title.text = category.title
        self.title.font = .systemFont(ofSize: 14) // << 설정 코드를 여기로 옮깁니다.
        
        setupUI()
        updateSelectionState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
            layer.cornerRadius = 12
            addSubview(iconImageView)
            addSubview(title)
            
            iconImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(30)
            }
            
            title.snp.makeConstraints { make in
                make.top.equalTo(iconImageView.snp.bottom).offset(6)
                make.centerX.equalToSuperview()
            }
        }
        
        private func updateSelectionState() {
            guard window != nil else { return }
            
            guard let category = category else { return }
            
            if isSelected {
                backgroundColor = UIColor(red: 0.4, green: 0.3, blue: 0.9, alpha: 1.0)
                iconImageView.image = UIImage(named: category.selectedIconName)
                title.textColor = .white
                layer.shadowColor = UIColor.purple.cgColor
                layer.shadowOpacity = 0.5
                layer.shadowOffset = CGSize(width: 0, height: 4)
                layer.shadowRadius = 5
            } else {
                backgroundColor = .white
                iconImageView.image = UIImage(named: category.iconName)
                title.textColor = .darkGray
                layer.shadowOpacity = 0
            }
        }
    }
