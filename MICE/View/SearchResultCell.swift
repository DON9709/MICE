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
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let closedInfoLabel: UILabel = {
        let label = UILabel.createSubLabel()
        label.textColor = .systemRed
        return label
    }()
    
    private let hoursInfoLabel = UILabel.createSubLabel()
    private let missionInfoLabel = UILabel.createSubLabel()
    
    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀 기본 배경을 투명하게 해서 containerView의 그림자가 보이도록 함
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(thumbnailImageView)
        
        // 텍스트들을 담을 스택뷰
        let textStackView = UIStackView(arrangedSubviews: [placeNameLabel, closedInfoLabel, hoursInfoLabel, missionInfoLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 6
        textStackView.alignment = .leading
        
        containerView.addSubview(textStackView)
        
        // --- 제약 조건 설정 ---
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Configuration

    func configure(with result: SearchResult) {
        // thumbnailImageView.image = UIImage(named: result.imageName)
        placeNameLabel.text = result.placeName
        closedInfoLabel.text = result.closedInfo
        hoursInfoLabel.text = result.hoursInfo
        missionInfoLabel.text = result.missionInfo
    }
}

// UILabel 생성을 위한 간단한 Extension
fileprivate extension UILabel {
    static func createSubLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
}
