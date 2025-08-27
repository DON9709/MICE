//
//  StampViewController.swift
//  MICE
//
//  Created by 장은새 on 8/25/25.
//

import UIKit
import SnapKit

class StampViewController: UIViewController {
    
    //ViewModel
    private let viewModel = StampViewModel()
    
    //Navigation
    let backButton = UIButton(type: .system)//뒤로가기버튼 -> 홈 화면으로 이동
    let backButtonTitleLabel = UILabel()//뒤로가기버튼 라벨
    
    //HeaderRecnetlyStamps
    let firstHeaderStampContainer = UIView()
    let secondHeaderStampContainer = UIView()
    let thirdHeaderStampContainer = UIView()
    let headerStampLabel = UILabel()
    
    //filterButton
    let stampFilterButton = UIButton()//스탬프 카테고리별 필터 드롭다운 텍스트필드 -> 드롭다운형태로 구현하는 방법을 모르겠음, rxswift? cocoapod?
    
    //StampGrid
    private let stampCollectionView: UICollectionView//전체 스탬프
    
    //StampFilterButton items
    var items: [UIAction] {
        let museum = UIAction(
            title: "박물관",
            handler: { [unowned self] _ in
                self.stampFilterButton.setTitle("박물관", for: .normal)
            })
        
        let gallery = UIAction(
            title: "미술관",
            handler: { [unowned self] _ in
                self.stampFilterButton.setTitle("미술관", for: .normal)
            })
        
        let exhibition = UIAction(
            title: "전시관",
            handler: { [unowned self] _ in
                self.stampFilterButton.setTitle("전시관", for: .normal)
            })
        
        let memorial = UIAction(
            title: "기념관",
            handler: { [unowned self] _ in
                self.stampFilterButton.setTitle("기념관", for: .normal)
            })
        
        return ([museum, gallery, exhibition, memorial])
        
    }
    
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
    }
    
    private func setupViews() {
        //상단 네비게이션버튼
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        
        backButtonTitleLabel.text = "달성 기록"
        backButtonTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        backButtonTitleLabel.textAlignment = .center
        
        //헤더 스탬프1
        firstHeaderStampContainer.backgroundColor = .gray
        firstHeaderStampContainer.layer.cornerRadius = 64
        firstHeaderStampContainer.clipsToBounds = false
        
        //헤더 스탬프2
        secondHeaderStampContainer.backgroundColor = .blue
        secondHeaderStampContainer.layer.cornerRadius = 40
        secondHeaderStampContainer.clipsToBounds = false
        
        //헤더 스탬프3
        thirdHeaderStampContainer.backgroundColor = .red
        thirdHeaderStampContainer.layer.cornerRadius = 40
        thirdHeaderStampContainer.clipsToBounds = false
        
        //라벨
        headerStampLabel.text = "획득한 스탬프명"
        headerStampLabel.font = .systemFont(ofSize: 13, weight: .medium)
        headerStampLabel.textColor = .secondaryLabel
        headerStampLabel.textAlignment = .center
        
        //필터버튼
        stampFilterButton.frame = CGRect(x: 200, y: 250, width: 350, height: 50)
        stampFilterButton.backgroundColor = .gray
        stampFilterButton.layer.cornerRadius = 10
        stampFilterButton.setTitle("박물관", for: .normal)
        stampFilterButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        
        //콜렉션뷰
        stampCollectionView.backgroundColor = .white
        stampCollectionView.register(StampColletionCell.self, forCellWithReuseIdentifier: StampColletionCell.identifier)
        stampCollectionView.dataSource = self
        stampCollectionView.delegate = self
        
        view.addSubview(backButton)
        view.addSubview(backButtonTitleLabel)
        view.addSubview(firstHeaderStampContainer)
        view.addSubview(secondHeaderStampContainer)
        view.addSubview(thirdHeaderStampContainer)
        view.addSubview(headerStampLabel)
        view.addSubview(stampFilterButton)
        view.addSubview(stampCollectionView)
        
        //최근획득스탬프 크게 그리기
        //        drawHeaderStamp(in: headerStampContainer)
    }
    
    private func setupLayout() {
        //상단 네비게이션버튼
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(CGSize(width: 44, height: 36))
        }
        backButtonTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(3)
        }
        
        //헤더 스탬프1
        firstHeaderStampContainer.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 128, height: 128))
        }
        headerStampLabel.snp.makeConstraints { make in
            make.top.equalTo(firstHeaderStampContainer.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        //헤더 스탬프2
        secondHeaderStampContainer.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.centerY.equalTo(firstHeaderStampContainer)
            make.trailing.equalToSuperview().inset(16)
        }
        
        //헤더 스탬프3
        thirdHeaderStampContainer.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.centerY.equalTo(firstHeaderStampContainer)
            make.leading.equalToSuperview().inset(16)
        }
        
        //필터버튼
        stampFilterButton.snp.makeConstraints { make in
            make.top.equalTo(headerStampLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        //스탬프 그리드
        stampCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stampFilterButton.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupMenu() {
        let menu = UIMenu(title: "카테고리",
                          children: items)
        
        stampFilterButton.menu = menu
        stampFilterButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        
    }
    
}
// MARK: - DataSource & Delegate
extension StampViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampColletionCell.identifier, for: indexPath) as? StampColletionCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //StampDetailViewController push/present
        let detailVC = StampDetailViewController()
        if let nav = self.navigationController {
            nav.pushViewController(detailVC, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: detailVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
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
