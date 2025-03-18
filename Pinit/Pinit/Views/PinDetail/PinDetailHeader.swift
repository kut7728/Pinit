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
        self.backgroundColor = .gray
        
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 컴포넌트
    public lazy var pinDetailPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    public lazy var pinTitle: UILabel = {
        let label = UILabel()
        label.text = "San Francisco"
        return label
    }()
    
    public lazy var pinWeather: UILabel = {
        let label = UILabel()
        label.text = "CA"
        return label
    }()
    
    public lazy var pinDate: UILabel = {
        let label = UILabel()
        label.text = "2021-01-01"
        return label
    }()
    
    
    public lazy var pinMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    public lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    public lazy var pinDescription: UITextView = {
        let textView = UITextView()
        textView.text = "San Francisco is a city in California. San Francisco is a city in California. San Francisco is a city in California."
        return textView
    }()
    
    
    // MARK: - 레이아웃
    private func addComponents() {
        self.addSubview(pinDetailPanel)
        pinDetailPanel.addSubviews(pinTitle, pinWeather, pinDate, pinMenuButton, pinImageView, pinDescription)
//        self.addSubviews(pinTitle, pinWeather, pinDate, pinMenuButton, pinImageView, pinDescription)
        
        
        pinDetailPanel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(pinDescription).offset(20)
            
//            $0.edges.equalToSuperview()
        }
        
        // subView
        pinTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(10)

            $0.height.equalTo(20)
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
            $0.top.equalTo(pinTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
        pinImageView.snp.makeConstraints {
            $0.top.equalTo(pinDate.snp.bottom).offset(10)
//            $0.leading.equalTo(reviewText.snp.trailing).offset(10)
//            $0.trailing.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(100)
            
        }
        
        pinDescription.snp.makeConstraints {
            $0.top.equalTo(pinImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }
        
        
    }

}

#Preview {
    PinDetailHeader()
}

#Preview {
    PinDetailViewController()
}
