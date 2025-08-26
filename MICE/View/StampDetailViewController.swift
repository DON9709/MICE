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
        //        setupActions()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        contentStack.axis = .vertical
        contentStack.spacing = 12
        
        [achievedStampLabel, headerCardView, favoriteButton, stampImageView, stampTitleLabel, addressLabel, phoneNumberLabel, homePageLabel, achievedDateLabel, overviewLabel, overviewContentLabel, guideLabel, organizerLabel, contactLabel, getStampButton].forEach {
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
        
        //HeaderCard
        headerCardView.backgroundColor = .white
        
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
        
    }
    
    private func setupActions() {
        
    }
}
