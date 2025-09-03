//
//  SearchResultCell.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultCell: UITableViewCell {

    static let identifier = "SearchResultCell"
    
    // ▼▼▼▼▼ 콜백과 contentId 저장을 위한 프로퍼티 추가 ▼▼▼▼▼
    var onBookmarkTapped: ((_ contentId: String, _ isBookmarked: Bool) -> Void)?
    private var contentId: String?
    
    // ... (UI Components 및 나머지 코드는 이전과 동일) ...
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
    
    private let acquisitionStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let addressLabel: UILabel = UILabel.createSubLabel()
    
    private lazy var bookmarkButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "Bookmark"), for: .normal)
            button.setImage(UIImage(named: "BookMark.fil"), for: .selected)
            button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
            return button
        }()
    
    private var currentImageURL: URL?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd 획득"
        return formatter
    }()
    
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
    
    private func setupUI() {
        contentView.addSubview(containerView)
        
        let textStackView = UIStackView(arrangedSubviews: [placeNameLabel, acquisitionStatusLabel, addressLabel])
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        currentImageURL = nil
        bookmarkButton.isSelected = false
    }

    func configure(with stamp: Stamp) {
        // ▼▼▼▼▼ contentId를 셀 내부에 저장 ▼▼▼▼▼
        self.contentId = stamp.contentid
        
        placeNameLabel.text = stamp.title ?? "이름 없음"
        addressLabel.text = "주소: \(stamp.addr)"
        
        if stamp.isAcquired {
            if let date = stamp.acquiredAt {
                acquisitionStatusLabel.text = dateFormatter.string(from: date)
            } else {
                acquisitionStatusLabel.text = "획득"
            }
            acquisitionStatusLabel.textColor = UIColor(red: 114/255.0, green: 76/25_5.0, blue: 249/255.0, alpha: 1)
        } else {
            acquisitionStatusLabel.text = "미획득 스탬프"
            acquisitionStatusLabel.textColor = .gray
        }
        
        bookmarkButton.isSelected = stamp.isBookmarked
        
        if let imageURLString = stamp.image, let url = URL(string: imageURLString) {
            thumbnailImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
            thumbnailImageView.contentMode = .scaleAspectFit
        }
    }
    
    @objc private func bookmarkButtonTapped() {
        // ▼▼▼▼▼ 버튼 상태를 바꾸고 콜백으로 이벤트 전달 ▼▼▼▼▼
        bookmarkButton.isSelected.toggle()
        if let id = contentId {
            onBookmarkTapped?(id, bookmarkButton.isSelected)
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
