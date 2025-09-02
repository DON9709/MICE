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
        // [수정] 상단 두 모서리만 둥글게 처리
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.clipsToBounds = true
        return iv
    }()

    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let closedInfoLabel: UILabel = UILabel.createSubLabel() // 주소
    private let hoursInfoLabel = UILabel.createSubLabel() // 전화번호
    private let missionInfoLabel = UILabel.createSubLabel() // 스탬프 번호
    
    // 이미지 로딩 중 셀 재사용 문제를 해결하기 위한 프로퍼티
    private var currentImageURL: URL?
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear // contentView의 색상이 보이도록
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup (기존 레이아웃으로 복원)
    private func setupUI() {
        contentView.addSubview(containerView)
        
        // 텍스트 레이블들을 StackView로 묶어 관리 (기존 방식)
        let textStackView = UIStackView(arrangedSubviews: [placeNameLabel, closedInfoLabel, hoursInfoLabel, missionInfoLabel])
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
            make.height.equalTo(150) // 이미지 높이
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
        closedInfoLabel.text = "주소: \(stamp.addr)"
        hoursInfoLabel.text = "전화번호: \(stamp.tel?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? stamp.tel! : "정보 없음")"
        if let stampNo = stamp.stampno {
            missionInfoLabel.text = "스탬프 번호: \(stampNo)번"
        } else {
            missionInfoLabel.text = "스탬프 정보 없음"
        }

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
                        self.thumbnailImageView.contentMode = .scaleAspectFit // 아이콘이 잘 보이도록
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
