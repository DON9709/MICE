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
    
    private lazy var bookmarkButton: UIButton = {
            let button = UIButton(type: .custom)

            button.setImage(UIImage(named: "Bookmark"), for: .normal)
            button.setImage(UIImage(named: "BookmarkActive"), for: .selected)
            
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
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
        containerView.addSubview(bookmarkButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        bookmarkButton.snp.makeConstraints { make in
                    make.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
                    make.trailing.equalToSuperview().inset(16)
                    make.width.height.equalTo(40)
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
    }
    
    // MARK: - Configuration
    func configure(with stamp: Stamp) {
        placeNameLabel.text = stamp.title ?? "이름 없음"
        stampCountLabel.text = "획득가능한 스탬프: 1개"
        addressLabel.text = "주소: \(stamp.addr)"
        
        bookmarkButton.isSelected = false // (나중에 실제 데이터와 연동 필요)
        
        // 이미지 로딩 로직
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
