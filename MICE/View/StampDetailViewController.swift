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
    let backButtonTitleLabel = UILabel()//뒤로가기버튼 라벨
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
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
    
    //스탬프 전화번호
    let phoneNumberLabel = UILabel()
    
    //스탬프 홈페이지
    let homePageLabel = UILabel()
    
    //회득날짜(미획득시-> 미획득 스탬프)
    let achievedDateLabel = UILabel()
    
    //개요(라벨)
    let overviewLabel = UILabel()
    
    //개요(내용)
    let overviewContentLabel = UILabel()
    
    //이용안내
    let guideLabel = UILabel()
    
    //주최자 정보
    let organizerLabel = UILabel()
    
    //주최자 연락처
    let contactLabel = UILabel()
    
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
        
        contentStack.axis = .vertical
        contentStack.spacing = 12
        
        [achievedStampLabel, headerCardView, stampImageView, stampTitleLabel, addressLabel, phoneNumberLabel, homePageLabel, achievedDateLabel, overviewLabel, overviewContentLabel, guideLabel, organizerLabel, contactLabel, getStampButton].forEach {
            contentStack.addArrangedSubview($0)
        }
        
        //Navigation
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        
        backButtonTitleLabel.text = "뒤로 가기"
        backButtonTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        backButtonTitleLabel.textAlignment = .center
        
        //달성한스탬프표시(획득시)
        achievedStampLabel.text = "달성한 스탬프"
        achievedStampLabel.backgroundColor = .systemGray6
        achievedStampLabel.layer.cornerRadius = 13
        achievedStampLabel.layer.masksToBounds = true
        achievedStampLabel.textAlignment = .center
        achievedStampLabel.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        achievedStampLabel.isUserInteractionEnabled = false
        
        //HeaderCard
        headerCardView.backgroundColor = .white
        headerCardView.layer.borderWidth = 1
        headerCardView.layer.borderColor = UIColor.systemGray4.cgColor
        headerCardView.layer.cornerRadius = 8
        headerCardView.layer.masksToBounds = true
        
        //즐겨찾기버튼
        favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        favoriteButton.tintColor = .systemBlue
        
        //스탬프이미지(획득시 컬러)
        stampImageView.contentMode = .scaleAspectFit
        stampImageView.tintColor = .label
        stampImageView.image = UIImage(systemName: "target")
        
        //스탬프 타이틀
        stampTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        //스탬프 주소
        addressLabel.font = .systemFont(ofSize: 15)
        
        //스탬프 전화번호
        phoneNumberLabel.font = .systemFont(ofSize: 15)
        
        //스탬프 홈페이지
        homePageLabel.font = .systemFont(ofSize: 15)
        
        //회득날짜(미획득시-> 미획득 스탬프)
        achievedDateLabel.font = .systemFont(ofSize: 15)
        
        //개요(라벨)
        overviewLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        overviewLabel.text = "개요"
        
        //개요(내용)
        overviewContentLabel.font = .systemFont(ofSize: 15)
        
        //이용안내
        guideLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        guideLabel.text = "이용안내"
        
        //주최자 정보
        organizerLabel.font = .systemFont(ofSize: 15)
        organizerLabel.text = "주최자 정보"
        
        //주최자 연락처
        contactLabel.font = .systemFont(ofSize: 15)
        contactLabel.text = "주최자 연락처"
        
        //스탬프획득하기(버튼)
        getStampButton.setTitle("스탬프획득하기", for: .normal)
        getStampButton.backgroundColor = .black
        getStampButton.setTitleColor(.white, for: .normal)
        getStampButton.layer.cornerRadius = 8
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(getStampButton)
        
    }
    
    private func setupLayout() {
        let topBar = UIView()
        view.addSubview(topBar)
        view.addSubview(stampImageView)
        
        topBar.addSubview(backButton)
        topBar.addSubview(backButtonTitleLabel)
        
        topBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        
        backButtonTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing).offset(8)
        }
        
        achievedStampLabel.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().inset(16)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(achievedStampLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(getStampButton.snp.top).offset(-12)
        }
        
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        // HeaderCard Layout
        // Url로 이미지 추가
        headerCardView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(160)
        }
        
        stampImageView.snp.makeConstraints { make in
            make.right.equalTo(headerCardView.snp.right).inset(13)
            make.size.equalTo(84)
            make.bottom.equalTo(headerCardView.snp.bottom).offset(42)
        }
        
        // Create infoStack inside headerCardView
        let infoStack = UIStackView(arrangedSubviews: [addressLabel, phoneNumberLabel, achievedDateLabel, homePageLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        headerCardView.addSubview(stampTitleLabel)
        headerCardView.addSubview(favoriteButton)
        headerCardView.addSubview(infoStack)
        headerCardView.backgroundColor = .green
        
        stampTitleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalTo(stampImageView.snp.left).offset(-12)
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(30)
            make.top.equalTo(headerCardView.snp.top).inset(12)
        }
        
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(stampTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        // overviewBox container
        let overviewBox = UIView()
        overviewBox.layer.cornerRadius = 8
        overviewBox.layer.borderWidth = 0
        overviewBox.layer.masksToBounds = true
        
        contentStack.insertArrangedSubview(overviewBox, at: contentStack.arrangedSubviews.firstIndex(of: overviewContentLabel) ?? 0)
        overviewContentLabel.removeFromSuperview()
        overviewBox.addSubview(overviewContentLabel)
        overviewContentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        // guideBox container
        let guideBox = UIView()
        guideBox.layer.cornerRadius = 8
        guideBox.layer.borderWidth = 0
        guideBox.layer.masksToBounds = true
        
        contentStack.insertArrangedSubview(guideBox, at: contentStack.arrangedSubviews.firstIndex(of: organizerLabel) ?? 0)
        organizerLabel.removeFromSuperview()
        contactLabel.removeFromSuperview()
        
        let guideStack = UIStackView(arrangedSubviews: [organizerLabel, contactLabel])
        guideStack.axis = .vertical
        guideStack.spacing = 8
        
        guideBox.addSubview(guideStack)
        guideStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        guideBox.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        getStampButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        
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
}
//#Preview {
//    StampDetailViewController()
//}
