//
//  StampDetailViewController.swift
//  MICE
//
//  Created by 장은새 on 8/26/25.
//

import UIKit
import SnapKit
import Kingfisher

class StampDetailViewController: UIViewController {
    
    var isBookmarked = false
    
    var stamp: Stamp?
    
    //ViewModel
    private let viewModel = StampDetailViewModel()
    
    
    //전체 스크롤뷰 + 콘텐츠뷰
    let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //Navigation
    let backButton = UIButton(type: .system)//뒤로가기버튼 -> 이전화면으로 이동
    
    //달성한스탬프표시(획득시)
    let achievedStampLabel = UILabel()
    
    //HeaderCard
    let headerCardView = UIImageView()
    
    //즐겨찾기버튼
    let favoriteButton = UIButton()
    
    //스탬프이미지(획득시 컬러)
    let stampImageView = UIImageView()
    
    //스탬프 타이틀
    let stampTitleLabel = UILabel()
    
    //스탬프 주소
    let addressLabel = UILabel()
    
    //스탬프 주소 이미지
    let addressImageView = UIImageView()
    
    //스탬프 전화번호
    let phoneNumberLabel = UILabel()
    
    //스탬프 전화번호 이미지
    let phoneNumberImageView = UIImageView()
    
    //스탬프 홈페이지
    let homePageLabel = UILabel()
    
    //스탬프 홈페이지 이미지
    let heomePageImageView = UIImageView()
    
    // 섹션 구분선
    private let separatorTop = UIView()
    private let separatorBottom = UIView()
    
    //회득날짜(미획득시-> 미획득 스탬프)
    let achievedDateLabel = UILabel()
    
    //개요(라벨)
    let overviewLabel = UILabel()
    
    //개요(내용)
    let overviewContentLabel = UILabel()
    
    //스탬프획득하기(버튼)
    let getStampButton = UIButton(type: .system)
    
