//
//  NewPinReviewPanel.swift
//  Pinit
//
//  Created by nelime on 3/17/25.
//

import UIKit

class PinDetailHeader: UIView {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 컴포넌트
    
    // 핀 상세 뷰 컨테이너
    public lazy var pinDetailPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 핀 제목
    public lazy var pinTitle: UILabel = {
        let label = UILabel()
        label.text = "핀 제목 예시"
        label.font = DesignSystemFont.Pretendard_Bold30.value
        return label
    }()
    
    // 핀 날씨
    public lazy var pinWeather: UILabel = {
        let label = UILabel()
        label.text = "맑음"
        return label
    }()
    
    // 핀 생성 날짜
    public lazy var pinDate: UILabel = {
        let label = UILabel()
        label.text = "2021년 1월 1일"
        label.textColor = .gray
        return label
    }()
    
    // 핀 메뉴 버튼
    public lazy var pinMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // 핀 사진
    public lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sampleImg.jpg")
        return imageView
    }()
    
    // 핀 추가 설명
    public lazy var pinDescription: UITextView = {
        let textView = UITextView()
        textView.text = "San Francisco is a city in California. San Francisco is a city in California. San Francisco is a city in California."
        return textView
    }()
    
    
    // MARK: - 레이아웃
    private func addComponents() {
        self.addSubview(pinDetailPanel)
        pinDetailPanel.addSubviews(pinTitle, pinWeather, pinDate, pinMenuButton, pinImageView, pinDescription)
        
        
        pinDetailPanel.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(pinDescription).offset(10)
        }
        
        // subView
        pinTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }
        
        pinWeather.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalTo(pinTitle.snp.trailing).offset(10)
        }
        
        pinMenuButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            
        }
        
        pinDate.snp.makeConstraints {
            $0.top.equalTo(pinTitle.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
        }
        
        pinImageView.snp.makeConstraints {
            $0.top.equalTo(pinDate.snp.bottom).offset(20)
            
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(160)
        }
        
        pinDescription.snp.makeConstraints {
            $0.top.equalTo(pinImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}

#Preview {
    PinDetailHeader()
}

#Preview {
    PinDetailViewController()
}
