//
//  HomeViewController.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import UIKit
import SnapKit
import Combine

class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var achievedCountLabel = createCountLabel(text: "0")
    private lazy var unachievedCountLabel = createCountLabel(text: "0")

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.mainTitle
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 114/255, green: 76/255, blue: 249/255, alpha: 1)
        return label
    }()

    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private lazy var nearbySectionTitleLabel: UILabel = createSectionTitle(title: viewModel.nearbySectionTitle)
    private lazy var nearbyCollectionView: UICollectionView = createExhibitionCollectionView()

    private lazy var hotSectionTitleLabel: UILabel = createSectionTitle(title: viewModel.hotSectionTitle)
    private lazy var hotCollectionView: UICollectionView = createExhibitionCollectionView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionView()
        setupUI()
        
        bindViewModel()
        Task {
            await viewModel.fetchAllHomeData()
        }
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
        viewModel.$achievedStampCount
            .map { "\($0)" }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: achievedCountLabel)
            .store(in: &cancellables)
            
        viewModel.$unachievedStampCount
            .map { "\($0)" }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: unachievedCountLabel)
            .store(in: &cancellables)
            
        viewModel.$recentlyAcquiredStamps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stamps in
                if let layout = self?.stampExamplesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    if stamps.count == 1 {
                        let totalCellWidth = layout.itemSize.width
                        let totalSpacing = self?.view.frame.width ?? 0 - totalCellWidth - 20
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: totalSpacing)
                    } else {
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                    }
                }
                self?.stampExamplesCollectionView.reloadData()
            }
            .store(in: &cancellables)
            
        viewModel.$nearbyStamps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.nearbyCollectionView.reloadData()
            }
            .store(in: &cancellables)
            
        viewModel.$hotStamps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hotCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        [stampExamplesCollectionView, nearbyCollectionView, hotCollectionView].forEach {
            $0.dataSource = self
            $0.delegate = self
        }
        
        stampExamplesCollectionView.register(StampExampleCell.self, forCellWithReuseIdentifier: StampExampleCell.identifier)
        nearbyCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
        hotCollectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: ExhibitionCell.identifier)
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, notificationButton, stampSectionTitleLabel, stampSummaryContainerView, stampExamplesCollectionView, nearbySectionTitleLabel, nearbyCollectionView, hotSectionTitleLabel, hotCollectionView].forEach { contentView.addSubview($0) }
        
        setupStampSummaryView()

        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        contentView.snp.makeConstraints { $0.edges.width.equalToSuperview() }

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
            // ▼▼▼▼▼ 컬렉션 뷰 높이를 셀 높이에 맞게 조절 ▼▼▼▼▼
            make.height.equalTo(250)
        }

        hotSectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nearbyCollectionView.snp.bottom).offset(40)
            make.leading.equalTo(titleLabel)
        }

        hotCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hotSectionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            // ▼▼▼▼▼ 컬렉션 뷰 높이를 셀 높이에 맞게 조절 ▼▼▼▼▼
            make.height.equalTo(250)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupStampSummaryView() {
        let achievedTitleLabel = createTitleLabel(text: "달성한 스탬프")
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
        
        let mainStack = UIStackView(arrangedSubviews: [leftStack, separator, rightStack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        mainStack.alignment = .center
        
        stampSummaryContainerView.addSubview(mainStack)
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        separator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        leftStack.snp.makeConstraints { $0.width.equalTo(rightStack) }
    }
    
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

    private func createExhibitionCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
            return viewModel.recentlyAcquiredStamps.count
        } else if collectionView == nearbyCollectionView {
            return viewModel.nearbyStamps.count
        } else {
            return viewModel.hotStamps.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == stampExamplesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampExampleCell.identifier, for: indexPath) as! StampExampleCell
            let stamp = viewModel.recentlyAcquiredStamps[indexPath.item]
            cell.configure(with: stamp)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionCell.identifier, for: indexPath) as! ExhibitionCell
            let stamp = (collectionView == nearbyCollectionView) ? viewModel.nearbyStamps[indexPath.item] : viewModel.hotStamps[indexPath.item]
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
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // ▼▼▼▼▼ 셀 크기를 요청하신 310x248 사이즈로 고정 ▼▼▼▼▼
        if collectionView == nearbyCollectionView || collectionView == hotCollectionView {
            return CGSize(width: 310, height: 248)
        }
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize(width: 120, height: 130)
    }
}