    //획득 날짜 표시
    private let dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "획득 날짜 : yyyy.MM.dd"
        return formatter
    }()
    
    // MARK TODO
    //getStampButton
    // 1. 이미 획득한 스탬프 = 버튼미활성화/회색/흰색
    // 2. 획득 가능한 스탬프 = 버튼활성화/보라색/흰색텍스트
    // 3. 미획득 스탬프 = 버튼활성화/보라색/흰색텍스트/획득장소로 가야지 획득가능하다는 alert처리
    
    //achievedDateLabel
    // 1. 이미 획득한 스탬프 = 획득날짜(getStampButton클릭한 날짜) 표기 + 보라색 색상표기
    // 2. 획득 가능한 스탬프 = 활성화된 getStampButton 클릭시 클릭된 날짜 표기
    // 3. 미획득 스탬프 = 미획득 스탬프 표기 + 보라색 색상표기
    
    //stampView
    // 1. 이미 획득한 스탬프 = 카테고리별 색상으로 컬러표시
    // 2. 획득 가능한 스탬프 = 회색 -> 활성화된 getStampButton 클릭시 카테고리별 색상 표시
    // 3. 미획득 스탬프 = 회색
    
    //achievedStampLabel
    // 1. 이미 획득한 스탬프("획득한 스탬프") = 회색 + 흰색텍스트 이미지 위에 표기 -> 디자인 색상도 어플 컬러코드와 일치하면 좋을 것 같음. ("회색"="획득"과 좀 안어울리는 것 같음.)
    // 2. 획득 가능한 스탬프 = 별도 표기 없음.
    // 3. 미획득 스탬프 = 나타나지않게끔
    
    override func viewDidLoad() {

        //획득한 스탬프 연결
        if stamp?.isAcquired == true {
            achievedStampLabel.isHidden = false
            if let date = stamp?.acquiredAt {
                achievedDateLabel.text = dataFormatter.string(from: date)
            } else {
                achievedDateLabel.text = "미획득 스탬프"
            }
            
            getStampButton.setTitleColor(UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1), for: .normal)
            getStampButton.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            getStampButton.isEnabled = false
            
            //stampno에 따라 획득한 스탬프 색상 다르게 처리
            if let stampno = stamp?.stampno {
                switch stampno {
                case 1...79:
                    stampImageView.tintColor = UIColor(red: 11/255, green: 160/255, blue: 172/255, alpha: 1)//박물관
                case 80...128:
                    stampImageView.tintColor = UIColor(red: 247/255, green: 106/255, blue: 1/255, alpha: 1)//미술관
                case 129...153:
                    stampImageView.tintColor = UIColor(red: 101/255, green: 0/255, blue: 0/255, alpha: 1)//기념관
                case 154...177:
                    stampImageView.tintColor = UIColor(red: 0/255, green: 2/255, blue: 105/255, alpha: 1)//전시관
                default:
                    stampImageView.tintColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)//그 외
                }
            } else {
                print("스탬프가 없습니다.")
            }
            
        } else {
            achievedStampLabel.isHidden = true
            stampImageView.tintColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)
            achievedDateLabel.text = "미획득 스탬프"
            getStampButton.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: .normal)
            getStampButton.backgroundColor = UIColor(red: 114/255, green: 76/255, blue: 249/255, alpha: 1)
        }
        
        //선택한 스탬프 장소이미지 연결
        if let urlString = stamp?.image, let url = URL(string: urlString) {
            headerCardView.kf.setImage(with: url)
        } else {
            headerCardView.image = nil
        }
        
        //선택한 스탬프 스탬프이미지 연결
        if let urlString = stamp?.stampimg, let url = URL(string: urlString) {
            stampImageView.kf.setImage(with: url, options: [
                .imageModifier(AnyImageModifier { image in
                    image.withRenderingMode(.alwaysTemplate)
                })
            ])
        } else {
            stampImageView.image = nil
        }
        
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        setupViews()
        setupLayout()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        //HeaderCard
        headerCardView.backgroundColor = .lightGray
        headerCardView.addSubview(favoriteButton)
        headerCardView.addSubview(achievedStampLabel)
        headerCardView.bringSubviewToFront(favoriteButton)
        headerCardView.isUserInteractionEnabled = true//UIView 안에서 버튼 동작하게하려면 작성해야함.
        
        //Navigation
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        
        //달성한스탬프표시(획득시)
        achievedStampLabel.text = "획득한 스탬프"
        achievedStampLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        achievedStampLabel.backgroundColor = UIColor(red: 114/255, green: 76/255, blue: 249/255, alpha: 1)
        achievedStampLabel.layer.cornerRadius = 13
        achievedStampLabel.layer.masksToBounds = true
        achievedStampLabel.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        achievedStampLabel.textAlignment = .center
        achievedStampLabel.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        achievedStampLabel.isUserInteractionEnabled = false
        
        //즐겨찾기버튼
        favoriteButton.setImage(UIImage(named: "BookMark"), for: .normal)
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.layer.masksToBounds = false
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOpacity = 0.15
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        favoriteButton.layer.shadowRadius = 4
        favoriteButton.isSelected = stamp?.isAcquired ?? false
        
        //스탬프이미지(획득시 컬러)
        stampImageView.backgroundColor = .white
        stampImageView.contentMode = .scaleAspectFill
        stampImageView.frame = CGRect(x: 50, y: 50, width: 106, height: 106)
        stampImageView.layer.cornerRadius = stampImageView.frame.width / 2
        stampImageView.clipsToBounds = true
        
        //스탬프 타이틀
        stampTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        //타이틀 언래핑
        if let stamp = stamp {
            stampTitleLabel.text = stamp.title
        }else{
            print("타이틀 없음")
        }
        
        //스탬프 주소
        addressLabel.font = .systemFont(ofSize: 15)
        //주소 언래핑
        if let stamp = stamp {
            addressLabel.text = stamp.addr
        }else{
            print("주소 없음")
        }
        
        //스탬프 주소, 전화번호, 홈페이지 이미지
        addressImageView.image = UIImage(named: "Marker")
        phoneNumberImageView.image = UIImage(named: "Phone")
        heomePageImageView.image = UIImage(named: "Link")
        
        //스탬프 전화번호
        phoneNumberLabel.font = .systemFont(ofSize: 15)
        //전화번호 언래핑
        if let stamp = stamp {
            phoneNumberLabel.text = stamp.tel
        }else{
            phoneNumberLabel.text = "전화번호 없음"
        }
        
        //스탬프 홈페이지
        homePageLabel.font = .systemFont(ofSize: 15)
        //홈페이지 언래핑
        if let stamp = stamp {
            homePageLabel.text = stamp.homepage
        }else{
            print("홈페이지 주소 없음")
        }
        
        //회득날짜(미획득시-> 미획득 스탬프)
        achievedDateLabel.font = .systemFont(ofSize: 15)
        achievedDateLabel.textColor = UIColor(red: 114/255, green: 76/255, blue: 249/255, alpha: 1)

        //개요(라벨)
        overviewLabel.font = .systemFont(ofSize: 16, weight: .bold)
        overviewLabel.text = "개요"
        
        //개요(내용)
        overviewContentLabel.font = .systemFont(ofSize: 15)
        //개요 언래핑
        if let stamp = stamp {
            overviewContentLabel.text = stamp.overview
        }else{
            overviewContentLabel.text = "내용 없음"
        }
        overviewContentLabel.numberOfLines = 0
        
        //스탬프획득하기(버튼)
        getStampButton.setTitle("스탬프 획득하기", for: .normal)
        getStampButton.layer.cornerRadius = 8
        //텍스트 크기 조절 방법?
        
        view.addSubview(backButton)
        
        contentView.addSubview(headerCardView)
        contentView.addSubview(stampTitleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(homePageLabel)
        contentView.addSubview(achievedDateLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(overviewContentLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(achievedStampLabel)
        contentView.addSubview(stampImageView)
        contentView.addSubview(addressImageView)
        contentView.addSubview(phoneNumberImageView)
        contentView.addSubview(heomePageImageView)
        
        
        // 섹션 구분선 스타일
        [separatorTop, separatorBottom].forEach { line in
            line.backgroundColor = .systemGray4
            contentView.addSubview(line)
        }
        
        view.addSubview(getStampButton)
    }
    
    private func setupLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(backButton.snp.bottom).offset(18)
            make.bottom.equalTo(getStampButton.snp.top).offset(-12)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        backButton.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(20)
        }
        
        achievedStampLabel.snp.makeConstraints { make in
            make.top.equalTo(headerCardView)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(141)
        }
        
        // HeaderCard Layout
        headerCardView.snp.remakeConstraints { make in
            make.height.equalTo(190)//191 수정
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        stampImageView.snp.makeConstraints { make in
            make.trailing.equalTo(headerCardView.snp.trailing).inset(16)
            make.size.equalTo(106)
            make.bottom.equalTo(headerCardView.snp.bottom).offset(42)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(40)
            make.top.equalTo(headerCardView.snp.top).inset(8)
        }
        
        stampTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerCardView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        //스탬프 주소, 전화번호, 홈페이지 이미지
        addressImageView.snp.makeConstraints { make in
            make.top.equalTo(stampTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(addressLabel)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(stampTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(42)
        }
        
        phoneNumberImageView.snp.makeConstraints { make in
            make.top.equalTo(addressImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(phoneNumberLabel)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(42)
        }
        
        heomePageImageView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(homePageLabel)
        }
        
        homePageLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(42)
        }
        
        achievedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(homePageLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        // 연락처/정보 블록 하단 구분선
        separatorTop.snp.makeConstraints { make in
            make.top.equalTo(achievedDateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2 / UIScreen.main.scale)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(achievedDateLabel.snp.bottom).offset(38)
            make.leading.equalToSuperview().offset(16)
        }
        
        overviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        // 본문(개요) 하단 구분선
        separatorBottom.snp.makeConstraints { make in
            make.top.equalTo(overviewContentLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2 / UIScreen.main.scale)
        }
        
        getStampButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        getStampButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
    }
}

private extension StampDetailViewController {
    @objc private func tapBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func toggleFavorite() {
        favoriteButton.isSelected.toggle()
        print("123")
//        print("selectedStamp.contentid = \(stamp?.contentid)")
        if favoriteButton.isSelected {
            favoriteButton.setImage(UIImage(named: "BookMark.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "BookMark"), for: .normal)
        }
    }
}
//#Preview {
//    StampDetailViewController()
//}
