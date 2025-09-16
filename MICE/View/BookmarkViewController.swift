//
//  BookmarkViewController.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import UIKit
import SnapKit
import Combine

struct BookmarkCategory {
    let title: String
    let type: BookmarkCategoryType
}

class BookmarkViewController: UIViewController {
    
    private let viewModel = BookmarkViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var savedButton = createSegmentButton(title: "저장한 스탬프", tag: 0)
    private lazy var visitedButton = createSegmentButton(title: "다녀온 스탬프", tag: 1)
    
    // 버튼들을 담을 스택뷰
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 선택된 버튼 아래에 표시될 밑줄(indicator) 뷰
    private let selectionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let hashtagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
    private lazy var hashtagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()
    
    private let emptyStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.isHidden = true
        return stackView
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "EmptyImage")
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.width.height.equalTo(100) }
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setupUI()
        setupCategoryButtons()
        setupTableView()
        bindViewModel()
        
        // 초기 선택 상태 설정 ('저장한 스탬프'를 애니메이션 없이 바로 선택)
        segmentButtonTapped(savedButton, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        Task {
            await viewModel.fetchBookmarkedStamps()
        }
    }
    
    private func bindViewModel() {
        viewModel.$filteredStamps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stamps in
                self?.updateViewForStamps(stamps)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        [backButton, buttonStackView, selectionIndicatorView, hashtagScrollView, tableView, emptyStateStackView].forEach { view.addSubview($0) }
        
        buttonStackView.addArrangedSubview(savedButton)
        buttonStackView.addArrangedSubview(visitedButton)
        
        hashtagScrollView.addSubview(hashtagStackView)
        
        emptyStateStackView.addArrangedSubview(emptyImageView)
        emptyStateStackView.addArrangedSubview(emptyLabel)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 밑줄(indicator)의 초기 위치 설정
        selectionIndicatorView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackView.snp.bottom)
            make.height.equalTo(2)
            make.width.equalTo(savedButton)
            make.centerX.equalTo(savedButton)
        }
        
        hashtagScrollView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(36)
        }
        
        // ▼▼▼▼▼ 2. 카테고리 스크롤을 위한 레이아웃 최종 수정 ▼▼▼▼▼
        hashtagStackView.snp.makeConstraints { make in
            // 스택뷰의 4면을 스크롤뷰의 contentLayoutGuide에 맞춥니다.
            make.edges.equalTo(hashtagScrollView.contentLayoutGuide)
            // 스택뷰의 높이를 스크롤뷰의 보이는 영역(frameLayoutGuide)의 높이에 맞춥니다.
            make.height.equalTo(hashtagScrollView.frameLayoutGuide)
        }
        // 스크롤뷰의 시작과 끝에 여백을 줍니다.
        hashtagScrollView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(hashtagScrollView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyStateStackView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupCategoryButtons() {
        let categories = [
            BookmarkCategory(title: "#전체보기", type: .all),
            BookmarkCategory(title: "#박물관", type: .museum),
            BookmarkCategory(title: "#기념관", type: .memorial),
            BookmarkCategory(title: "#전시관", type: .exhibition),
            BookmarkCategory(title: "#미술관", type: .artGallery)
        ]
        
        categories.forEach { category in
            let button = createHashtagButton(category: category)
            hashtagStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo(85)
                make.height.equalTo(36)
            }
            if category.type == .all {
                selectCategoryButton(button)
            }
        }
    }
    
    private func createSegmentButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        // 선택되지 않았을 때(기본)는 회색, 선택되었을 때는 검은색으로 글씨 색 변경
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.tag = tag
        button.addTarget(self, action: #selector(segmentButtonTappedWrapper(_:)), for: .touchUpInside)
        return button
    }
    
    private func createHashtagButton(category: BookmarkCategory) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(category.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 18
        button.tag = category.type.rawValue
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 버튼 탭 시 애니메이션을 주기 위해 래퍼 함수 추가
    @objc private func segmentButtonTappedWrapper(_ sender: UIButton) {
        segmentButtonTapped(sender, animated: true)
    }
    
    private func segmentButtonTapped(_ sender: UIButton, animated: Bool) {
        let isSavedSelected = sender.tag == 0
        savedButton.isSelected = isSavedSelected
        visitedButton.isSelected = !isSavedSelected
        
        viewModel.currentFilterType = isSavedSelected ? .bookmarked : .downloaded
        
        // 밑줄(indicator)을 선택된 버튼으로 이동시키는 애니메이션
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) {
            self.selectionIndicatorView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.buttonStackView.snp.bottom)
                make.height.equalTo(2)
                make.width.equalTo(sender)
                make.centerX.equalTo(sender)
            }
            // 애니메이션 블록 내에서 레이아웃 변경을 즉시 적용
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        selectCategoryButton(sender)
    }
    
    private func selectCategoryButton(_ buttonToSelect: UIButton) {
        hashtagStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                let isSelected = (button == buttonToSelect)
                button.isSelected = isSelected
                button.backgroundColor = isSelected ? .black : .systemGray5
            }
        }
        if let categoryType = BookmarkCategoryType(rawValue: buttonToSelect.tag) {
            viewModel.currentCategoryFilter = categoryType
        }
    }
    
    private func updateViewForStamps(_ stamps: [Stamp]) {
        if stamps.isEmpty {
            tableView.isHidden = true
            emptyStateStackView.isHidden = false
            
            let filterType = viewModel.currentFilterType == .bookmarked ? "저장한" : "다녀온"
            let categoryTitle: String
            switch viewModel.currentCategoryFilter {
            case .all: categoryTitle = "스탬프"
            case .museum: categoryTitle = "박물관"
            case .exhibition: categoryTitle = "전시관"
            case .artGallery: categoryTitle = "미술관"
            case .memorial: categoryTitle = "기념관"
            }
            emptyLabel.text = "\(filterType) \(categoryTitle)이 없네요"
            
        } else {
            tableView.isHidden = false
            emptyStateStackView.isHidden = true
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStamps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = StampDetailViewController()
        detailVC.stamp = viewModel.filteredStamps[indexPath.row]
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
