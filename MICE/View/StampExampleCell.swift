//
//  StampExampleCell.swift
//  MICE
//
//  Created by 송명균 on 8/29/25.
//

import UIKit
import SnapKit
import Kingfisher

class StampExampleCell: UICollectionViewCell {
    
    static let identifier = "StampExampleCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter
    }()
    
    private var dashedBorderLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addDashedBorder() {
        dashedBorderLayer?.removeFromSuperlayer()
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.systemGray3.cgColor
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = nil
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
        self.layer.addSublayer(shapeLayer)
        self.dashedBorderLayer = shapeLayer
    }
    
    // ▼▼▼▼▼ 이미지 로딩 및 디버깅 로직 강화 ▼▼▼▼▼
    func configure(with stamp: Stamp) {
        titleLabel.text = stamp.title
        
        if let date = stamp.acquiredAt {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "날짜 없음"
        }
        
        // 1. stamp.stampimg 데이터가 유효한지 확인
        guard let urlString = stamp.stampimg, !urlString.isEmpty else {
            // URL 문자열이 없거나 비어있는 경우
            print("[\(stamp.title ?? "제목 없음")] 오류: stampimg URL이 비어있습니다.")
            imageView.image = UIImage(systemName: "photo.on.rectangle.angled") // 에러 표시 아이콘
            return
        }
        
        // 2. 문자열을 URL 객체로 변환할 수 있는지 확인
        guard let url = URL(string: urlString) else {
            // URL 형식이 잘못된 경우
            print("[\(stamp.title ?? "제목 없음")] 오류: 잘못된 URL 형식입니다 -> \(urlString)")
            imageView.image = UIImage(systemName: "xmark.circle.fill") // 에러 표시 아이콘
            return
        }
        
        // 3. URL이 유효하면 Kingfisher로 이미지 로드
        imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
    }
}
