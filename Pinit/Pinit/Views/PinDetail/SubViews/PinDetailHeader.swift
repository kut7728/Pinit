//
//  NewPinReviewPanel.swift
//  Pinit
//
//  Created by nelime on 3/17/25.
//

import UIKit

class PinDetailHeader: UIView {
    
    private var entity: PinEntity

    // MARK: - init
    init(entity: PinEntity) {
        self.entity = entity
        super.init(frame: .zero)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 컴포넌트
    
    // 핀 상세 뷰 컨테이너
    private lazy var pinDetailPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 핀 제목
    private lazy var pinTitle: UILabel = {
        let label = UILabel()
        label.text = entity.title
        label.font = DesignSystemFont.Pretendard_Bold30.value
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var pinWeather: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: entity.weather)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // 핀 생성 날짜
    private lazy var pinDate: UILabel = {
        let label = UILabel()
        label.text = entity.date.koreanDateString()
        label.textColor = .gray
        return label
    }()
    
    // 핀 메뉴 버튼
    public lazy var pinMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = DesignSystemColor.Lavender.value
        return button
    }()
    
    // 핀 사진
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = entity.mediaPath
        imageView.backgroundColor = DesignSystemColor.Lavender.value.withAlphaComponent(0.7)
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = DesignSystemColor.Lavender10.value.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 핀 추가 설명
    private lazy var pinDescription: UITextView = {
        let textView = UITextView()
        textView.text = entity.description
        textView.font = DesignSystemFont.Pretendard_Medium16.value
        textView.isScrollEnabled = false // 내부 텍스트가 길어질 때 자동으로 늘어나도록 설정
        textView.sizeToFit()
        return textView
    }()
    
    public lazy var reviewSectionTitle: UILabel = {
       let label = UILabel()
        label.text = "리뷰"
        label.font = DesignSystemFont.Pretendard_Bold20.value
        return label
    }()
    
    // MARK: - 레이아웃
    private func addComponents() {
        self.addSubview(pinDetailPanel)
        pinDetailPanel.addSubviews(pinTitle,
                                   pinWeather,
                                   pinDate,
                                   pinMenuButton,
                                   pinImageView,
                                   pinDescription,
                                   reviewSectionTitle)
        
        
        pinDetailPanel.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(reviewSectionTitle).offset(10)
        }
        
        // subView
        pinTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.width.lessThanOrEqualTo(260)
            $0.width.greaterThanOrEqualTo(160)
            $0.leading.equalToSuperview().inset(10)
        }
        
        pinWeather.snp.makeConstraints {
            $0.trailing.equalTo(pinMenuButton.snp.leading).offset(-10)
            
            $0.top.equalTo(pinTitle).offset(5)
            $0.width.height.equalTo(40)
        }
        
        pinMenuButton.snp.makeConstraints {
            $0.centerY.equalTo(pinTitle)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        pinDate.snp.makeConstraints {
            $0.top.equalTo(pinTitle.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        
        pinImageView.snp.makeConstraints {
            $0.top.equalTo(pinDate.snp.bottom).offset(20)
            
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250)
            
            if pinImageView.image == nil {
                $0.height.equalTo(0)
            } else {
                $0.height.equalTo(160)
            }
        }
        
        
        pinDescription.snp.makeConstraints {
            $0.top.equalTo(pinImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            
            if pinDescription.text == nil || pinDescription.text == "" {
                $0.height.equalTo(0)
            }
        }
        
        reviewSectionTitle.snp.makeConstraints {
            $0.top.equalTo(pinDescription.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(10)
            
        }
    }
}


#Preview {
    PinDetailViewController(PinEntity.producerData[1], isPin: true)
}
