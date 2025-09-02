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
        return label
    }()
    
    // [추가] 획득 가능한 스탬프 레이블
    private let stampCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemRed // 빨간색 글씨
        return label
    }()
    
    private let addressLabel: UILabel = UILabel.createSubLabel() // 주소
    private let phoneLabel = UILabel.createSubLabel() // 전화번호
    private let stampNumberLabel = UILabel.createSubLabel() // 스탬프 번호
    
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
        
        // [수정] 텍스트 레이블들을 StackView에 추가 (순서 변경)
        let textStackView = UIStackView(arrangedSubviews: [placeNameLabel, stampCountLabel, addressLabel, phoneLabel, stampNumberLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 6
        textStackView.alignment = .leading
        
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(textStackView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Reuse Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        currentImageURL = nil
    }
    
    // MARK: - Configuration
    func configure(with stamp: Stamp) {
        placeNameLabel.text = stamp.title ?? "이름 없음"
        
        //하드코딩된 텍스트 설정
        stampCountLabel.text = "획득가능한 스탬프: 1개"
        
        addressLabel.text = "주소: \(stamp.addr)"
        
        // 이미지 로딩 로직
        thumbnailImageView.image = nil
        if let imageURLString = stamp.image, let url = URL(string: imageURLString) {
            currentImageURL = url
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, self.currentImageURL == url else { return }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
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
}

fileprivate extension UILabel {
    static func createSubLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
}
