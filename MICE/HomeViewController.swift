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

    // 전체를 감싸는 스크롤뷰
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
    private let stampStackView: UIStackView = createHorizontalStackView()

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
        // DataSource 설정
        nearbyCollectionView.dataSource = self
        hotCollectionView.dataSource = self
        
        // 사용할 Cell 등록
        nearbyCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
        hotCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // 최상단 타이틀/버튼
        contentView.addSubview(titleLabel)
        contentView.addSubview(notificationButton)

        // 각 섹션 뷰들 추가
        [stampSectionTitleLabel, stampBackgroundView, stampStackView,
         nearbySectionTitleLabel, nearbyCollectionView,
         hotSectionTitleLabel, hotCollectionView].forEach { contentView.addSubview($0) }
        
        stampBackgroundView.addSubview(stampStackView)

        // --- SnapKit 제약조건 설정 ---
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 스크롤뷰의 너비와 동일하게 설정 (중요)
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
        
        // --- 스탬프 섹션 레이아웃 ---
        stampSectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(titleLabel)
        }
        
        stampBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(stampSectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100) // 배경 높이 고정
        }
        
        stampStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        // --- 주변 문화 전시 공간 레이아웃 ---
        nearbySectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(stampBackgroundView.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }

        nearbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nearbySectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200) // 셀 높이(150) + 레이블 높이 + 간격
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
            make.bottom.equalToSuperview().inset(20) // contentView의 끝 지정
        }
    }
    
    // --- Helper Methods ---
    
    // 스탬프 더미 데이터를 UI에 채우는 함수
    private func populateStampData() {
        viewModel.stamps.forEach { stamp in
            let imageView = UIImageView()
            // imageView.image = UIImage(named: stamp.imageName) // 실제 이미지
            imageView.backgroundColor = .darkGray
            imageView.layer.cornerRadius = 35 // 원형 이미지 (크기 70x70)
            imageView.clipsToBounds = true
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(70)
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
        stackView.distribution = .fillEqually
        return stackView
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 16
        // 컬렉션뷰 좌측에만 패딩 추가
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
