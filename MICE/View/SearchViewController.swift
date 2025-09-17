//
//  SearchViewController.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import UIKit
import SnapKit
import Combine 

class SearchViewController: UIViewController {

    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>() // Combine 구독 관리를 위한 변수
    
    
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
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    
    private let emptyStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.isHidden = true // 처음에는 숨겨둠
        return stackView
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "EmptyImage") // 에셋에 추가한 이미지 이름
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.width.height.equalTo(50) }
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
   
    private lazy var recentSearchesHeaderView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDelegates()
        setupUI()
        fetchAllData()
        bindViewModel() // ViewModel 바인딩 함수 호출
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    private func bindViewModel() {
        viewModel.$filteredStamps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stamps in
                self?.updateViewForSearchResults(stamps)
            }
            .store(in: &cancellables)
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
        view.addSubview(tableView)
        
        // '결과 없음' 뷰 추가
        emptyStateStackView.addArrangedSubview(emptyImageView)
        emptyStateStackView.addArrangedSubview(emptyLabel)
        view.addSubview(emptyStateStackView)
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8) // 검색창 바로 아래에 붙도록 수정
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyStateStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(140)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
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
            viewModel.searchQuery = "" // 카테고리 변경 시 검색어도 초기화
        }
    }
    

    private func updateViewForSearchResults(_ stamps: [Stamp]) {
        let isSearching = !(searchBar.text?.isEmpty ?? true)
        
        if isSearching {
            tableView.tableHeaderView = nil // 검색 중에는 '최근 검색어' 헤더 숨김
            if stamps.isEmpty {
                // 검색 결과가 없을 때
                tableView.isHidden = true
                emptyStateStackView.isHidden = false
                let categoryTitle = viewModel.selectedCategory?.title ?? "항목"
                emptyLabel.text = "일치하는 \(categoryTitle)이 없네요"
            } else {
                // 검색 결과가 있을 때
                tableView.isHidden = false
                emptyStateStackView.isHidden = true
                tableView.reloadData()
            }
        } else {
            // 검색어가 없을 때 (최근 검색어 표시)
            tableView.isHidden = false
            emptyStateStackView.isHidden = true
            tableView.tableHeaderView = recentSearchesHeaderView
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        viewModel.addRecentSearch(term: searchTerm)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isSearching = !(searchBar.text?.isEmpty ?? true)
        return isSearching ? viewModel.filteredStamps.count : viewModel.recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isSearching = !(searchBar.text?.isEmpty ?? true)
        
        if isSearching {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
            cell.queryLabel.text = viewModel.recentSearches[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isSearching = !(searchBar.text?.isEmpty ?? true)
        
        if isSearching {
            let detailVC = StampDetailViewController()
            detailVC.stamp = viewModel.filteredStamps[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let selectedTerm = viewModel.recentSearches[indexPath.row]
            searchBar.text = selectedTerm
            viewModel.addRecentSearch(term: selectedTerm)
            viewModel.searchQuery = selectedTerm // searchQuery를 업데이트하여 검색 실행
            searchBar.resignFirstResponder()
        }
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
