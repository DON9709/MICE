//
//  StampViewController.swift
//  MICE
//
//  Created by 장은새 on 8/25/25.
//

import UIKit
import SnapKit
import Combine
import Kingfisher

class StampViewController: UIViewController {
    
    //ViewModel
    private let viewModel = StampViewModel()
    private var cancellables = Set<AnyCancellable>()

    //HeaderRecnetlyStamps
    let firstHeaderStampView = UIView()
    let secondHeaderStampView = UIView()
    let thirdHeaderStampView = UIView()
    let firstHeaderStampLabel = UILabel()
    let secondHeaderStampLabel = UILabel()
    let thirdHeaderStampLabel = UILabel()
    
    //filterButton
    let stampFilterButton = UIButton()//스탬프 카테고리별 필터 드롭다운 텍스트필드 -> 드롭다운형태로 구현하는 방법을 모르겠음, rxswift? cocoapod?
    
    //StampGrid
    private let stampCollectionView: UICollectionView//전체 스탬프
    
    // MARK: - Init (콜렉션 레이아웃)
    init() {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 12
        flow.minimumLineSpacing = 16
        let side = (UIScreen.main.bounds.width - 32 - (12 * 3)) / 4.0
        flow.itemSize = CGSize(width: side, height: side)
        flow.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        stampCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayout()
        setupMenu()
        setupActions()
        
        viewModel.$selectedCategory
            .receive(on: RunLoop.main)
            .sink { [weak self] category in
                self?.stampFilterButton.setTitle(category, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        //헤더 스탬프1
        firstHeaderStampView.backgroundColor = .gray
        firstHeaderStampView.layer.cornerRadius = 64
        firstHeaderStampView.clipsToBounds = false
        
        //헤더 스탬프2
        secondHeaderStampView.backgroundColor = .blue
        secondHeaderStampView.layer.cornerRadius = 48
        secondHeaderStampView.clipsToBounds = false
        
        //헤더 스탬프3
        thirdHeaderStampView.backgroundColor = .red
        thirdHeaderStampView.layer.cornerRadius = 48
        thirdHeaderStampView.clipsToBounds = false
        
        //헤더 스탬프1 라벨
        firstHeaderStampLabel.text = "헤더스탬프 1"
        firstHeaderStampLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        firstHeaderStampLabel.textColor = .black
        firstHeaderStampLabel.textAlignment = .center
        
        //헤더 스탬프2 라벨
        secondHeaderStampLabel.text = "헤더스탬프 2"
        secondHeaderStampLabel.font = .systemFont(ofSize: 14, weight: .regular)
        secondHeaderStampLabel.textColor = .black
        secondHeaderStampLabel.textAlignment = .center
        
        //헤더 스탬프3 라벨
        thirdHeaderStampLabel.text = "헤더스탬프 3"
        thirdHeaderStampLabel.font = .systemFont(ofSize: 14, weight: .regular)
        thirdHeaderStampLabel.textColor = .black
        thirdHeaderStampLabel.textAlignment = .center
        
        //필터버튼
        stampFilterButton.backgroundColor = .gray
        stampFilterButton.layer.cornerRadius = 10
        stampFilterButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        
        //콜렉션뷰
        stampCollectionView.backgroundColor = .white
        stampCollectionView.register(StampColletionCell.self, forCellWithReuseIdentifier: StampColletionCell.identifier)
        stampCollectionView.dataSource = self
        stampCollectionView.delegate = self

        view.addSubview(firstHeaderStampView)
        view.addSubview(secondHeaderStampView)
        view.addSubview(thirdHeaderStampView)
        view.addSubview(firstHeaderStampLabel)
        view.addSubview(secondHeaderStampLabel)
        view.addSubview(thirdHeaderStampLabel)
        view.addSubview(stampFilterButton)
        view.addSubview(stampCollectionView)
        
        //최근획득스탬프 크게 그리기
        //        drawHeaderStamp(in: headerStampContainer)
    }
    
    private func setupLayout() {

        //헤더 스탬프1
        firstHeaderStampView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(77)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 128, height: 128))
        }
        //헤더 스탬프1 라벨
        firstHeaderStampLabel.snp.makeConstraints { make in
            make.top.equalTo(firstHeaderStampView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        //헤더 스탬프2
        secondHeaderStampView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 96, height: 96))
            make.centerY.equalTo(firstHeaderStampView)
            make.leading.equalTo(firstHeaderStampView.snp.trailing).offset(12)
        }
        
        //헤더 스탬프2 라벨
        secondHeaderStampLabel.snp.makeConstraints { make in
            make.top.equalTo(secondHeaderStampView.snp.bottom).offset(8)
            make.centerX.equalTo(secondHeaderStampView)
        }
        
        //헤더 스탬프3
        thirdHeaderStampView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 96, height: 96))
            make.centerY.equalTo(firstHeaderStampView)
            make.trailing.equalTo(firstHeaderStampView.snp.leading).offset(-12)
        }
        
        //헤더 스탬프3 라벨
        thirdHeaderStampLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdHeaderStampView.snp.bottom).offset(8)
            make.centerX.equalTo(thirdHeaderStampView)
        }
        
        //필터버튼
        stampFilterButton.snp.makeConstraints { make in
            make.top.equalTo(thirdHeaderStampLabel.snp.bottom).offset(62)
            make.trailing.equalToSuperview().inset(16)
            make.width.greaterThanOrEqualTo(81)
            make.height.equalTo(32)
            
        }
        //스탬프 그리드
        stampCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stampFilterButton.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupMenu() {
        let menu = UIMenu(title: "카테고리 ▼",
                          children: viewModel.items)
        
        stampFilterButton.menu = menu
        stampFilterButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupActions() {
        
    }
    
}
// MARK: - DataSource & Delegate
extension StampViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        32
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampColletionCell.identifier, for: indexPath) as? StampColletionCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //StampDetailViewController push/present
        let detailVC = StampDetailViewController()
            navigationController?.pushViewController(detailVC, animated: true)
    }
}

final class StampColletionCell: UICollectionViewCell {
    static let identifier = "StampCell"
    private let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.shouldRasterize = true
        imageView.backgroundColor = .systemGray6
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StampViewController {
    @objc private func tapBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
}
//#Preview {
//    StampViewController()
//}
