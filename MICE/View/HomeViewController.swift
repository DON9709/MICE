//
//  HomeViewController.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.mainTitle
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // --- 수집한 스탬프 섹션 ---
    private lazy var stampSectionTitleLabel: UILabel = createSectionTitle(title: viewModel.stampSectionTitle)
    
    private let stampSummaryContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var stampExamplesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 130)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    // --- 주변 문화 전시 공간 섹션 ---
    private lazy var nearbySectionTitleLabel: UILabel = createSectionTitle(title: viewModel.nearbySectionTitle)
    private lazy var nearbyCollectionView: UICollectionView = createCollectionView()

    // --- 지금 핫한 전시 공간 섹션 ---
    private lazy var hotSectionTitleLabel: UILabel = createSectionTitle(title: viewModel.hotSectionTitle)
    private lazy var hotCollectionView: UICollectionView = createCollectionView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionView()
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
    
    // MARK: - UI Setup & Layout
    private func setupCollectionView() {
        stampExamplesCollectionView.dataSource = self
        stampExamplesCollectionView.register(StampExampleCell.self, forCellWithReuseIdentifier: StampExampleCell.identifier)
        
        nearbyCollectionView.dataSource = self
        nearbyCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
        
        hotCollectionView.dataSource = self
        hotCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, notificationButton, stampSectionTitleLabel, stampSummaryContainerView, stampExamplesCollectionView, nearbySectionTitleLabel, nearbyCollectionView, hotSectionTitleLabel, hotCollectionView].forEach { contentView.addSubview($0) }
        
        setupStampSummaryView()

        // --- SnapKit 제약조건 설정 ---
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        notificationButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }
        
        stampSectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(titleLabel)
        }
        
        stampSummaryContainerView.snp.makeConstraints { make in
            make.top.equalTo(stampSectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        stampExamplesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stampSummaryContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(130)
        }
        
        nearbySectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(stampExamplesCollectionView.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }

        nearbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nearbySectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        hotSectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nearbyCollectionView.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }

        hotCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hotSectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupStampSummaryView() {
        let achievedCountLabel = createCountLabel(text: "\(viewModel.achievedStampCount)")
        let achievedTitleLabel = createTitleLabel(text: "달성한 스탬프")
        
        let unachievedCountLabel = createCountLabel(text: "\(viewModel.unachievedStampCount)")
        let unachievedTitleLabel = createTitleLabel(text: "미달성 스탬프")
        
        let leftStack = UIStackView(arrangedSubviews: [achievedCountLabel, achievedTitleLabel])
        leftStack.axis = .vertical
        leftStack.alignment = .center
        leftStack.spacing = 4
        
        let rightStack = UIStackView(arrangedSubviews: [unachievedCountLabel, unachievedTitleLabel])
        rightStack.axis = .vertical
        rightStack.alignment = .center
        rightStack.spacing = 4
        
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        
        // [수정] mainStack의 distribution 규칙을 .fill로 변경
        let mainStack = UIStackView(arrangedSubviews: [leftStack, separator, rightStack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fill // .fillEqually에서 .fill로 변경
        mainStack.alignment = .center
        
        stampSummaryContainerView.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.width.equalTo(1) // 구분선 너비는 1로 고정
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        // [추가] leftStack과 rightStack의 너비가 같도록 직접 설정
        leftStack.snp.makeConstraints { make in
            make.width.equalTo(rightStack)
        }
    }
    
    // --- Helper Methods ---
    private func createCountLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }

    private func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }
    
    private func createSectionTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == stampExamplesCollectionView {
            return viewModel.stampExamples.count
        } else if collectionView == nearbyCollectionView {
            return viewModel.nearbyExhibitions.count
        } else { // hotCollectionView
            return viewModel.hotExhibitions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == stampExamplesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampExampleCell.identifier, for: indexPath) as? StampExampleCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel.stampExamples[indexPath.item])
            return cell
        } else {
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionCell.identifier, for: indexPath) as? ExhibitionCell else {
                return UICollectionViewCell()
            }
            if collectionView == nearbyCollectionView {
                 let exhibition = viewModel.nearbyExhibitions[indexPath.item]
                 cell.configure(with: exhibition)
            } else { // hotCollectionView
                 let exhibition = viewModel.hotExhibitions[indexPath.item]
                 cell.configure(with: exhibition)
            }
            return cell
        }
    }
}
