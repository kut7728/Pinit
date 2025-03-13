//
//  PinRecordCell.swift
//  Pinit
//
//  Created by 안정흠 on 3/13/25.
//

import UIKit

final class PinRecordCell: UICollectionViewCell {
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var pinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold20.value
        return label
    }()
    private lazy var pinDateLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        return label
    }()
    
    func configure(model: PinEntity) {
        pinDateLabel.text = model.date
        pinTitleLabel.text = model.description ?? "제목임미다"
        thumbnailImageView.image = UIImage(systemName: "house")
//        thumbnailImageView.image = model.mediaPath ?? UIImage(systemName: "house")
    }
    
    private func setupLayout() {
        contentView.addSubviews(thumbnailImageView, pinTitleLabel, pinDateLabel)
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.width)
        }
        pinTitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).inset(8)
            $0.leading.trailing.equalToSuperview()
        }
        pinDateLabel.snp.makeConstraints {
            $0.top.equalTo(pinTitleLabel.snp.bottom).inset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
}
