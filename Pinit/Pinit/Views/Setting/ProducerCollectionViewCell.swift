//
//  MyCollectionViewCell2.swift
//  SetUpViewEx
//
//  Created by InTak Han on 3/17/25.
//
import UIKit

class ProducerCollectionViewCell : UICollectionViewCell {
    //그림자 뷰 추가
    public let shadowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    
    public lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold16.value
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = UIColor(hex: "808080")
        label.sizeToFit()
        return label
    }()
    
    func configure(model: PinEntity) {

        dateLabel.text = model.date.snakeCaseDateString()
        titleLabel.text = model.title
        thumbnailImageView.image = model.mediaPath
        
        cellSetting()
    } //모델(SettingView의 data)에서 데이터 가져오는 부분
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetting() {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true //contentView에는 cornerRadius
        
        shadowContainerView.addSubview(contentView) //그림자 뷰에 contentView 추가
        addSubview(shadowContainerView)
        
        shadowContainerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.addSubviews(thumbnailImageView, titleLabel, dateLabel)
        
        thumbnailImageView.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(contentView.frame.width * 0.76)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
