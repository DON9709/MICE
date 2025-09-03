//
//  BookmarkViewController.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import UIKit
import SnapKit

class BookmarkViewController: UIViewController {
    
    private let viewModel = BookmarkViewModel()
    
    // MARK: - UI Components
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
        
        // 세그먼트 컨트롤을 눌렀을 때 실행될 함수 연결
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(segmentedControl)
        view.addSubview(hashtagScrollView)
        hashtagScrollView.addSubview(hashtagStackView)
        view.addSubview(tableView)
        
        // --- 제약 조건 ---
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
    
    // MARK: - Actions & Helpers
    @objc private func segmentedControlDidChange(_ sender: UISegmentedControl) {
        // 세그먼트 컨트롤 값이 바뀔 때마다 테이블뷰를 새로고침
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
        // 세그먼트 컨트롤의 선택에 따라 데이터 개수를 결정
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
        
        // ▼▼▼▼▼ 여기가 핵심 수정 부분입니다 ▼▼▼▼▼
        // 데이터 타입을 SearchResult에서 Stamp로 변경하여 에러를 해결합니다.
        let stamp: Stamp
        if segmentedControl.selectedSegmentIndex == 0 {
            stamp = viewModel.savedStamps[indexPath.row]
        } else {
            stamp = viewModel.visitedStamps[indexPath.row]
        }
        
        cell.configure(with: stamp) // 이제 'configure(with: Stamp)' 함수가 정상적으로 호출됩니다.
        return cell
    }
}
