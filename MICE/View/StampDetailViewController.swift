//
//  StampDetailViewController.swift
//  MICE
//
//  Created by 장은새 on 8/26/25.
//

import UIKit
import SnapKit

class StampDetailViewController: UIViewController {
    
    //ViewModel
    private let viewModel = StampDetailViewModel()
    
    //Navigation
    let backButton = UIButton(type: .system)//뒤로가기버튼 -> 이전화면으로 이동
    
    //달성한스탬프표시(획득시)
    let achievedStampLabel = UILabel()
    
    //HeaderCard
    let headerCardView = UIImageView()
    
    //즐겨찾기버튼
    let favoriteButton = UIButton(type: .system)
    
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
    
    //회득날짜(미획득시-> 미획득 스탬프)
    let achievedDateLabel = UILabel()
    
    //개요(라벨)
    let overviewLabel = UILabel()
    
    //개요(내용)
    let overviewContentLabel = UILabel()
    
    //스탬프획득하기(버튼)
    let getStampButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        
        
        //Navigation
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        
        //달성한스탬프표시(획득시)
        achievedStampLabel.text = "달성한 스탬프"
        achievedStampLabel.backgroundColor = .systemGray6
        achievedStampLabel.layer.cornerRadius = 13
        achievedStampLabel.layer.masksToBounds = true
        achievedStampLabel.textAlignment = .center
        achievedStampLabel.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        achievedStampLabel.isUserInteractionEnabled = false
        
        //즐겨찾기버튼
        favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        favoriteButton.tintColor = .systemPurple
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.layer.masksToBounds = false
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOpacity = 0.15
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        favoriteButton.layer.shadowRadius = 4
        
        //스탬프이미지(획득시 컬러)
        stampImageView.contentMode = .scaleAspectFit
        stampImageView.tintColor = .label
        stampImageView.image = UIImage(systemName: "target")
        
        //스탬프 타이틀
        stampTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        stampTitleLabel.text = "아침고요수목원"
        
        //스탬프 주소
        addressLabel.font = .systemFont(ofSize: 15)
        addressLabel.text = "경기도 가평군 상면 수목원로 123-456789 아침고요수목원"
        
        //스탬프 주소, 전화번호, 홈페이지 이미지
        addressImageView.image = UIImage(systemName: "location.fill")
        phoneNumberImageView.image = UIImage(systemName: "phone.fill")
        heomePageImageView.image = UIImage(systemName: "location.fill")
        
        //스탬프 전화번호
        phoneNumberLabel.font = .systemFont(ofSize: 15)
        phoneNumberLabel.text = "1544-6703"
        
        //스탬프 홈페이지
        homePageLabel.font = .systemFont(ofSize: 15)
        homePageLabel.text = "https://www.morningcalm.co.kr/html/main.php"
        
        //회득날짜(미획득시-> 미획득 스탬프)
        achievedDateLabel.font = .systemFont(ofSize: 15)
        achievedDateLabel.text = "미획득 스탬프"
        achievedDateLabel.textColor = .red
        
        //개요(라벨)
        overviewLabel.font = .systemFont(ofSize: 16, weight: .bold)
        overviewLabel.text = "개요"
        
        //개요(내용)
        overviewContentLabel.font = .systemFont(ofSize: 15)
        overviewContentLabel.text = "개요를 작성하세요."
        
        //스탬프획득하기(버튼)
        getStampButton.setTitle("스탬프획득하기", for: .normal)
        getStampButton.backgroundColor = .black
        getStampButton.setTitleColor(.white, for: .normal)
        getStampButton.layer.cornerRadius = 8
        
        view.addSubview(headerCardView)
        view.addSubview(stampTitleLabel)
        view.addSubview(addressLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(homePageLabel)
        view.addSubview(achievedDateLabel)
        view.addSubview(overviewLabel)
        view.addSubview(overviewContentLabel)
        view.addSubview(addressLabel)
        view.addSubview(getStampButton)
        view.addSubview(achievedStampLabel)
        view.addSubview(stampImageView)
        view.addSubview(backButton)
        view.addSubview(addressImageView)
        view.addSubview(phoneNumberImageView)
        view.addSubview(heomePageImageView)
        
    }
    
    private func setupLayout() {
        
        backButton.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
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
            make.top.equalTo(backButton.snp.bottom).offset(18)
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
            make.leading.equalToSuperview().offset(42)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(achievedDateLabel.snp.bottom).offset(38)
            make.leading.equalToSuperview().offset(16)
        }
        
        overviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(16)
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
        if favoriteButton.isSelected {
            favoriteButton.backgroundColor = .systemPurple
            favoriteButton.tintColor = .white
        } else {
            favoriteButton.backgroundColor = .white
            favoriteButton.tintColor = .systemPurple
        }
    }
}
//#Preview {
//    StampDetailViewController()
//}
