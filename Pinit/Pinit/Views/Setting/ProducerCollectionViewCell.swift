//
//  MyCollectionViewCell2.swift
//  SetUpViewEx
//
//  Created by InTak Han on 3/17/25.
//
import UIKit

class ProducerCollectionViewCell : UICollectionViewCell {
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
        return imageView
    }()
    
    private lazy var pinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold16.value
        label.textColor = .black
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
    
//    func configure(model: ProducerEntity) {
//        pinDateLabel.text = model.date.formatted()
//        pinTitleLabel.text = model.description
//        thumbnailImageView.image = UIImage(systemName: "house")
//        //thumbnailImageView.image = model.mediaPath ?? UIImage(systemName: "house")
//
//        cellSetting()
//    } //모델에서 데이터 가져오는 부분
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetting() {
        pinDateLabel.text = "2021-09-30"//model.date.formatted()
        pinTitleLabel.text = "title"//model.title
        thumbnailImageView.image = UIImage(systemName: "house")
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true //contentView에는 cornerRadius
        
        shadowContainerView.addSubview(contentView) //그림자 뷰에 contentView 추가
        addSubview(shadowContainerView)
        
        shadowContainerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.addSubviews(thumbnailImageView, pinTitleLabel, pinDateLabel)
        
        //img.contentMode = .scaleToFill
        thumbnailImageView.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(contentView.frame.width * 0.76)
        }
        pinTitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        pinDateLabel.snp.makeConstraints {
            $0.top.equalTo(pinTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
