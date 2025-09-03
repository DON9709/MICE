//
//  SearchResultCell.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import UIKit
import SnapKit

class SearchResultCell: UITableViewCell {

    static let identifier = "SearchResultCell"
    
    // MARK: - UI Components
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
        iv.backgroundColor = .systemGray6
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.clipsToBounds = true
        return iv
    }()

    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let stampCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(red: 114/255.0, green: 76/255.0, blue: 249/255.0, alpha: 1)
        return label
    }()
    
    private let addressLabel: UILabel = UILabel.createSubLabel()
    
    // [수정] 찜 버튼 - SF Symbols 사용, 배경/테두리 없음, tintColor로 색상 제어
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system) // 다시 .system 타입으로 변경
        // 비선택 시: 테두리만 있는 북마크 (Image 1과 유사)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        // 선택 시: 채워진 북마크 (Image 2와 유사)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        
        // 버튼 배경색은 항상 투명
        button.backgroundColor = .clear
        
        // 초기 아이콘 색상은 회색
        button.tintColor = .systemGray3
        
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var currentImageURL: URL?
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        
        let textStackView = UIStackView(arrangedSubviews: [placeNameLabel, stampCountLabel, addressLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 6
        textStackView.alignment = .leading
        
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(textStackView)
        containerView.addSubview(bookmarkButton) // 찜 버튼 추가
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(16) // 이미지 하단에서 16pt 아래
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(bookmarkButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Reuse Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        currentImageURL = nil
        bookmarkButton.isSelected = false
        updateBookmarkButtonColor() // 버튼 색상 초기화 적용
    }
    
    // MARK: - Configuration
    func configure(with stamp: Stamp) {
        placeNameLabel.text = stamp.title ?? "이름 없음"
        //하드코딩된 텍스트 설정
        stampCountLabel.text = "획득가능한 스탬프: 1개"
        addressLabel.text = "주소: \(stamp.addr)"
        bookmarkButton.isSelected = false
        updateBookmarkButtonColor()
        
       
        thumbnailImageView.image = nil
        if let imageURLString = stamp.image, let url = URL(string: imageURLString) {
            currentImageURL = url
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, self.currentImageURL == url else { return }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { self.thumbnailImageView.image = image }
                } else {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = UIImage(systemName: "photo")
                        self.thumbnailImageView.contentMode = .scaleAspectFit
                    }
                }
            }.resume()
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
            thumbnailImageView.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - Actions
    @objc private func bookmarkButtonTapped() {
        bookmarkButton.isSelected.toggle()
        updateBookmarkButtonColor() // 탭할 때마다 색상 업데이트
    }
    
    private func updateBookmarkButtonColor() {
        let purpleColor = UIColor(red: 114/255.0, green: 76/255.0, blue: 249/255.0, alpha: 1)
        
        if bookmarkButton.isSelected {
            bookmarkButton.tintColor = purpleColor // 선택 시: 보라색 아이콘
        } else {
            bookmarkButton.tintColor = .systemGray3 // 비선택 시: 회색 아이콘
        }
    }
}

fileprivate extension UILabel {
    static func createSubLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
}
