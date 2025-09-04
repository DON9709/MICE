//
//  BookmarkViewController.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import UIKit
import SnapKit
import Combine

class BookmarkViewController: UIViewController {
    
    private let viewModel = BookmarkViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // ... (UI Components는 기존과 동일) ...
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["저장한 스탬프", "다녀온 스탬프"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let hashtagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var hashtagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        let hashtags = ["#전체보기", "#박물관", "#전시관", "#미술관", "#기념관"]
        hashtags.forEach { title in
            stackView.addArrangedSubview(createHashtagButton(title: title))
        }
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        setupUI()
        bindViewModel()
    }
    
    // ▼▼▼▼▼ 뷰가 나타날 때마다 데이터를 새로고침 ▼▼▼▼▼
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.fetchSavedStamps()
        }
    }
    
    // ▼▼▼▼▼ ViewModel의 데이터 변경을 감지하는 함수 추가 ▼▼▼▼▼
    private func bindViewModel() {
        viewModel.$savedStamps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.segmentedControl.selectedSegmentIndex == 0 {
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    // ... (setupUI, createHashtagButton 등 나머지 코드는 기존과 동일) ...
     private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(segmentedControl)
        view.addSubview(hashtagScrollView)
        hashtagScrollView.addSubview(hashtagStackView)
        view.addSubview(tableView)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        hashtagScrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
        
        hashtagStackView.snp.makeConstraints { make in
            make.height.equalTo(hashtagScrollView)
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(hashtagScrollView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func segmentedControlDidChange(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    private func createHashtagButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        return button
    }
}

// MARK: - UITableView DataSource & Delegate
extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return viewModel.savedStamps.count
        } else {
            return viewModel.visitedStamps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        
        let stamp: Stamp
        if segmentedControl.selectedSegmentIndex == 0 {
            stamp = viewModel.savedStamps[indexPath.row]
        } else {
            stamp = viewModel.visitedStamps[indexPath.row]
        }
        
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
                    // DB 업데이트 후, 목록을 다시 불러와 화면을 갱신합니다.
                    await self.viewModel.fetchSavedStamps()
                } catch {
                    print("북마크 업데이트 실패: \(error)")
                }
            }
        }
        
        return cell
    }
}
