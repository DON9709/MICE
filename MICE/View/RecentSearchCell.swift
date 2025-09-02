//
//  RecentSearchCell.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import UIKit
import SnapKit

// 'X' 버튼 클릭 이벤트를 ViewController에 전달하기 위한 Delegate 프로토콜
protocol RecentSearchCellDelegate: AnyObject {
    func didTapDeleteButton(on cell: UITableViewCell)
}

class RecentSearchCell: UITableViewCell {
    
    static let identifier = "RecentSearchCell"
    weak var delegate: RecentSearchCellDelegate?

    private let searchIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "magnifyingglass")
        iv.tintColor = .gray
        return iv
    }()
    
    let queryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(searchIconImageView)
        contentView.addSubview(queryLabel)
        contentView.addSubview(deleteButton)
        
        searchIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        // [수정] queryLabel의 제약조건을 수정하여 셀의 높이를 명확하게 합니다.
        queryLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(12)
            // centerY 대신 top과 bottom 제약조건을 추가합니다.
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(queryLabel.snp.trailing).offset(12)
        }
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(on: self)
    }
}
