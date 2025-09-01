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
        
        return stackView
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "카테고리를 먼저 선택해주세요."
        sb.searchBarStyle = .minimal
        sb.isUserInteractionEnabled = false
        // [추가] 검색어 취소(X) 버튼이 항상 보이도록 설정
        sb.showsCancelButton = true
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
        // [추가] 키보드가 나타날 때 스크롤하면 키보드가 내려가도록 설정
        tv.keyboardDismissMode = .onDrag
        return tv
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDelegates()
        setupUI()
        
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
    
    // MARK: - Actions & Logics
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
            // [추가] 카테고리 변경 시 검색바 초기화 및 뷰 업데이트
            searchBar.text = ""
            updateViewForSearchBarState()
        }
    }
    
    // [변경] isSearching 파라미터 대신, 검색바의 현재 상태를 보고 UI를 업데이트하는 함수
    private func updateViewForSearchBarState() {
        let isSearchBarEmpty = searchBar.text?.isEmpty ?? true
        
        // 검색바가 비어있으면 '최근 검색어' 타이틀을 보여주고, 아니면 숨김
        recentSearchesTitleLabel.isHidden = !isSearchBarEmpty
        
        // 테이블뷰를 리로드하여 검색 결과 또는 최근 검색어 목록을 표시
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // [변경] 텍스트가 변경될 때마다 검색을 수행하고, UI를 즉시 업데이트
        viewModel.performSearch(with: searchText)
        updateViewForSearchBarState()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // [변경] 검색 버튼 클릭 시 최근 검색어에 추가하고 키보드만 내림
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        viewModel.addRecentSearch(term: searchTerm)
        searchBar.resignFirstResponder()
        // [제거] updateView 호출을 제거 -> UI 상태는 이미 textDidChange에서 결정됨
    }
    
    // [추가] 검색바의 취소(X) 버튼을 눌렀을 때의 동작
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.performSearch(with: "")
        updateViewForSearchBarState()
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // [변경] viewModel의 isSearching 상태 대신, 검색바의 텍스트 유무로 분기 처리
        let isSearchBarEmpty = searchBar.text?.isEmpty ?? true
        return isSearchBarEmpty ? viewModel.recentSearches.count : viewModel.filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // [변경] viewModel의 isSearching 상태 대신, 검색바의 텍스트 유무로 분기 처리
        let isSearchBarEmpty = searchBar.text?.isEmpty ?? true
        
        if isSearchBarEmpty {
            // 최근 검색어 셀 표시
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else { return UITableViewCell() }
            cell.queryLabel.text = viewModel.recentSearches[indexPath.row]
            cell.delegate = self
            return cell
        } else {
            // 검색 결과 셀 표시
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
            cell.configure(with: viewModel.filteredResults[indexPath.row])
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
    private let categoryTitleLabel = UILabel()

    init(category: SearchCategory) {
        self.category = category
        super.init(frame: .zero)
        
        // [수정] 변경된 이름으로 속성을 설정합니다.
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
        
        // [수정] 변경된 이름의 Label을 view에 추가합니다.
        addSubview(categoryTitleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        // [수정] 변경된 이름으로 제약조건을 설정합니다.
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
