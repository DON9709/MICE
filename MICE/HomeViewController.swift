//
//  HomeViewController.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    // ViewModel 인스턴스 생성
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
        private let stampBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray6
            view.layer.cornerRadius = 10
            return view
        }()
        private let stampScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsHorizontalScrollIndicator = false
            return scrollView
        }()
        private lazy var stampStackView: UIStackView = createHorizontalStackView()

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
        populateStampData()
    }
    
    // MARK: - UI Setup & Layout
    
    private func setupCollectionView() {
        nearbyCollectionView.dataSource = self
        hotCollectionView.dataSource = self
        
        nearbyCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
        hotCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(notificationButton)

    
        stampBackgroundView.addSubview(stampScrollView)
        stampScrollView.addSubview(stampStackView)

        // stampScrollView, nearbySectionTitleLabel, nearbyCollectionView,
        // hotSectionTitleLabel, hotCollectionView].forEach { contentView.addSubview($0) }
        contentView.addSubview(stampSectionTitleLabel)
        contentView.addSubview(stampBackgroundView)
        contentView.addSubview(nearbySectionTitleLabel)
        contentView.addSubview(nearbyCollectionView)
        contentView.addSubview(hotSectionTitleLabel)
        contentView.addSubview(hotCollectionView)

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

        // --- 스탬프 섹션 레이아웃  ---
        stampSectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(titleLabel)
        }

        stampBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(stampSectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100) // 배경 높이 고정
        }

        stampScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)) // 내부 여백 조정
            make.height.equalTo(80) // 스크롤뷰 높이 유지
        }

        stampStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        // --- 주변 문화 전시 공간 레이아웃  ---
        nearbySectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(stampBackgroundView.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }

        nearbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nearbySectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        // --- 지금 핫한 전시 공간 레이아웃 ---
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
    
    // MARK: - Helper Methods
    
    private func populateStampData() {
        viewModel.stamps.forEach { stamp in
            let imageView = UIImageView()
            imageView.backgroundColor = .darkGray
            imageView.isOpaque = false
            imageView.clipsToBounds = true
            
            let stampSize: CGFloat = 80
            imageView.layer.cornerRadius = stampSize / 2
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(stampSize)
            }
            stampStackView.addArrangedSubview(imageView)
        }
    }
    
    private func createSectionTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }
    
    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        return stackView
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
        if collectionView == nearbyCollectionView {
            return viewModel.nearbyExhibitions.count
        } else {
            return viewModel.hotExhibitions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionCell.identifier, for: indexPath) as? ExhibitionCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == nearbyCollectionView {
            let exhibition = viewModel.nearbyExhibitions[indexPath.item]
            cell.configure(with: exhibition)
        } else {
            let exhibition = viewModel.hotExhibitions[indexPath.item]
            cell.configure(with: exhibition)
        }
        
        return cell
    }
}
