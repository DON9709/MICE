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

    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let closedInfoLabel = UILabel.createSubLabel()
    private let hoursInfoLabel = UILabel.createSubLabel()
    private let missionInfoLabel = UILabel.createSubLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [closedInfoLabel, hoursInfoLabel, missionInfoLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(stackView)
        
        placeNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(placeNameLabel)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with result: SearchResult) {
        placeNameLabel.text = result.placeName
        closedInfoLabel.text = result.closedInfo
        hoursInfoLabel.text = result.hoursInfo
        missionInfoLabel.text = result.missionInfo
    }
}

// UILabel 생성 Extension
fileprivate extension UILabel {
    static func createSubLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
}
