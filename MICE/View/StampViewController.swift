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
    
    // DataSource
    private var stamps: [Stamp] = []
    
    //데이터 호출 카테고리 분류
    private enum StampCategory {
        case museum      // 박물관 1~79
        case gallery     // 미술관 80~128
        case memorial    // 기념관 129~153
        case exhibition  // 전시관 154~177

        var title: String {
            switch self {
            case .museum: return "박물관"
            case .gallery: return "미술관"
            case .memorial: return "기념관"
            case .exhibition: return "전시관"
            }
        }

        var oneBasedRange: ClosedRange<Int> {
            switch self {
            case .museum: return 1...79
            case .gallery: return 80...128
            case .memorial: return 129...153
            case .exhibition: return 154...177
            }
        }
    }

    private var selectedCategory: StampCategory = .museum

    private var displayedStamps: [Stamp] {
        guard !stamps.isEmpty else { return [] }
        let r = selectedCategory.oneBasedRange
        let start = max(r.lowerBound - 1, 0)
        let end = min(r.upperBound - 1, max(stamps.count - 1, 0))
        if start > end { return [] }
        return Array(stamps[start...end])
    }

    //HeaderRecnetlyStamps
    let firstHeaderStampView = UIView()
    let secondHeaderStampView = UIView()
    let thirdHeaderStampView = UIView()
    let firstHeaderStampLabel = UILabel()
    let secondHeaderStampLabel = UILabel()
    let thirdHeaderStampLabel = UILabel()
    
    //filterButton
    let stampFilterButton = UIButton()//스탬프 카테고리별 필터 드롭다운 텍스트필드 -> 드롭다운형태로 구현하는 방법을 모르겠음, rxswift? cocoapod?
    
    //filterContainerView
    let stampFilterContainerView = UIView()
    
    //filterButtonLabel
    let stampFilterLabel = UILabel()
    
    //filterButtonImage
    let stampFilterImageView = UIImageView()
    
    //StampGrid
    private let stampCollectionView: UICollectionView//전체 스탬프
    
    //StampFilterButton items
       var items: [UIAction] {
           let museum = UIAction(title: "박물관") { [unowned self] _ in
               self.selectedCategory = .museum
               self.stampFilterLabel.text = StampCategory.museum.title
               self.reloadCategory()
           }
           let gallery = UIAction(title: "미술관") { [unowned self] _ in
               self.selectedCategory = .gallery
               self.stampFilterLabel.text = StampCategory.gallery.title
               self.reloadCategory()
           }
           let exhibition = UIAction(title: "전시관") { [unowned self] _ in
               self.selectedCategory = .exhibition
               self.stampFilterLabel.text = StampCategory.exhibition.title
               self.reloadCategory()
           }
           let memorial = UIAction(title: "기념관") { [unowned self] _ in
               self.selectedCategory = .memorial
               self.stampFilterLabel.text = StampCategory.memorial.title
               self.reloadCategory()
           }
           return [museum, gallery, exhibition, memorial]
       }
       
    
    // MARK: - Init (콜렉션 레이아웃)
    init() {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 12
        flow.minimumLineSpacing = 16
        flow.itemSize = CGSize(width: 72, height: 72)
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
        let downloader = KingfisherManager.shared.downloader
        downloader.downloadTimeout = 15
        downloader.sessionConfiguration.waitsForConnectivity = true
        downloader.sessionConfiguration.httpMaximumConnectionsPerHost = 4
        Task { [weak self] in
            do {
                let result = try await StampService.shared.getAllStamps()
                await MainActor.run {
                    self?.stamps = result
                    self?.reloadCategory()
                }
            } catch {
                print("[StampViewController] fetch error: \(error)")
            }
        }
//        viewModel.$selectedCategory
//            .receive(on: RunLoop.main)
//            .sink { [weak self] category in
//                self?.stampFilterButton.setTitle(category, for: .normal)
//            }
//            .store(in: &cancellables)
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
        stampFilterButton.backgroundColor = .clear
        
        //filterContainerView
        stampFilterContainerView.backgroundColor = .gray
        stampFilterContainerView.layer.cornerRadius = 10
        
        //filterButtonLabel
        stampFilterLabel.text = "박물관"
        stampFilterLabel.textColor = .white
        stampFilterLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        //filterButtonImage
        stampFilterImageView.image = UIImage(named: "MenuButton")
        
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
        view.addSubview(stampCollectionView)
        view.addSubview(stampFilterContainerView)
        stampFilterContainerView.addSubview(stampFilterLabel)
        stampFilterContainerView.addSubview(stampFilterImageView)
        view.addSubview(stampFilterButton)
        
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
        
        //filterContainerView
        stampFilterContainerView.snp.makeConstraints { make in
            make.top.equalTo(thirdHeaderStampLabel.snp.bottom).offset(62)
            make.trailing.equalToSuperview().inset(16)
            make.width.greaterThanOrEqualTo(81)
            make.height.equalTo(32)
        }
            
        //filterButtonLabel
        stampFilterLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15.5)
        }
            
        //filterButtonImage
        stampFilterImageView.snp.makeConstraints { make in
            make.trailing.equalTo(stampFilterContainerView).inset(17.5)
            make.width.equalTo(8)
            make.height.equalTo(4)
            make.centerY.equalToSuperview()
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
                              children: items)
        
        stampFilterButton.menu = menu
        stampFilterButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupActions() {
        
    }
    
    private func reloadCategory() {
        stampCollectionView.setContentOffset(.zero, animated: false)
        stampCollectionView.reloadData()
    }
    
}
// MARK: - DataSource & Delegate
extension StampViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedStamps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampColletionCell.identifier, for: indexPath) as? StampColletionCell else {
            return UICollectionViewCell()
        }
        let stamp = displayedStamps[indexPath.item]
        if let urlString = stamp.stampimg, let url = URL(string: urlString) {
            cell.imageView.kf.setImage(with: url)
        } else {
            cell.imageView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = displayedStamps[indexPath.item]
//        print("\(selected.contentid)")
        let detailVC = StampDetailViewController()
        detailVC.stamp = selected
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
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 36
        imageView.layer.borderWidth = 0.0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.shouldRasterize = true
        imageView.backgroundColor = .systemGray6
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
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
