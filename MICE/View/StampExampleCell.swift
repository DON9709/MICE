//
//  StampExampleCell.swift
//  MICE
//
//  Created by 송명균 on 8/29/25.
//

import UIKit
import SnapKit

class StampExampleCell: UICollectionViewCell {
    
    static let identifier = "StampExampleCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
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
            make.centerX.equalToSuperview()
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
    
    func configure(with example: StampExample) {
        titleLabel.text = example.title
        dateLabel.text = example.date
    }
}
