//
//  PinRecordCell.swift
//  Pinit
//
//  Created by 안정흠 on 3/13/25.
//

import UIKit

final class PinRecordCell: UICollectionViewCell {
    //그림자 뷰 추가
    private let shadowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var pinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold16.value
        label.sizeToFit()
        return label
    }()
    private lazy var pinDateLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = UIColor(hex: "808080")
        label.sizeToFit()
        return label
    }()
    
    func configure(model: PinEntity) {
        pinDateLabel.text = model.date
        pinTitleLabel.text = model.description
        thumbnailImageView.image = UIImage(systemName: "house")
        //thumbnailImageView.image = model.mediaPath ?? UIImage(systemName: "house")
        
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true //contentView에는 cornerRadius
        
        shadowContainerView.addSubview(contentView) //그림자 뷰에 contentView 추가
        addSubview(shadowContainerView)
        
        shadowContainerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.addSubviews(thumbnailImageView, pinTitleLabel, pinDateLabel)
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(contentView.frame.width * 0.76)
        }
        pinTitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        pinDateLabel.snp.makeConstraints {
            $0.top.equalTo(pinTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
    }
}
