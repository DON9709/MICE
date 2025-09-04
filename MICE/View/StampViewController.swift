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
    
    var stamp: Stamp?
    
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
    let firstHeaderStampView = UIImageView()
    let secondHeaderStampView = UIImageView()
    let thirdHeaderStampView = UIImageView()
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
    
    //획득 날짜 표시
    private let dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "획득 날짜 : yyyy.MM.dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        //Stamp 데이터를 불러오는 로직
        let downloader = KingfisherManager.shared.downloader
        downloader.downloadTimeout = 15
        downloader.sessionConfiguration.waitsForConnectivity = true
        downloader.sessionConfiguration.httpMaximumConnectionsPerHost = 4
        
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayout()
        setupMenu()
        setupActions()
        
        //        viewModel.$selectedCategory
        //            .receive(on: RunLoop.main)
        //            .sink { [weak self] category in
        //                self?.stampFilterButton.setTitle(category, for: .normal)
        //            }
        //            .store(in: &cancellables)
    }
    
    private func setupViews() {
        //헤더 스탬프1
        firstHeaderStampView.layer.cornerRadius = 64
        firstHeaderStampView.clipsToBounds = false
        
        //헤더 스탬프2
        secondHeaderStampView.layer.cornerRadius = 48
        secondHeaderStampView.clipsToBounds = false
        
        //헤더 스탬프3
        thirdHeaderStampView.layer.cornerRadius = 48
        thirdHeaderStampView.clipsToBounds = false
        
        //헤더 스탬프1 라벨
        firstHeaderStampLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        firstHeaderStampLabel.textColor = .black
        firstHeaderStampLabel.textAlignment = .center
        //획득한 스탬프 중에서 획득날짜 기준으로 최신순으로 정리
        
        //헤더 스탬프2 라벨
        secondHeaderStampLabel.font = .systemFont(ofSize: 14, weight: .regular)
        secondHeaderStampLabel.textColor = .black
        secondHeaderStampLabel.textAlignment = .center
        //획득한 스탬프 중에서 획득날짜 기준으로 최신순으로 정리
        
        //헤더 스탬프3 라벨
        thirdHeaderStampLabel.font = .systemFont(ofSize: 14, weight: .regular)
        thirdHeaderStampLabel.textColor = .black
        thirdHeaderStampLabel.textAlignment = .center
        //획득한 스탬프 중에서 획득날짜 기준으로 최신순으로 정리
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //Stamp 데이터를 불러오는 로직
        Task { [weak self] in
            do {
                let result = try await StampService.shared.getAllStamps()
                await MainActor.run {
                    self?.stamps = result
                    self?.reloadCategory()
                    self?.acquiredStampsLoad()
                }
            } catch {
                print("[StampViewController] fetch error: \(error)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    //헤더 스탬프 획득한 일자 최신순 나타나게끔하는 로직 + 카테고리별 색상 분류 + 획득한 스탬프 레이블 표시
    private func acquiredStampsLoad(){
        let acquiredStamps = stamps.filter { $0.isAcquired == true }
        let acquiredStampsOrdered = acquiredStamps.sorted { $0.acquiredAt ?? Date() > $1.acquiredAt ?? Date() }//Date() 기본값으로 현재시간을 넣음.
        //헤더스탬프 1
        if let urlString = acquiredStampsOrdered.first?.stampimg, let url = URL(string: urlString) {
            firstHeaderStampView.kf.setImage(with: url, options: [
                .imageModifier(AnyImageModifier { image in
                    image.withRenderingMode(.alwaysTemplate)
                })
            ])
            firstHeaderStampLabel.text = acquiredStampsOrdered.first?.title
            if let stampno = acquiredStampsOrdered.first?.stampno {
                switch stampno {
                case 1...79:
                    firstHeaderStampView.tintColor = UIColor(red: 11/255, green: 160/255, blue: 172/255, alpha: 1)//박물관
                case 80...128:
                    firstHeaderStampView.tintColor = UIColor(red: 247/255, green: 106/255, blue: 1/255, alpha: 1)//미술관
                case 129...153:
                    firstHeaderStampView.tintColor = UIColor(red: 101/255, green: 0/255, blue: 0/255, alpha: 1)//기념관
                case 154...177:
                    firstHeaderStampView.tintColor = UIColor(red: 0/255, green: 2/255, blue: 105/255, alpha: 1)//전시관
                default:
                    firstHeaderStampView.tintColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)//그 외
                }
            }
        } else {
            firstHeaderStampView.image = UIImage(named: "Mystery")
            firstHeaderStampLabel.text = ""
        }
        
        //헤더스탬프 2
        if acquiredStampsOrdered.count > 1 {
            if let urlString = acquiredStampsOrdered[1].stampimg, let url = URL(string: urlString) {
                secondHeaderStampView.kf.setImage(with: url, options: [
                    .imageModifier(AnyImageModifier { image in
                        image.withRenderingMode(.alwaysTemplate)
                    })
                ])
                secondHeaderStampLabel.text = acquiredStampsOrdered[1].title
                if let stampno = acquiredStampsOrdered[1].stampno {
                    switch stampno {
                    case 1...79:
                        secondHeaderStampView.tintColor = UIColor(red: 11/255, green: 160/255, blue: 172/255, alpha: 1)//박물관
                    case 80...128:
                        secondHeaderStampView.tintColor = UIColor(red: 247/255, green: 106/255, blue: 1/255, alpha: 1)//미술관
                    case 129...153:
                        secondHeaderStampView.tintColor = UIColor(red: 101/255, green: 0/255, blue: 0/255, alpha: 1)//기념관
                    case 154...177:
                        secondHeaderStampView.tintColor = UIColor(red: 0/255, green: 2/255, blue: 105/255, alpha: 1)//전시관
                    default:
                        secondHeaderStampView.tintColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)//그 외
                    }
                }
            } else {
                secondHeaderStampView.image = UIImage(named: "Mystery")
                secondHeaderStampLabel.text = ""
            }
        }
        
        //헤더스탬프 3
        if acquiredStampsOrdered.count > 2 {
            if let urlString = acquiredStampsOrdered[2].stampimg, let url = URL(string: urlString) {
                thirdHeaderStampView.kf.setImage(with: url, options: [
                    .imageModifier(AnyImageModifier { image in
                        image.withRenderingMode(.alwaysTemplate)
                    })
                ])
                thirdHeaderStampLabel.text = acquiredStampsOrdered[2].title
                if let stampno = acquiredStampsOrdered[2].stampno {
                    switch stampno {
                    case 1...79:
                        thirdHeaderStampView.tintColor = UIColor(red: 11/255, green: 160/255, blue: 172/255, alpha: 1)//박물관
                    case 80...128:
                        thirdHeaderStampView.tintColor = UIColor(red: 247/255, green: 106/255, blue: 1/255, alpha: 1)//미술관
                    case 129...153:
                        thirdHeaderStampView.tintColor = UIColor(red: 101/255, green: 0/255, blue: 0/255, alpha: 1)//기념관
                    case 154...177:
                        thirdHeaderStampView.tintColor = UIColor(red: 0/255, green: 2/255, blue: 105/255, alpha: 1)//전시관
                    default:
                        thirdHeaderStampView.tintColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)//그 외
                    }
                }
            } else {
                thirdHeaderStampView.image = UIImage(named: "Mystery")
                thirdHeaderStampLabel.text = ""
            }
        }
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
