//
//  HomeViewCell.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import UIKit
import SnapKit
import Kingfisher

class ExhibitionCell: UICollectionViewCell {
    
    static let identifier = "ExhibitionCell"
    
    var onBookmarkTapped: ((_ contentId: String, _ isBookmarked: Bool) -> Void)?
    private var contentId: String?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "BookMark"), for: .normal)
        button.setImage(UIImage(named: "BookMark.fill"), for: .selected)
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
        contentId = nil
        onBookmarkTapped = nil
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(hoursLabel)
        containerView.addSubview(bookmarkButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 2, bottom: 8, right: 2))
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(172)
        }
        
        // ▼▼▼▼▼ 북마크 버튼의 top 제약조건 조정 (이미지에 더 가깝게) ▼▼▼▼▼
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8) // 이전 12 -> 8
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(44)
        }
        
        // ▼▼▼▼▼ 제목 라벨의 top 제약조건 조정 (북마크 버튼과 중앙 정렬 유지) ▼▼▼▼▼
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(bookmarkButton)
            make.trailing.lessThanOrEqualTo(bookmarkButton.snp.leading).offset(-8)
        }
        
        // ▼▼▼▼▼ 영업시간 라벨의 top 제약조건 조정 (제목 라벨에 더 가깝게) ▼▼▼▼▼
        hoursLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2) // 이전 4 -> 2
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
    }
    
    public func configure(with stamp: Stamp) {
        self.contentId = stamp.contentid
        titleLabel.text = stamp.title
        hoursLabel.text = "영업 시간 09:00 ~ 20:00"
        bookmarkButton.isSelected = stamp.isBookmarked
        
        if let imageURLString = stamp.image, let url = URL(string: imageURLString) {
            thumbnailImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
        }
    }
    
    @objc private func bookmarkButtonTapped() {
        bookmarkButton.isSelected.toggle()
        if let id = contentId {
            onBookmarkTapped?(id, bookmarkButton.isSelected)
        }
    }
}
