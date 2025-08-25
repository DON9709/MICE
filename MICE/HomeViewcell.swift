//
//  HomeViewcell.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import UIKit
import SnapKit

class ExhibitionCell: UICollectionViewCell {
    
    static let identifier = "ExhibitionCell"
    
    // MARK: - UI Components
    
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray // 이미지가 없을 경우를 대비한 배경색
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    // 찜(북마크) 버튼
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        // SF Symbols 사용 (iOS 13+)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        button.layer.cornerRadius = 15 // 원형 버튼
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        thumbnailImageView.addSubview(bookmarkButton)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150) // 높이 고정
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(30)
        }
    }
    
    // ViewModel의 데이터를 Cell에 바인딩하는 함수
    public func configure(with exhibition: Exhibition) {
        // thumbnailImageView.image = UIImage(named: exhibition.imageName) // 실제 이미지 로딩
        titleLabel.text = exhibition.title
        dateLabel.text = exhibition.date
        
        let bookmarkImageName = exhibition.isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: bookmarkImageName), for: .normal)
    }
}
